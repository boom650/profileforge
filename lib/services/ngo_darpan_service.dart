/// Free NGO search using NGO Darpan (ngodarpan.gov.in) — Indian government portal.
/// Also includes a curated fallback list of well-known Indian NGOs by category.
/// No API key needed.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NGO {
  final String id;
  final String name;
  final String city;
  final String state;
  final String focus; // 'education', 'environment', 'health', 'social', etc.
  final String? description;
  final String? website;

  const NGO({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.focus,
    this.description,
    this.website,
  });
}

class NGODarpanService {
  /// Search NGOs by city name.
  /// Tries NGO Darpan API first, falls back to curated list.
  Future<List<NGO>> searchNGOs(String city) async {
    // Try the government API first
    final apiResults = await _searchDarpanAPI(city);
    if (apiResults.isNotEmpty) return apiResults;

    // Fallback: curated list of well-known Indian NGOs
    return _curatedNGOs.where((ngo) =>
      ngo.city.toLowerCase() == city.toLowerCase() ||
      ngo.state.toLowerCase() == city.toLowerCase()
    ).toList();
  }

  /// Search NGOs by focus area across India.
  Future<List<NGO>> searchByFocus(String focus) async {
    return _curatedNGOs.where((ngo) =>
      ngo.focus.toLowerCase().contains(focus.toLowerCase())
    ).toList();
  }

  /// Get all available NGOs (for browsing).
  Future<List<NGO>> getAllNGOs() async {
    return List.unmodifiable(_curatedNGOs);
  }

  Future<List<NGO>> _searchDarpanAPI(String city) async {
    try {
      final uri = Uri.parse(
        'https://api.ngodarpan.gov.in/api/ngo/search?city=${Uri.encodeComponent(city)}&limit=20',
      );
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final list = data['data'] as List? ?? data['ngos'] as List? ?? [];

      return list.map<NGO>((e) => NGO(
        id: e['id']?.toString() ?? '',
        name: e['name'] ?? e['ngo_name'] ?? '',
        city: e['city'] ?? e['district'] ?? '',
        state: e['state'] ?? '',
        focus: e['sector'] ?? e['focus_area'] ?? 'social',
        description: e['description'],
        website: e['website'],
      )).where((n) => n.name.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }

  /// Curated list of well-known Indian NGOs by category.
  static const _curatedNGOs = [
    // Education
    NGO(id: 'c1', name: 'Pratham', city: 'Mumbai', state: 'Maharashtra', focus: 'education',
        description: 'Improving quality of education for underprivileged children', website: 'https://pratham.org'),
    NGO(id: 'c2', name: 'Teach For India', city: 'Mumbai', state: 'Maharashtra', focus: 'education',
        description: 'Leadership development program for education equity', website: 'https://teachforindia.org'),
    NGO(id: 'c3', name: 'Akshara Foundation', city: 'Bangalore', state: 'Karnataka', focus: 'education',
        description: 'Math and language education for children', website: 'https://akshara.org.in'),
    NGO(id: 'c4', name: 'Azim Premji Foundation', city: 'Bangalore', state: 'Karnataka', focus: 'education',
        description: 'Elementary education in rural government schools', website: 'https://azimpremjifoundation.org'),
    NGO(id: 'c5', name: 'Room to Read', city: 'New Delhi', state: 'Delhi', focus: 'education',
        description: 'Literacy and gender equality in education', website: 'https://roomtoread.org'),
    NGO(id: 'c6', name: 'CRY (Child Rights and You)', city: 'Mumbai', state: 'Maharashtra', focus: 'education',
        description: 'Child rights and education for underserved children', website: 'https://cry.org'),

    // Environment
    NGO(id: 'c7', name: 'Greenpeace India', city: 'New Delhi', state: 'Delhi', focus: 'environment',
        description: 'Environmental campaigning and advocacy', website: 'https://greenpeaceindia.org'),
    NGO(id: 'c8', name: 'Centre for Science and Environment', city: 'New Delhi', state: 'Delhi', focus: 'environment',
        description: 'Research and advocacy on environment and development', website: 'https://cseindia.org'),
    NGO(id: 'c9', name: 'Vanashakti', city: 'Mumbai', state: 'Maharashtra', focus: 'environment',
        description: 'Forest conservation and biodiversity protection', website: 'https://vanashakti.in'),
    NGO(id: 'c10', name: 'Foundation for Ecological Security', city: 'Anand', state: 'Gujarat', focus: 'environment',
        description: 'Community-based natural resource management', website: 'https://fec.org.in'),

    // Health
    NGO(id: 'c11', name: 'Doctors For You', city: 'New Delhi', state: 'Delhi', focus: 'health',
        description: 'Emergency medical response and healthcare access', website: 'https://doctorsforyou.org'),
    NGO(id: 'c12', name: 'AROHAN', city: 'Ahmedabad', state: 'Gujarat', focus: 'health',
        description: 'Healthcare for rural and tribal communities', website: 'https://arohan-gujarat.org'),
    NGO(id: 'c13', name: 'Swasth', city: 'Bangalore', state: 'Karnataka', focus: 'health',
        description: 'Digital health solutions for underserved communities'),

    // Social / Community
    NGO(id: 'c14', name: 'Goonj', city: 'New Delhi', state: 'Delhi', focus: 'social',
        description: 'Disaster relief and community development', website: 'https://goonj.org'),
    NGO(id: 'c15', name: 'Self Employed Women\'s Association', city: 'Ahmedabad', state: 'Gujarat', focus: 'social',
        description: 'Women workers rights and economic empowerment', website: 'https://sewa.org'),
    NGO(id: 'c16', name: 'HelpAge India', city: 'New Delhi', state: 'Delhi', focus: 'social',
        description: 'Elderly care and rights', website: 'https://helpageindia.org'),
    NGO(id: 'c17', name: 'Pratham Books', city: 'Bangalore', state: 'Karnataka', focus: 'education',
        description: 'Open-source children\'s books in multiple languages', website: 'https://prathambooks.org'),

    // Technology / STEM
    NGO(id: 'c18', name: 'DataLEADS', city: 'New Delhi', state: 'Delhi', focus: 'technology',
        description: 'Data journalism and digital literacy', website: 'https://dataleads.in'),
    NGO(id: 'c19', name: 'Digital Empowerment Foundation', city: 'New Delhi', state: 'Delhi', focus: 'technology',
        description: 'Digital inclusion and internet access', website: 'https://defindia.org'),
    NGO(id: 'c20', name: 'STEM Learning', city: 'Mumbai', state: 'Maharashtra', focus: 'technology',
        description: 'STEM education in government schools', website: 'https://stemlearning.in'),
  ];
}

final ngoDarpanServiceProvider = Provider<NGODarpanService>((ref) {
  return NGODarpanService();
});
