/// Opportunity Discovery Services — real implementations.
///
/// Services:
/// - LocationService: Device GPS → lat/lng (free, no API key)
/// - NominatimService: Reverse geocoding via OpenStreetMap (free)
/// - OverpassService: Nearby places via OSM Overpass API (free)
/// - NGODarpanService: NGO search via ngodarpan.gov.in + curated fallback
/// - CompetitionCalendarService: Hardcoded Indian competition dates
/// - OpportunityFeed: Combined provider orchestrating all services

// Models (always available on all platforms)
export 'location_models.dart' show UserLocation, LocationServiceBase;
export 'overpass_service.dart' show NearbyPlace;
export 'ngo_darpan_service.dart' show NGO;
export 'competition_calendar_service.dart' show Competition;

// Services (platform-conditional for location)
export 'location_service.dart' show locationServiceProvider;
export 'nominatim_service.dart' show nominatimServiceProvider;
export 'overpass_service.dart' show overpassServiceProvider;
export 'ngo_darpan_service.dart' show ngoDarpanServiceProvider;
export 'competition_calendar_service.dart' show competitionCalendarProvider;

// Combined feed
export 'opportunity_feed.dart' show opportunityFeedProvider, OpportunityFeed;
