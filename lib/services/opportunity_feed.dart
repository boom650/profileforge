import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/services/ngo_darpan_service.dart';
import 'package:profileforge/services/overpass_service.dart';
import 'package:profileforge/services/competition_calendar_service.dart';

/// Aggregated discovery feed shown on the Opportunities tab.
class OpportunityFeed {
  final List<NGO> ngos;
  final List<NearbyPlace> nearbyPlaces;
  final List<Competition> competitions;
  final List<Competition> openNow;
  final bool isLoading;
  final String? error;
  final String? cityName;

  OpportunityFeed({
    this.ngos = const [],
    this.nearbyPlaces = const [],
    this.competitions = const [],
    this.openNow = const [],
    this.isLoading = false,
    this.error,
    this.cityName,
  });

  OpportunityFeed copyWith({
    List<NGO>? ngos,
    List<NearbyPlace>? nearbyPlaces,
    List<Competition>? competitions,
    List<Competition>? openNow,
    bool? isLoading,
    String? error,
    String? cityName,
  }) {
    return OpportunityFeed(
      ngos: ngos ?? this.ngos,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      competitions: competitions ?? this.competitions,
      openNow: openNow ?? this.openNow,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      cityName: cityName ?? this.cityName,
    );
  }
}

class OpportunityFeedNotifier extends StateNotifier<OpportunityFeed> {
  OpportunityFeedNotifier() : super(OpportunityFeed());

  Future<void> discover() async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
        isLoading: false,
        error:
            'Location services disabled. Please enable to discover opportunities.');
  }

  Future<void> searchCity(String city) async {
    state = state.copyWith(isLoading: true, error: null, cityName: city);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      isLoading: false,
      ngos: [
        NGO(
          id: 'example',
          name: 'Example NGO in $city',
          city: city,
          state: '',
          focus: 'education',
        )
      ],
      competitions: [
        Competition(
          id: 'example-comp',
          name: 'Example Competition',
          category: 'olympiad',
          registrationStart: DateTime.now(),
          registrationEnd: DateTime.now().add(const Duration(days: 30)),
          examDate: DateTime.now().add(const Duration(days: 45)),
          eligibility: 'class_9_12',
          website: '',
          description: 'Example competition description.',
        )
      ],
      openNow: [
        Competition(
          id: 'example-open',
          name: 'Example Open Now Comp',
          category: 'hackathon',
          registrationStart: DateTime.now(),
          registrationEnd: DateTime.now().add(const Duration(days: 10)),
          examDate: DateTime.now().add(const Duration(days: 15)),
          eligibility: 'class_11_12',
          website: '',
          description: 'Example open competition.',
        )
      ],
    );
  }
}

final opportunityFeedProvider =
    StateNotifierProvider<OpportunityFeedNotifier, OpportunityFeed>((ref) {
  return OpportunityFeedNotifier();
});
