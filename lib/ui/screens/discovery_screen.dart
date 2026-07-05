/// Discovery screen — shows nearby NGOs, places, and competitions.
/// Uses free APIs: Overpass, NGO Darpan, competition calendar.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../../services/opportunity_feed.dart';
import '../../services/ngo_darpan_service.dart';
import '../../services/overpass_service.dart';
import '../../services/competition_calendar_service.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final _cityController = TextEditingController();
  int _selectedTab = 0; // 0=All, 1=NGOs, 2=Places, 3=Competitions

  @override
  void initState() {
    super.initState();
    // Auto-discover on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(opportunityFeedProvider.notifier).discover();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(opportunityFeedProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Discover Opportunities',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (feed.cityName != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(feed.cityName!, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: feed.isLoading
          ? const Center(child: CircularProgressIndicator())
          : feed.error != null
              ? _buildError(feed.error!)
              : Column(
                  children: [
                    // Search bar
                    _buildSearchBar(),
                    // Tab bar
                    _buildTabBar(),
                    // Content
                    Expanded(
                      child: _buildContent(feed),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryDark,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by city name...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  ref.read(opportunityFeedProvider.notifier).searchCity(val.trim());
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () {
              ref.read(opportunityFeedProvider.notifier).discover();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['All', 'NGOs', 'Nearby', 'Competitions'];
    return Container(
      height: 48,
      color: AppTheme.surfaceWhite,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppTheme.accentGold : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[i],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppTheme.primaryDark : AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent(OpportunityFeed feed) {
    switch (_selectedTab) {
      case 0: // All
        return _buildAllTab(feed);
      case 1: // NGOs
        return _buildNGOList(feed.ngos);
      case 2: // Nearby
        return _buildNearbyList(feed.nearbyPlaces);
      case 3: // Competitions
        return _buildCompetitionList(feed.competitions, feed.openNow);
      default:
        return const SizedBox();
    }
  }

  Widget _buildAllTab(OpportunityFeed feed) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Open now section
          if (feed.openNow.isNotEmpty) ...[
            _buildSectionHeader('🟢 Open Now', '${feed.openNow.length} competitions'),
            ...feed.openNow.take(3).map((c) => _buildCompetitionTile(c)),
            const SizedBox(height: 24),
          ],
          // NGOs section
          if (feed.ngos.isNotEmpty) ...[
            _buildSectionHeader('🏢 NGOs in ${feed.cityName ?? "your area"}', '${feed.ngos.length} found'),
            ...feed.ngos.take(3).map((n) => _buildNGOTile(n)),
            const SizedBox(height: 24),
          ],
          // Nearby places
          if (feed.nearbyPlaces.isNotEmpty) ...[
            _buildSectionHeader('📍 Nearby Places', '${feed.nearbyPlaces.length} found'),
            ...feed.nearbyPlaces.take(3).map((p) => _buildNearbyTile(p)),
            const SizedBox(height: 24),
          ],
          // All competitions
          if (feed.competitions.isNotEmpty) ...[
            _buildSectionHeader('🏆 All Competitions', '${feed.competitions.length} available'),
            ...feed.competitions.take(5).map((c) => _buildCompetitionTile(c)),
          ],
          // Empty state
          if (feed.ngos.isEmpty && feed.nearbyPlaces.isEmpty && feed.competitions.isEmpty)
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildNGOTile(NGO ngo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryDark.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.account_balance, color: AppTheme.accentGold, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ngo.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${ngo.city}, ${ngo.state} • ${ngo.focus}',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100));
  }

  Widget _buildNearbyTile(NearbyPlace place) {
    final icon = place.type == 'library' ? Icons.library_books
        : place.type == 'school' ? Icons.school
        : place.type == 'makerspace' ? Icons.build
        : Icons.location_city;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${place.distanceKm} km away • ${place.type}',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Text('${place.distanceKm}km', style: GoogleFonts.inter(
            fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500)),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100));
  }

  Widget _buildCompetitionTile(Competition comp) {
    final isOpen = comp.isRegistrationOpen;
    final daysLeft = comp.daysUntilDeadline;
    final statusColor = isOpen
        ? (daysLeft < 7 ? Colors.red : Colors.green)
        : AppTheme.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  comp.category.toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                ),
              ),
              const Spacer(),
              if (isOpen)
                Text('$daysLeft days left', style: GoogleFonts.inter(
                    fontSize: 11, color: statusColor, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Text(comp.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Text(comp.description, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 12, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              Text('Exam: ${comp.examDate.day}/${comp.examDate.month}/${comp.examDate.year}',
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
              const SizedBox(width: 12),
              Icon(Icons.school, size: 12, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              Text(comp.eligibility.replaceAll('_', ' '),
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100));
  }

  Widget _buildNGOList(List<NGO> ngos) {
    if (ngos.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ngos.length,
      itemBuilder: (ctx, i) => _buildNGOTile(ngos[i]),
    );
  }

  Widget _buildNearbyList(List<NearbyPlace> places) {
    if (places.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (ctx, i) => _buildNearbyTile(places[i]),
    );
  }

  Widget _buildCompetitionList(List<Competition> all, List<Competition> open) {
    final list = open.isNotEmpty ? open : all;
    if (list.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) => _buildCompetitionTile(list[i]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppTheme.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No opportunities found', style: GoogleFonts.inter(
              fontSize: 16, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Try searching for a different city', style: GoogleFonts.inter(
              fontSize: 13, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(error, textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(opportunityFeedProvider.notifier).discover(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
