/// Opportunity Discovery Services — real implementations.
///
/// Services:
/// - LocationService: Device GPS → lat/lng (free, no API key)
/// - NominatimService: Reverse geocoding via OpenStreetMap (free, no API key)
/// - OverpassService: Nearby places via OSM Overpass API (free, no API key)
/// - NGODarpanService: NGO search via ngodarpan.gov.in + curated fallback
/// - CompetitionCalendarService: Hardcoded Indian competition dates
/// - OpportunityFeed: Combined provider that orchestrates all services

// Models
export 'location_service.dart' show UserLocation;
export 'overpass_service.dart' show NearbyPlace;
export 'ngo_darpan_service.dart' show NGO;
export 'competition_calendar_service.dart' show Competition;

// Services
export 'location_service.dart' show locationServiceProvider, userLocationProvider;
export 'nominatim_service.dart' show nominatimServiceProvider;
export 'overpass_service.dart' show overpassServiceProvider;
export 'ngo_darpan_service.dart' show ngoDarpanServiceProvider;
export 'competition_calendar_service.dart' show competitionCalendarProvider;

// Combined feed
export 'opportunity_feed.dart' show opportunityFeedProvider, OpportunityFeed;
