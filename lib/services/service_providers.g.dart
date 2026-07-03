// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ngoDarpanServiceHash() => r'2deccc285814b15da70988f0d6de09897d380072';

/// See also [ngoDarpanService].
@ProviderFor(ngoDarpanService)
final ngoDarpanServiceProvider = AutoDisposeProvider<NGODarpanService>.internal(
  ngoDarpanService,
  name: r'ngoDarpanServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ngoDarpanServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NgoDarpanServiceRef = AutoDisposeProviderRef<NGODarpanService>;
String _$googlePlacesServiceHash() =>
    r'989fca2464c3e0aeb2b7a02b447ac362548bd507';

/// See also [googlePlacesService].
@ProviderFor(googlePlacesService)
final googlePlacesServiceProvider =
    AutoDisposeProvider<GooglePlacesService>.internal(
  googlePlacesService,
  name: r'googlePlacesServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googlePlacesServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GooglePlacesServiceRef = AutoDisposeProviderRef<GooglePlacesService>;
String _$udiseSchoolServiceHash() =>
    r'd19dbc8a0a6704e33dc370cb71f78038adf94646';

/// See also [udiseSchoolService].
@ProviderFor(udiseSchoolService)
final udiseSchoolServiceProvider =
    AutoDisposeProvider<UDISESchoolService>.internal(
  udiseSchoolService,
  name: r'udiseSchoolServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$udiseSchoolServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UdiseSchoolServiceRef = AutoDisposeProviderRef<UDISESchoolService>;
String _$atlLabServiceHash() => r'ce5bd36b7843a147cd4be80ff4a47cffeddd2d27';

/// See also [atlLabService].
@ProviderFor(atlLabService)
final atlLabServiceProvider = AutoDisposeProvider<ATLLabService>.internal(
  atlLabService,
  name: r'atlLabServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$atlLabServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AtlLabServiceRef = AutoDisposeProviderRef<ATLLabService>;
String _$competitionCalendarServiceHash() =>
    r'03990778a1c13babbff508f26665e5e83239bcb0';

/// See also [competitionCalendarService].
@ProviderFor(competitionCalendarService)
final competitionCalendarServiceProvider =
    AutoDisposeProvider<CompetitionCalendarService>.internal(
  competitionCalendarService,
  name: r'competitionCalendarServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$competitionCalendarServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompetitionCalendarServiceRef
    = AutoDisposeProviderRef<CompetitionCalendarService>;
String _$opportunityDiscoveryEngineHash() =>
    r'68e31e72b358f4dae218d8d35bb225e0a10ff995';

/// See also [opportunityDiscoveryEngine].
@ProviderFor(opportunityDiscoveryEngine)
final opportunityDiscoveryEngineProvider =
    AutoDisposeProvider<OpportunityDiscoveryEngine>.internal(
  opportunityDiscoveryEngine,
  name: r'opportunityDiscoveryEngineProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$opportunityDiscoveryEngineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OpportunityDiscoveryEngineRef
    = AutoDisposeProviderRef<OpportunityDiscoveryEngine>;
String _$initializeOpportunityServicesHash() =>
    r'f546c84d87dd6cff5b666cca8812e4c5ee025618';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [initializeOpportunityServices].
@ProviderFor(initializeOpportunityServices)
const initializeOpportunityServicesProvider =
    InitializeOpportunityServicesFamily();

/// See also [initializeOpportunityServices].
class InitializeOpportunityServicesFamily extends Family<AsyncValue<void>> {
  /// See also [initializeOpportunityServices].
  const InitializeOpportunityServicesFamily();

  /// See also [initializeOpportunityServices].
  InitializeOpportunityServicesProvider call({
    required String googlePlacesApiKey,
  }) {
    return InitializeOpportunityServicesProvider(
      googlePlacesApiKey: googlePlacesApiKey,
    );
  }

  @override
  InitializeOpportunityServicesProvider getProviderOverride(
    covariant InitializeOpportunityServicesProvider provider,
  ) {
    return call(
      googlePlacesApiKey: provider.googlePlacesApiKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'initializeOpportunityServicesProvider';
}

/// See also [initializeOpportunityServices].
class InitializeOpportunityServicesProvider
    extends AutoDisposeFutureProvider<void> {
  /// See also [initializeOpportunityServices].
  InitializeOpportunityServicesProvider({
    required String googlePlacesApiKey,
  }) : this._internal(
          (ref) => initializeOpportunityServices(
            ref as InitializeOpportunityServicesRef,
            googlePlacesApiKey: googlePlacesApiKey,
          ),
          from: initializeOpportunityServicesProvider,
          name: r'initializeOpportunityServicesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$initializeOpportunityServicesHash,
          dependencies: InitializeOpportunityServicesFamily._dependencies,
          allTransitiveDependencies:
              InitializeOpportunityServicesFamily._allTransitiveDependencies,
          googlePlacesApiKey: googlePlacesApiKey,
        );

  InitializeOpportunityServicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.googlePlacesApiKey,
  }) : super.internal();

  final String googlePlacesApiKey;

  @override
  Override overrideWith(
    FutureOr<void> Function(InitializeOpportunityServicesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InitializeOpportunityServicesProvider._internal(
        (ref) => create(ref as InitializeOpportunityServicesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        googlePlacesApiKey: googlePlacesApiKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _InitializeOpportunityServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InitializeOpportunityServicesProvider &&
        other.googlePlacesApiKey == googlePlacesApiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, googlePlacesApiKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InitializeOpportunityServicesRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `googlePlacesApiKey` of this provider.
  String get googlePlacesApiKey;
}

class _InitializeOpportunityServicesProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with InitializeOpportunityServicesRef {
  _InitializeOpportunityServicesProviderElement(super.provider);

  @override
  String get googlePlacesApiKey =>
      (origin as InitializeOpportunityServicesProvider).googlePlacesApiKey;
}

String _$nearbyNGOsHash() => r'e97c2513bcb9b35295a7185edb640a9863140ea3';

/// See also [nearbyNGOs].
@ProviderFor(nearbyNGOs)
const nearbyNGOsProvider = NearbyNGOsFamily();

/// See also [nearbyNGOs].
class NearbyNGOsFamily extends Family<AsyncValue<List<NGOOpportunity>>> {
  /// See also [nearbyNGOs].
  const NearbyNGOsFamily();

  /// See also [nearbyNGOs].
  NearbyNGOsProvider call({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    String? sector,
  }) {
    return NearbyNGOsProvider(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      sector: sector,
    );
  }

  @override
  NearbyNGOsProvider getProviderOverride(
    covariant NearbyNGOsProvider provider,
  ) {
    return call(
      userProfile: provider.userProfile,
      latitude: provider.latitude,
      longitude: provider.longitude,
      radiusKm: provider.radiusKm,
      sector: provider.sector,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbyNGOsProvider';
}

/// See also [nearbyNGOs].
class NearbyNGOsProvider
    extends AutoDisposeFutureProvider<List<NGOOpportunity>> {
  /// See also [nearbyNGOs].
  NearbyNGOsProvider({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    String? sector,
  }) : this._internal(
          (ref) => nearbyNGOs(
            ref as NearbyNGOsRef,
            userProfile: userProfile,
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            sector: sector,
          ),
          from: nearbyNGOsProvider,
          name: r'nearbyNGOsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbyNGOsHash,
          dependencies: NearbyNGOsFamily._dependencies,
          allTransitiveDependencies:
              NearbyNGOsFamily._allTransitiveDependencies,
          userProfile: userProfile,
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          sector: sector,
        );

  NearbyNGOsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userProfile,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.sector,
  }) : super.internal();

  final UserProfile userProfile;
  final double latitude;
  final double longitude;
  final double radiusKm;
  final String? sector;

  @override
  Override overrideWith(
    FutureOr<List<NGOOpportunity>> Function(NearbyNGOsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyNGOsProvider._internal(
        (ref) => create(ref as NearbyNGOsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userProfile: userProfile,
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        sector: sector,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<NGOOpportunity>> createElement() {
    return _NearbyNGOsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyNGOsProvider &&
        other.userProfile == userProfile &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radiusKm == radiusKm &&
        other.sector == sector;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userProfile.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);
    hash = _SystemHash.combine(hash, radiusKm.hashCode);
    hash = _SystemHash.combine(hash, sector.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearbyNGOsRef on AutoDisposeFutureProviderRef<List<NGOOpportunity>> {
  /// The parameter `userProfile` of this provider.
  UserProfile get userProfile;

  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;

  /// The parameter `radiusKm` of this provider.
  double get radiusKm;

  /// The parameter `sector` of this provider.
  String? get sector;
}

class _NearbyNGOsProviderElement
    extends AutoDisposeFutureProviderElement<List<NGOOpportunity>>
    with NearbyNGOsRef {
  _NearbyNGOsProviderElement(super.provider);

  @override
  UserProfile get userProfile => (origin as NearbyNGOsProvider).userProfile;
  @override
  double get latitude => (origin as NearbyNGOsProvider).latitude;
  @override
  double get longitude => (origin as NearbyNGOsProvider).longitude;
  @override
  double get radiusKm => (origin as NearbyNGOsProvider).radiusKm;
  @override
  String? get sector => (origin as NearbyNGOsProvider).sector;
}

String _$nearbyPlacesHash() => r'ec6968e777635b493d953c2880c0205c81c5263a';

/// See also [nearbyPlaces].
@ProviderFor(nearbyPlaces)
const nearbyPlacesProvider = NearbyPlacesFamily();

/// See also [nearbyPlaces].
class NearbyPlacesFamily extends Family<AsyncValue<List<PlaceOpportunity>>> {
  /// See also [nearbyPlaces].
  const NearbyPlacesFamily();

  /// See also [nearbyPlaces].
  NearbyPlacesProvider call({
    required double latitude,
    required double longitude,
    double radiusKm = 15.0,
    List<String>? types,
  }) {
    return NearbyPlacesProvider(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      types: types,
    );
  }

  @override
  NearbyPlacesProvider getProviderOverride(
    covariant NearbyPlacesProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
      radiusKm: provider.radiusKm,
      types: provider.types,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbyPlacesProvider';
}

/// See also [nearbyPlaces].
class NearbyPlacesProvider
    extends AutoDisposeFutureProvider<List<PlaceOpportunity>> {
  /// See also [nearbyPlaces].
  NearbyPlacesProvider({
    required double latitude,
    required double longitude,
    double radiusKm = 15.0,
    List<String>? types,
  }) : this._internal(
          (ref) => nearbyPlaces(
            ref as NearbyPlacesRef,
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            types: types,
          ),
          from: nearbyPlacesProvider,
          name: r'nearbyPlacesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbyPlacesHash,
          dependencies: NearbyPlacesFamily._dependencies,
          allTransitiveDependencies:
              NearbyPlacesFamily._allTransitiveDependencies,
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          types: types,
        );

  NearbyPlacesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.types,
  }) : super.internal();

  final double latitude;
  final double longitude;
  final double radiusKm;
  final List<String>? types;

  @override
  Override overrideWith(
    FutureOr<List<PlaceOpportunity>> Function(NearbyPlacesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyPlacesProvider._internal(
        (ref) => create(ref as NearbyPlacesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        types: types,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PlaceOpportunity>> createElement() {
    return _NearbyPlacesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyPlacesProvider &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radiusKm == radiusKm &&
        other.types == types;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);
    hash = _SystemHash.combine(hash, radiusKm.hashCode);
    hash = _SystemHash.combine(hash, types.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearbyPlacesRef on AutoDisposeFutureProviderRef<List<PlaceOpportunity>> {
  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;

  /// The parameter `radiusKm` of this provider.
  double get radiusKm;

  /// The parameter `types` of this provider.
  List<String>? get types;
}

class _NearbyPlacesProviderElement
    extends AutoDisposeFutureProviderElement<List<PlaceOpportunity>>
    with NearbyPlacesRef {
  _NearbyPlacesProviderElement(super.provider);

  @override
  double get latitude => (origin as NearbyPlacesProvider).latitude;
  @override
  double get longitude => (origin as NearbyPlacesProvider).longitude;
  @override
  double get radiusKm => (origin as NearbyPlacesProvider).radiusKm;
  @override
  List<String>? get types => (origin as NearbyPlacesProvider).types;
}

String _$nearbySchoolsHash() => r'023c6d1f966f64243637bb2a214b3d004d2f28b0';

/// See also [nearbySchools].
@ProviderFor(nearbySchools)
const nearbySchoolsProvider = NearbySchoolsFamily();

/// See also [nearbySchools].
class NearbySchoolsFamily extends Family<AsyncValue<List<UDISESchool>>> {
  /// See also [nearbySchools].
  const NearbySchoolsFamily();

  /// See also [nearbySchools].
  NearbySchoolsProvider call({
    required double latitude,
    required double longitude,
    double radiusKm = 15.0,
    String? state,
    String? district,
  }) {
    return NearbySchoolsProvider(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      state: state,
      district: district,
    );
  }

  @override
  NearbySchoolsProvider getProviderOverride(
    covariant NearbySchoolsProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
      radiusKm: provider.radiusKm,
      state: provider.state,
      district: provider.district,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbySchoolsProvider';
}

/// See also [nearbySchools].
class NearbySchoolsProvider
    extends AutoDisposeFutureProvider<List<UDISESchool>> {
  /// See also [nearbySchools].
  NearbySchoolsProvider({
    required double latitude,
    required double longitude,
    double radiusKm = 15.0,
    String? state,
    String? district,
  }) : this._internal(
          (ref) => nearbySchools(
            ref as NearbySchoolsRef,
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            state: state,
            district: district,
          ),
          from: nearbySchoolsProvider,
          name: r'nearbySchoolsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbySchoolsHash,
          dependencies: NearbySchoolsFamily._dependencies,
          allTransitiveDependencies:
              NearbySchoolsFamily._allTransitiveDependencies,
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          state: state,
          district: district,
        );

  NearbySchoolsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.state,
    required this.district,
  }) : super.internal();

  final double latitude;
  final double longitude;
  final double radiusKm;
  final String? state;
  final String? district;

  @override
  Override overrideWith(
    FutureOr<List<UDISESchool>> Function(NearbySchoolsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbySchoolsProvider._internal(
        (ref) => create(ref as NearbySchoolsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        state: state,
        district: district,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UDISESchool>> createElement() {
    return _NearbySchoolsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbySchoolsProvider &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radiusKm == radiusKm &&
        other.state == state &&
        other.district == district;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);
    hash = _SystemHash.combine(hash, radiusKm.hashCode);
    hash = _SystemHash.combine(hash, state.hashCode);
    hash = _SystemHash.combine(hash, district.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearbySchoolsRef on AutoDisposeFutureProviderRef<List<UDISESchool>> {
  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;

  /// The parameter `radiusKm` of this provider.
  double get radiusKm;

  /// The parameter `state` of this provider.
  String? get state;

  /// The parameter `district` of this provider.
  String? get district;
}

class _NearbySchoolsProviderElement
    extends AutoDisposeFutureProviderElement<List<UDISESchool>>
    with NearbySchoolsRef {
  _NearbySchoolsProviderElement(super.provider);

  @override
  double get latitude => (origin as NearbySchoolsProvider).latitude;
  @override
  double get longitude => (origin as NearbySchoolsProvider).longitude;
  @override
  double get radiusKm => (origin as NearbySchoolsProvider).radiusKm;
  @override
  String? get state => (origin as NearbySchoolsProvider).state;
  @override
  String? get district => (origin as NearbySchoolsProvider).district;
}

String _$nearbyATLLabsHash() => r'1693abc51e6027ee297bca846aa5b17ac0d411d5';

/// See also [nearbyATLLabs].
@ProviderFor(nearbyATLLabs)
const nearbyATLLabsProvider = NearbyATLLabsFamily();

/// See also [nearbyATLLabs].
class NearbyATLLabsFamily extends Family<AsyncValue<List<ATLLab>>> {
  /// See also [nearbyATLLabs].
  const NearbyATLLabsFamily();

  /// See also [nearbyATLLabs].
  NearbyATLLabsProvider call({
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    String? state,
    String? district,
  }) {
    return NearbyATLLabsProvider(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      state: state,
      district: district,
    );
  }

  @override
  NearbyATLLabsProvider getProviderOverride(
    covariant NearbyATLLabsProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
      radiusKm: provider.radiusKm,
      state: provider.state,
      district: provider.district,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbyATLLabsProvider';
}

/// See also [nearbyATLLabs].
class NearbyATLLabsProvider extends AutoDisposeFutureProvider<List<ATLLab>> {
  /// See also [nearbyATLLabs].
  NearbyATLLabsProvider({
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    String? state,
    String? district,
  }) : this._internal(
          (ref) => nearbyATLLabs(
            ref as NearbyATLLabsRef,
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            state: state,
            district: district,
          ),
          from: nearbyATLLabsProvider,
          name: r'nearbyATLLabsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbyATLLabsHash,
          dependencies: NearbyATLLabsFamily._dependencies,
          allTransitiveDependencies:
              NearbyATLLabsFamily._allTransitiveDependencies,
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          state: state,
          district: district,
        );

  NearbyATLLabsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.state,
    required this.district,
  }) : super.internal();

  final double latitude;
  final double longitude;
  final double radiusKm;
  final String? state;
  final String? district;

  @override
  Override overrideWith(
    FutureOr<List<ATLLab>> Function(NearbyATLLabsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyATLLabsProvider._internal(
        (ref) => create(ref as NearbyATLLabsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        state: state,
        district: district,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ATLLab>> createElement() {
    return _NearbyATLLabsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyATLLabsProvider &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radiusKm == radiusKm &&
        other.state == state &&
        other.district == district;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);
    hash = _SystemHash.combine(hash, radiusKm.hashCode);
    hash = _SystemHash.combine(hash, state.hashCode);
    hash = _SystemHash.combine(hash, district.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearbyATLLabsRef on AutoDisposeFutureProviderRef<List<ATLLab>> {
  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;

  /// The parameter `radiusKm` of this provider.
  double get radiusKm;

  /// The parameter `state` of this provider.
  String? get state;

  /// The parameter `district` of this provider.
  String? get district;
}

class _NearbyATLLabsProviderElement
    extends AutoDisposeFutureProviderElement<List<ATLLab>>
    with NearbyATLLabsRef {
  _NearbyATLLabsProviderElement(super.provider);

  @override
  double get latitude => (origin as NearbyATLLabsProvider).latitude;
  @override
  double get longitude => (origin as NearbyATLLabsProvider).longitude;
  @override
  double get radiusKm => (origin as NearbyATLLabsProvider).radiusKm;
  @override
  String? get state => (origin as NearbyATLLabsProvider).state;
  @override
  String? get district => (origin as NearbyATLLabsProvider).district;
}

String _$upcomingCompetitionsHash() =>
    r'0c0ad14f4f4a6c719012af25c02511190b79f59a';

/// See also [upcomingCompetitions].
@ProviderFor(upcomingCompetitions)
const upcomingCompetitionsProvider = UpcomingCompetitionsFamily();

/// See also [upcomingCompetitions].
class UpcomingCompetitionsFamily extends Family<AsyncValue<List<Competition>>> {
  /// See also [upcomingCompetitions].
  const UpcomingCompetitionsFamily();

  /// See also [upcomingCompetitions].
  UpcomingCompetitionsProvider call({
    int limit = 20,
    CompetitionCategory? category,
    CompetitionLevel? level,
  }) {
    return UpcomingCompetitionsProvider(
      limit: limit,
      category: category,
      level: level,
    );
  }

  @override
  UpcomingCompetitionsProvider getProviderOverride(
    covariant UpcomingCompetitionsProvider provider,
  ) {
    return call(
      limit: provider.limit,
      category: provider.category,
      level: provider.level,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'upcomingCompetitionsProvider';
}

/// See also [upcomingCompetitions].
class UpcomingCompetitionsProvider
    extends AutoDisposeFutureProvider<List<Competition>> {
  /// See also [upcomingCompetitions].
  UpcomingCompetitionsProvider({
    int limit = 20,
    CompetitionCategory? category,
    CompetitionLevel? level,
  }) : this._internal(
          (ref) => upcomingCompetitions(
            ref as UpcomingCompetitionsRef,
            limit: limit,
            category: category,
            level: level,
          ),
          from: upcomingCompetitionsProvider,
          name: r'upcomingCompetitionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$upcomingCompetitionsHash,
          dependencies: UpcomingCompetitionsFamily._dependencies,
          allTransitiveDependencies:
              UpcomingCompetitionsFamily._allTransitiveDependencies,
          limit: limit,
          category: category,
          level: level,
        );

  UpcomingCompetitionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.category,
    required this.level,
  }) : super.internal();

  final int limit;
  final CompetitionCategory? category;
  final CompetitionLevel? level;

  @override
  Override overrideWith(
    FutureOr<List<Competition>> Function(UpcomingCompetitionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpcomingCompetitionsProvider._internal(
        (ref) => create(ref as UpcomingCompetitionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        category: category,
        level: level,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Competition>> createElement() {
    return _UpcomingCompetitionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingCompetitionsProvider &&
        other.limit == limit &&
        other.category == category &&
        other.level == level;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, level.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpcomingCompetitionsRef
    on AutoDisposeFutureProviderRef<List<Competition>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `category` of this provider.
  CompetitionCategory? get category;

  /// The parameter `level` of this provider.
  CompetitionLevel? get level;
}

class _UpcomingCompetitionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Competition>>
    with UpcomingCompetitionsRef {
  _UpcomingCompetitionsProviderElement(super.provider);

  @override
  int get limit => (origin as UpcomingCompetitionsProvider).limit;
  @override
  CompetitionCategory? get category =>
      (origin as UpcomingCompetitionsProvider).category;
  @override
  CompetitionLevel? get level => (origin as UpcomingCompetitionsProvider).level;
}

String _$personalizedRecommendationsHash() =>
    r'cec4a2c33f31ad6b3e0b2d438aa0cdba6a36de39';

/// See also [personalizedRecommendations].
@ProviderFor(personalizedRecommendations)
const personalizedRecommendationsProvider = PersonalizedRecommendationsFamily();

/// See also [personalizedRecommendations].
class PersonalizedRecommendationsFamily
    extends Family<AsyncValue<PersonalizedRecommendations>> {
  /// See also [personalizedRecommendations].
  const PersonalizedRecommendationsFamily();

  /// See also [personalizedRecommendations].
  PersonalizedRecommendationsProvider call({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
  }) {
    return PersonalizedRecommendationsProvider(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  PersonalizedRecommendationsProvider getProviderOverride(
    covariant PersonalizedRecommendationsProvider provider,
  ) {
    return call(
      userProfile: provider.userProfile,
      latitude: provider.latitude,
      longitude: provider.longitude,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'personalizedRecommendationsProvider';
}

/// See also [personalizedRecommendations].
class PersonalizedRecommendationsProvider
    extends AutoDisposeFutureProvider<PersonalizedRecommendations> {
  /// See also [personalizedRecommendations].
  PersonalizedRecommendationsProvider({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
  }) : this._internal(
          (ref) => personalizedRecommendations(
            ref as PersonalizedRecommendationsRef,
            userProfile: userProfile,
            latitude: latitude,
            longitude: longitude,
          ),
          from: personalizedRecommendationsProvider,
          name: r'personalizedRecommendationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$personalizedRecommendationsHash,
          dependencies: PersonalizedRecommendationsFamily._dependencies,
          allTransitiveDependencies:
              PersonalizedRecommendationsFamily._allTransitiveDependencies,
          userProfile: userProfile,
          latitude: latitude,
          longitude: longitude,
        );

  PersonalizedRecommendationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userProfile,
    required this.latitude,
    required this.longitude,
  }) : super.internal();

  final UserProfile userProfile;
  final double latitude;
  final double longitude;

  @override
  Override overrideWith(
    FutureOr<PersonalizedRecommendations> Function(
            PersonalizedRecommendationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PersonalizedRecommendationsProvider._internal(
        (ref) => create(ref as PersonalizedRecommendationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userProfile: userProfile,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PersonalizedRecommendations>
      createElement() {
    return _PersonalizedRecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalizedRecommendationsProvider &&
        other.userProfile == userProfile &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userProfile.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PersonalizedRecommendationsRef
    on AutoDisposeFutureProviderRef<PersonalizedRecommendations> {
  /// The parameter `userProfile` of this provider.
  UserProfile get userProfile;

  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;
}

class _PersonalizedRecommendationsProviderElement
    extends AutoDisposeFutureProviderElement<PersonalizedRecommendations>
    with PersonalizedRecommendationsRef {
  _PersonalizedRecommendationsProviderElement(super.provider);

  @override
  UserProfile get userProfile =>
      (origin as PersonalizedRecommendationsProvider).userProfile;
  @override
  double get latitude =>
      (origin as PersonalizedRecommendationsProvider).latitude;
  @override
  double get longitude =>
      (origin as PersonalizedRecommendationsProvider).longitude;
}

String _$scanProgressHash() => r'1aa44f35e8e8d3522e05ae537ff13d1d1694f9d1';

/// See also [scanProgress].
@ProviderFor(scanProgress)
final scanProgressProvider = AutoDisposeStreamProvider<ScanProgress>.internal(
  scanProgress,
  name: r'scanProgressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scanProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScanProgressRef = AutoDisposeStreamProviderRef<ScanProgress>;
String _$backgroundScanControllerHash() =>
    r'bbe676c15a4ebb838da88052a080ff14ff49c1c4';

/// See also [BackgroundScanController].
@ProviderFor(BackgroundScanController)
final backgroundScanControllerProvider =
    AutoDisposeAsyncNotifierProvider<BackgroundScanController, void>.internal(
  BackgroundScanController.new,
  name: r'backgroundScanControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backgroundScanControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackgroundScanController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
