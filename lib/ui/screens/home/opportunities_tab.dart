import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/opportunity_feed.dart';
import '../../../providers/providers.dart';

/// Opportunities tab — real discovery using free APIs.
/// Finds NGOs, nearby places, and competitions via Overpass, NGO Darpan, etc.
class OpportunitiesTab extends ConsumerStatefulWidget {
  const OpportunitiesTab({super.key});

  @override
  ConsumerState<OpportunitiesTab> createState() => _OpportunitiesTabState();
}

class _OpportunitiesTabState extends ConsumerState<OpportunitiesTab> {
  final _cityController = TextEditingController();
  int _selectedTab = 0; // 0=All, 1=NGOs, 2=Nearby, 3=Competitions

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: Text('Opportunities',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          if (feed.cityName != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 14),
                    const SizedBox(width: 2),
                    Text(feed.cityName!,
                        style: GoogleFonts.inter(fontSize: 12)),
                  ],
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () =>
                ref.read(opportunityFeedProvider.notifier).discover(),
            tooltip: 'Use my location',
          ),
        ],
      ),
      body: feed.isLoading
          ? const Center(child: CircularProgressIndicator())
          : feed.error != null
              ? (feed.error!.toLowerCase().contains('location')
                  ? Column(
                      children: [
                        _buildSearchBar(),
                        Expanded(child: _buildError(feed.error!)),
                      ],
                    )
                  : _buildError(feed.error!))
              : Column(
                  children: [
                    // Search bar
                    _buildSearchBar(),
                    // Tab bar
                    _buildTabBar(),
                    // Content
                    Expanded(child: _buildContent(feed)),
                  ],
                ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Search by city...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                isDense: true,
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  ref
                      .read(opportunityFeedProvider.notifier)
                      .searchCity(val.trim());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      'All',
      'NGOs',
      'Nearby',
      'Competitions',
      'ATL Lab',
      'Scholarship'
    ];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (ctx, i) {
          final isSelected = _selectedTab == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tabs[i]),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedTab = i),
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: GoogleFonts.inter(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
              avatar: i == 0
                  ? const Icon(Icons.all_inclusive, size: 16)
                  : i == 1
                      ? const Icon(Icons.account_balance, size: 16)
                      : i == 2
                          ? const Icon(Icons.near_me, size: 16)
                          : i == 3
                              ? const Icon(Icons.emoji_events, size: 16)
                              : i == 4
                                  ? const Icon(Icons.science, size: 16)
                                  : const Icon(Icons.school, size: 16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(feed) {
    switch (_selectedTab) {
      case 0:
        return _buildAllTab(feed);
      case 1:
        return _buildNGOList(feed.ngos);
      case 2:
        return _buildNearbyList(feed.nearbyPlaces);
      case 3:
        return _buildCompetitionList(feed.competitions, feed.openNow);
      case 4:
        return _buildATLLabList();
      case 5:
        return _buildScholarshipList();
      default:
        return const SizedBox();
    }
  }

  Widget _buildATLLabList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science_rounded,
              size: 56,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('ATL Labs',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary)),
          const SizedBox(height: 8),
          Text(
              'Atal Tinkering Labs near you\nCheck back soon for ATL opportunities',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: context.textSecondary)),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () =>
                ref.read(opportunityFeedProvider.notifier).discover(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipList() {
    final scholarships = <_Scholarship>[
      _Scholarship(
          name: 'National Merit Scholarship',
          provider: 'Government of India',
          amount: '₹50,000/year',
          deadline: 'Rolling',
          category: 'Need-based',
          icon: Icons.account_balance_rounded,
          color: Theme.of(context).colorScheme.primary),
      _Scholarship(
          name: 'INSPIRE Scholarship',
          provider: 'DST, Government of India',
          amount: '₹80,000/year',
          deadline: 'Check portal',
          category: 'Merit-based',
          icon: Icons.lightbulb_rounded,
          color: AppTheme.accentOrange),
      _Scholarship(
          name: 'NTSE Scholarship',
          provider: 'NCERT',
          amount: '₹2,000/month',
          deadline: 'Oct-Nov annually',
          category: 'Talent Search',
          icon: Icons.psychology_rounded,
          color: Theme.of(context).colorScheme.tertiary),
      _Scholarship(
          name: 'KVPY Fellowship',
          provider: 'DST, Government of India',
          amount: '₹84,000/year',
          deadline: 'Sept annually',
          category: 'Research',
          icon: Icons.science_rounded,
          color: AppTheme.accentTeal),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: scholarships.length,
      itemBuilder: (context, index) => _scholarshipCard(
        name: scholarships[index].name,
        provider: scholarships[index].provider,
        amount: scholarships[index].amount,
        deadline: scholarships[index].deadline,
        category: scholarships[index].category,
        icon: scholarships[index].icon,
        color: scholarships[index].color,
      ),
    );
  }

  Widget _scholarshipCard({
    required String name,
    required String provider,
    required String amount,
    required String deadline,
    required String category,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(provider,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: context.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _miniTag(amount, AppTheme.successGreen),
                const SizedBox(width: 8),
                _miniTag(category, Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                _miniTag('⏰ $deadline', AppTheme.accentOrange),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Saved to bookmarks'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Save', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening application...'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Apply',
                        style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildAllTab(feed) {
    final hasData = feed.ngos.isNotEmpty ||
        feed.nearbyPlaces.isNotEmpty ||
        feed.competitions.isNotEmpty;
    if (!hasData) return _buildEmptyState();

    // Build a flat list of sections & items for ListView.builder
    final sections = <_AllTabSection>[];

    if (feed.openNow.isNotEmpty) {
      sections.add(_AllTabSection(
        header: _AllTabHeader(
          title: '🟢 Registration Open',
          count: '${feed.openNow.length} competitions',
        ),
        items: feed.openNow.take(3).map((c) => _AllTabItem.competition(c)).toList(),
      ));
    }
    if (feed.ngos.isNotEmpty) {
      sections.add(_AllTabSection(
        header: _AllTabHeader(
          title: '🏢 NGOs in ${feed.cityName ?? "your area"}',
          count: '${feed.ngos.length} found',
        ),
        items: feed.ngos.take(3).map((n) => _AllTabItem.ngo(n)).toList(),
      ));
    }
    if (feed.nearbyPlaces.isNotEmpty) {
      sections.add(_AllTabSection(
        header: _AllTabHeader(
          title: '📍 Nearby Places',
          count: '${feed.nearbyPlaces.length} found',
        ),
        items: feed.nearbyPlaces.take(3).map((p) => _AllTabItem.place(p)).toList(),
      ));
    }
    if (feed.competitions.isNotEmpty) {
      sections.add(_AllTabSection(
        header: _AllTabHeader(
          title: '🏆 All Competitions',
          count: '${feed.competitions.length} available',
        ),
        items: feed.competitions.take(5).map((c) => _AllTabItem.competition(c)).toList(),
      ));
    }

    final itemCount = sections.fold<int>(0, (sum, s) => sum + 1 + s.items.length + 1); // header + items + spacer

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        var i = index;
        for (final section in sections) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(section.header.title,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(section.header.count,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: Theme.of(context).colorScheme.outline)),
                ],
              ),
            );
          }
          i -= 1;
          if (i < section.items.length) {
            final item = section.items[i];
            switch (item.type) {
              case _AllTabItemType.competition:
                return _compTile(item.competition!);
              case _AllTabItemType.ngo:
                return _ngoTile(item.ngo!);
              case _AllTabItemType.place:
                return _placeTile(item.place!);
            }
          }
          i -= section.items.length;
          if (i == 0) {
            return const SizedBox(height: 20);
          }
          i -= 1;
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _sectionHeader(String title, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(count,
              style: GoogleFonts.inter(
                  fontSize: 11, color: Theme.of(context).colorScheme.outline)),
        ],
      ),
    );
  }

  Widget _ngoTile(NGO ngo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.account_balance, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ngo.name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('${ngo.city}, ${ngo.state} • ${ngo.focus}',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _miniTag(ngo.focus, Theme.of(context).colorScheme.primary),
                const Spacer(),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Saved to bookmarks'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Save', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 32,
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Contact info saved'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Contact',
                        style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeTile(NearbyPlace place) {
    final icon = place.type == 'library'
        ? Icons.library_books
        : place.type == 'school'
            ? Icons.school
            : place.type == 'makerspace'
                ? Icons.build
                : Icons.location_city;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(icon,
              size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(place.name,
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('${place.distanceKm} km • ${place.type}',
            style: GoogleFonts.inter(
                fontSize: 12, color: Theme.of(context).colorScheme.outline)),
        trailing: Text('${place.distanceKm}km',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  Widget _compTile(Competition comp) {
    final isOpen = comp.isRegistrationOpen;
    final daysLeft = comp.daysUntilDeadline;
    final statusColor = isOpen
        ? (daysLeft < 7
            ? Theme.of(context).colorScheme.error
            : AppTheme.success)
        : Theme.of(context).colorScheme.outline;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(comp.category.toUpperCase(),
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor)),
                ),
                if (isOpen) ...[
                  const SizedBox(width: 8),
                  Text('$daysLeft days left',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.w500)),
                ],
                const Spacer(),
                Text(
                    '${comp.examDate.day}/${comp.examDate.month}/${comp.examDate.year}',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.outline)),
              ],
            ),
            const SizedBox(height: 8),
            Text(comp.name,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            Text(comp.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Competition saved'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Save', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening registration...'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text(isOpen ? 'Register' : 'View Details',
                        style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNGOList(List ngos) {
    if (ngos.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ngos.length,
      itemBuilder: (ctx, i) => _ngoTile(ngos[i]),
    );
  }

  Widget _buildNearbyList(List places) {
    if (places.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (ctx, i) => _placeTile(places[i]),
    );
  }

  Widget _buildCompetitionList(List all, List open) {
    final list = open.isNotEmpty ? open : all;
    if (list.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) => _compTile(list[i]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined,
              size: 56,
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Enter your city to find nearby opportunities',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 8),
          Text(
              'Use the search bar above to discover NGOs, competitions, and more',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () =>
                ref.read(opportunityFeedProvider.notifier).discover(),
            icon: const Icon(Icons.my_location, size: 16),
            label: const Text('Try My Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    if (error.toLowerCase().contains('location')) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off_rounded,
                  size: 56,
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('Location not available',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.outline)),
              const SizedBox(height: 8),
              Text(
                  'Enter your city in the search bar above to find opportunities near you',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.outline)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(opportunityFeedProvider.notifier).discover(),
                icon: const Icon(Icons.my_location, size: 16),
                label: const Text('Try My Location'),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(error,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  ref.read(opportunityFeedProvider.notifier).discover(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for the horizontal opportunity cards in DashboardTab.
class _AllTabItemType {
  static const competition = _AllTabItemType._('competition');
  static const ngo = _AllTabItemType._('ngo');
  static const place = _AllTabItemType._('place');
  final String name;
  const _AllTabItemType._(this.name);
}

class _AllTabItem {
  final _AllTabItemType type;
  final Competition? competition;
  final NGO? ngo;
  final NearbyPlace? place;

  const _AllTabItem.competition(this.competition)
      : type = _AllTabItemType.competition,
        ngo = null,
        place = null;
  const _AllTabItem.ngo(this.ngo)
      : type = _AllTabItemType.ngo,
        competition = null,
        place = null;
  const _AllTabItem.place(this.place)
      : type = _AllTabItemType.place,
        competition = null,
        ngo = null;
}

class _AllTabHeader {
  final String title;
  final String count;
  const _AllTabHeader({required this.title, required this.count});
}

class _AllTabSection {
  final _AllTabHeader header;
  final List<_AllTabItem> items;
  const _AllTabSection({required this.header, required this.items});
}

class _Scholarship {
  final String name;
  final String provider;
  final String amount;
  final String deadline;
  final String category;
  final IconData icon;
  final Color color;

  const _Scholarship({
    required this.name,
    required this.provider,
    required this.amount,
    required this.deadline,
    required this.category,
    required this.icon,
    required this.color,
  });
}
