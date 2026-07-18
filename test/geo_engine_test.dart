import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/geo/domain/geo_engine.dart';

void main() {
  final engine = GeoEngine();
  const sg = Opportunity(
    id: 'lib',
    title: 'Library',
    category: 'library',
    lat: 1.3521,
    lng: 103.8198,
    address: 'x',
    verified: true,
  );
  const far = Opportunity(
    id: 'lon',
    title: 'London',
    category: 'library',
    lat: 51.5074,
    lng: -0.1278,
    address: 'y',
    verified: true,
  );

  test('distanceKm computes ~0 for same point', () {
    expect(engine.distanceKm(1.3521, 103.8198, 1.3521, 103.8198), closeTo(0, 0.01));
  });

  test('SG to London ~10,800 km', () {
    final d = engine.distanceKm(1.3521, 103.8198, 51.5074, -0.1278);
    expect(d, greaterThan(10000));
  });

  test('withinRadius filters by radius', () {
    final near = engine.withinRadius([sg, far], 1.3521, 103.8198, 50);
    expect(near.map((o) => o.id), contains('lib'));
    expect(near.map((o) => o.id), isNot(contains('lon')));
  });

  test('travelMinutes positive for distant point', () {
    expect(engine.travelMinutes(1.3521, 103.8198, 51.5074, -0.1278), greaterThan(0));
  });
}
