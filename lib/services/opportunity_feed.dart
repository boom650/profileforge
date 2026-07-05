/// Combined opportunity discovery — brings together all free services.
/// Auto-discovers NGOs, nearby places, and competitions based on user profile.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';
import 'nominatim_service.dart';
import 'overpass_service.dart';
import 'ngo_darpan_service.dart';
import 'competition_calendar_service.dart';

/// Combined opportunity data for the discovery feed.
class OpportunityFeed {
  final UserLocation? location;
  final String? cityName;
  final List<NGO> ngos;
  final List<NearbyPlace> nearbyPlaces;
  final List<Competition> competitions;
  final List<Competition> openNow;
  final bool isLoading;
  final String? error;

  const OpportunityFeed({
    this.location,
    this.cityName,
    this.ngos = const [],
    this.nearbyPlaces = const [],
    this.competitions = const [],
    this.openNow = const [],
    this.isLoading = false,
    this.error,
  });

  OpportunityFeed copyWith({
    UserLocation? location,
    String? cityName,
    List<NGO>? ngos,
    List<NearbyPlace>? nearbyPlaces,
    List<Competition>? competitions,
    List<Competition>? openNow,
    bool? isLoading,
    String? error,
  }) {
    return OpportunityFeed(
      location: location ?? this.location,
      cityName: cityName ?? this.cityName,
      ngos: ngos ?? this.ngos,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      competitions: competitions ?? this.competitions,
      openNow: openNow ?? this.openNow,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier that orchestrates all opportunity discovery.
class OpportunityFeedNotifier extends StateNotifier<OpportunityFeed> {
  final LocationServiceBase _locationService;
  final NominatimService _nominatim;
  final OverpassService _overpass;
  final NGODarpanService _ngoDarpan;
  final CompetitionCalendarService _competitions;

  OpportunityFeedNotifier({
    required LocationServiceBase locationService,
    required NominatimService nominatim,
    required OverpassService overpass,
    required NGODarpanService ngoDarpan,
    required CompetitionCalendarService competitions,
  })  : _locationService = locationService,
        _nominatim = nominatim,
        _overpass = overpass,
        _ngoDarpan = ngoDarpan,
        _competitions = competitions,
        super(const OpportunityFeed(isLoading: true));

  /// Full discovery — gets location, then fetches everything.
  Future<void> discover({int? grade}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. Get device location
      final location = await _locationService.getCurrentLocation();
      if (location == null) {
        // Location unavailable — skip geolocation, just fetch competitions
        // and show the city search prompt instead of an error
        final gradeArg = grade ?? 11;
        final compFuture = Future.value(_competitions.getForGrade(gradeArg));
        final openFuture = Future.value(_competitions.getOpenNow());

        final results = await Future.wait([compFuture, openFuture]);

        state = state.copyWith(
          competitions: results[0] as List<Competition>,
          openNow: results[1] as List<Competition>,
          isLoading: false,
          error: 'Location not available',
        );
        return;
      }

      // 2. Reverse geocode to get city name
      final geoResult = await _nominatim.reverse(
        location.latitude,
        location.longitude,
      );
      final city = geoResult?.city ?? 'Unknown';

      // 3. Fetch nearby places (parallel)
      final nearbyFuture = _overpass.findNearby(
        location.latitude,
        location.longitude,
        radiusKm: 30,
      );

      // 4. Fetch NGOs for this city
      final ngoFuture = _ngoDarpan.searchNGOs(city);

      // 5. Get competitions for this grade
      final gradeArg = grade ?? 11;
      final compFuture = Future.value(_competitions.getForGrade(gradeArg));
      final openFuture = Future.value(_competitions.getOpenNow());

      // Wait for all
      final results = await Future.wait([
        nearbyFuture,
        ngoFuture,
        compFuture,
        openFuture,
      ]);

      state = state.copyWith(
        location: location.copyWith(city: city, state: geoResult?.state),
        cityName: city,
        nearbyPlaces: results[0] as List<NearbyPlace>,
        ngos: results[1] as List<NGO>,
        competitions: results[2] as List<Competition>,
        openNow: results[3] as List<Competition>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to discover opportunities: $e',
      );
    }
  }

  /// Manual city search (when location is unavailable).
  Future<void> searchCity(String city, {int? grade}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ngos = await _ngoDarpan.searchNGOs(city);
      final gradeArg = grade ?? 11;
      final comps = _competitions.getForGrade(gradeArg);
      final open = _competitions.getOpenNow();

      state = state.copyWith(
        cityName: city,
        ngos: ngos,
        competitions: comps,
        openNow: open,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Search failed: $e');
    }
  }
}

final opportunityFeedProvider =
    StateNotifierProvider<OpportunityFeedNotifier, OpportunityFeed>((ref) {
  return OpportunityFeedNotifier(
    locationService: ref.read(locationServiceProvider),
    nominatim: ref.read(nominatimServiceProvider),
    overpass: ref.read(overpassServiceProvider),
    ngoDarpan: ref.read(ngoDarpanServiceProvider),
    competitions: ref.read(competitionCalendarProvider),
  );
});
