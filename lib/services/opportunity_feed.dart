
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class NGO {
  final String name;
  final String city;
  const NGO({required this.name, required this.city});
}

class NearbyPlace {
    final String name;
    const NearbyPlace({required this.name});
}

class Competition {
    final String name;
    const Competition({required this.name});
}

class OpportunityFeedNotifier extends StateNotifier<OpportunityFeed> {
  OpportunityFeedNotifier() : super(OpportunityFeed());

  Future<void> discover() async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false, error: "Location services disabled. Please enable to discover opportunities.");
  }

  Future<void> searchCity(String city) async {
    state = state.copyWith(isLoading: true, error: null, cityName: city);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
        isLoading: false,
        ngos: [NGO(name: 'Example NGO in $city', city: city)],
        competitions: [Competition(name: 'Example Competition')],
        openNow: [Competition(name: 'Example Open Now Comp')]
      );
  }
}

final opportunityFeedProvider = StateNotifierProvider<OpportunityFeedNotifier, OpportunityFeed>((ref) {
  return OpportunityFeedNotifier();
});
