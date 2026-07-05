/// Location service — exports shared types + platform-conditional implementation.
///
/// Always available: UserLocation, LocationServiceBase (from location_models.dart)
/// Platform-specific: locationServiceProvider, createLocationService
export 'location_models.dart';
export 'location_service_stub.dart'
    if (dart.library.io) 'location_service_native.dart'
    if (dart.library.js_interop) 'location_service_web.dart';
