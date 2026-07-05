import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../data/universities/all_universities.dart';
import '../../../data/universities/university_model.dart';

class Screen6TargetUniversities extends StatefulWidget {
  const Screen6TargetUniversities({super.key});

  @override
  State<Screen6TargetUniversities> createState() => _Screen6TargetUniversitiesState();
}

class _Screen6TargetUniversitiesState extends State<Screen6TargetUniversities> {
  String _searchQuery = '';
  String _selectedCountryGroup = 'All Non-US';
  int? _maxRanking;
  String _selectedProgramFilter = '';
  
  // Selected universities per tier
  final Set<String> _selectedReach = {};
  final Set<String> _selectedMatch = {};
  final Set<String> _selectedSafety = {};

  // Pre-populate with existing US universities
  final Set<String> _existingUSReach = {'MIT', 'Stanford', 'Harvard', 'Caltech', 'Princeton'};
  final Set<String> _existingUSMatch = {'Yale', 'Columbia', 'UCLA'};
  final Set<String> _existingUSSafety = {'UCSD', 'Purdue', 'UIUC'};

  List<University> get _filteredUniversities {
    List<University> results = _searchQuery.isEmpty
        ? filterByCountryGroup(_selectedCountryGroup == 'All Non-US' ? 'all' : _selectedCountryGroup)
        : searchUniversities(_searchQuery);
    
    if (_maxRanking != null) {
      results = results.where((u) => u.worldRanking <= _maxRanking!).toList();
    }
    if (_selectedProgramFilter.isNotEmpty) {
      results = results
          .where((u) => u.notablePrograms
              .any((p) => p.toLowerCase().contains(_selectedProgramFilter.toLowerCase())))
          .toList();
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Target Universities',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 8),
          Text(
            'Categorize your list — we\'ll calculate admission probability for each',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 24),

          // Major & Countries
          Row(
            children: [
              Expanded(
                child: _DropdownField(
                  label: 'Intended Major',
                  value: 'Select your major',
                  items: const [
                    'Computer Science', 'Data Science', 'AI/ML', 'Electrical Engineering',
                    'Mechanical Engineering', 'Physics', 'Mathematics', 'Biology/Pre-med',
                    'Chemistry', 'English Literature', 'History', 'Philosophy', 'Languages',
                    'Sociology', 'Fine Arts', 'Law', 'Political Science', 'Psychology',
                    'Economics', 'Business', 'International Relations', 'Media Studies',
                    'Anthropology', 'Geography', 'Music', 'Theatre/Drama', 'Creative Writing',
                    'Environmental Science', 'Education', 'Nursing', 'Architecture',
                    'Journalism', 'Communications', 'Sustainability Studies',
                  ],
                  delay: 200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Target Countries',
            value: 'US, UK, Canada, Australia',
            items: const ['US', 'UK', 'Canada', 'Australia', 'Europe (EU)', 'Singapore', 'Hong Kong', 'All of the above'],
            delay: 250,
          ),
          const SizedBox(height: 32),

          // ── University Browser / Search ──
          _buildSearchFilterSection(),
          const SizedBox(height: 24),

          // ── US Universities (legacy) ──
          _UniversityTierSection(
            title: '🎯 Reach (Dream Schools) — US',
            subtitle: '10-20% baseline probability — aim high',
            color: const Color(0xFF8B5CF6),
            universities: _existingUSReach,
            selected: _selectedReach,
            onToggle: (name) => setState(() => _selectedReach.contains(name) ? _selectedReach.remove(name) : _selectedReach.add(name)),
            delay: 300,
          ),
          const SizedBox(height: 20),
          _UniversityTierSection(
            title: '🎯 Match (Realistic Targets) — US',
            subtitle: '40-60% baseline probability — your sweet spot',
            color: const Color(0xFF3B82F6),
            universities: _existingUSMatch,
            selected: _selectedMatch,
            onToggle: (name) => setState(() => _selectedMatch.contains(name) ? _selectedMatch.remove(name) : _selectedMatch.add(name)),
            delay: 500,
          ),
          const SizedBox(height: 20),
          _UniversityTierSection(
            title: '🛡️ Safety (High Confidence) — US',
            subtitle: '70%+ baseline probability — guaranteed options',
            color: const Color(0xFF10B981),
            universities: _existingUSSafety,
            selected: _selectedSafety,
            onToggle: (name) => setState(() => _selectedSafety.contains(name) ? _selectedSafety.remove(name) : _selectedSafety.add(name)),
            delay: 700,
          ),
          const SizedBox(height: 32),

          // ── Non-US Universities from Data ──
          ...countryGroupLabels.map((group) {
            final unis = filterByCountryGroup(group);
            if (unis.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NonUSUniversitySection(
                  groupLabel: group,
                  universities: unis,
                  selectedReach: _selectedReach,
                  selectedMatch: _selectedMatch,
                  selectedSafety: _selectedSafety,
                  onToggleReach: (name) => setState(() => _selectedReach.contains(name) ? _selectedReach.remove(name) : _selectedReach.add(name)),
                  onToggleMatch: (name) => setState(() => _selectedMatch.contains(name) ? _selectedMatch.remove(name) : _selectedMatch.add(name)),
                  onToggleSafety: (name) => setState(() => _selectedSafety.contains(name) ? _selectedSafety.remove(name) : _selectedSafety.add(name)),
                ),
                const SizedBox(height: 24),
              ],
            );
          }),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentGold.withValues(alpha: 0.1), AppTheme.accentGold.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: AppTheme.accentGold, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We checked thousands of real applications like yours. Your odds update weekly as you complete missions.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 900.ms),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textMuted.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔍 Browse & Filter Universities',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Search bar
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search by name, country, city, or program...',
              hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
              prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppTheme.textSecondary),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              filled: true,
              fillColor: context.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          // Filter chips row
          Row(
            children: [
              Expanded(
                child: _FilterDropdown(
                  label: 'Region',
                  value: _selectedCountryGroup,
                  items: const ['All Non-US', 'UK', 'Canada', 'Australia', 'Europe (EU)'],
                  onChanged: (val) => setState(() => _selectedCountryGroup = val ?? 'All Non-US'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterDropdown(
                  label: 'Max Ranking',
                  value: _maxRanking == null ? 'Any' : 'Top ${_maxRanking!}',
                  items: const ['Any', 'Top 10', 'Top 25', 'Top 50', 'Top 100', 'Top 200'],
                  onChanged: (val) {
                    setState(() {
                      if (val == null || val == 'Any') {
                        _maxRanking = null;
                      } else {
                        _maxRanking = int.parse(val.replaceAll('Top ', ''));
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Program filter chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ['Computer Science', 'Engineering', 'Medicine', 'Law', 'Business', 'Physics', 'Economics', 'Architecture'].map((program) {
              final isSelected = _selectedProgramFilter == program;
              return FilterChip(
                label: Text(
                  program,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : context.textSecondary,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedProgramFilter = selected ? program : '';
                  });
                },
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: context.surfaceElevated,
                checkmarkColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Results count
          Text(
            '${_filteredUniversities.length} universities found',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          // Results list
          if (_filteredUniversities.isNotEmpty)
            SizedBox(
              height: 280,
              child: ListView.builder(
                itemCount: _filteredUniversities.length,
                itemBuilder: (context, index) {
                  final uni = _filteredUniversities[index];
                  final isReach = _selectedReach.contains(uni.name);
                  final isMatch = _selectedMatch.contains(uni.name);
                  final isSafety = _selectedSafety.contains(uni.name);
                  final isInAnyTier = isReach || isMatch || isSafety;
                  return _UniversityResultCard(
                    university: uni,
                    isInAnyTier: isInAnyTier,
                    onAddToReach: () => setState(() {
                      _selectedReach.remove(uni.name);
                      _selectedMatch.remove(uni.name);
                      _selectedSafety.remove(uni.name);
                      _selectedReach.add(uni.name);
                    }),
                    onAddToMatch: () => setState(() {
                      _selectedReach.remove(uni.name);
                      _selectedMatch.remove(uni.name);
                      _selectedSafety.remove(uni.name);
                      _selectedMatch.add(uni.name);
                    }),
                    onAddToSafety: () => setState(() {
                      _selectedReach.remove(uni.name);
                      _selectedMatch.remove(uni.name);
                      _selectedSafety.remove(uni.name);
                      _selectedSafety.add(uni.name);
                    }),
                    onRemove: () => setState(() {
                      _selectedReach.remove(uni.name);
                      _selectedMatch.remove(uni.name);
                      _selectedSafety.remove(uni.name);
                    }),
                  );
                },
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 280.ms).slideY(begin: 0.05);
  }
}

// ─── Filter Dropdown ───

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.textMuted.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter(fontSize: 12)))).toList(),
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textPrimary),
          dropdownColor: context.surfaceElevated,
          icon: Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}

// ─── University Result Card ───

class _UniversityResultCard extends StatelessWidget {
  final University university;
  final bool isInAnyTier;
  final VoidCallback onAddToReach;
  final VoidCallback onAddToMatch;
  final VoidCallback onAddToSafety;
  final VoidCallback onRemove;

  const _UniversityResultCard({
    required this.university,
    required this.isInAnyTier,
    required this.onAddToReach,
    required this.onAddToMatch,
    required this.onAddToSafety,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isInAnyTier ? AppTheme.primaryBlue.withValues(alpha: 0.4) : AppTheme.textMuted.withValues(alpha: 0.15),
          width: isInAnyTier ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ranking badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _rankingColor(university.worldRanking).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${university.worldRanking}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _rankingColor(university.worldRanking),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${university.city}, ${university.country}  •  ${university.applicationPlatform}',
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              // Menu for tier assignment
              if (!isInAnyTier)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'reach': onAddToReach(); break;
                      case 'match': onAddToMatch(); break;
                      case 'safety': onAddToSafety(); break;
                    }
                  },
                  icon: Icon(Icons.add_circle_outline, size: 20, color: AppTheme.textSecondary),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'reach', child: Text('Add to Reach 🎯', style: GoogleFonts.inter(fontSize: 12))),
                    PopupMenuItem(value: 'match', child: Text('Add to Match 🎯', style: GoogleFonts.inter(fontSize: 12))),
                    PopupMenuItem(value: 'safety', child: Text('Add to Safety 🛡️', style: GoogleFonts.inter(fontSize: 12))),
                  ],
                )
              else
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, size: 20, color: AppTheme.primaryBlue),
                  onPressed: onRemove,
                  tooltip: 'Remove from list',
                ),
            ],
          ),
          const SizedBox(height: 6),
          // Stats row
          Row(
            children: [
              _StatChip(label: 'Accept: ${university.acceptanceRate.toStringAsFixed(0)}%', color: _acceptanceColor(university.acceptanceRate)),
              const SizedBox(width: 4),
              _StatChip(label: 'GPA: ${university.averageGPA}', color: AppTheme.primaryBlue),
              if (university.averageSAT != null) ...[
                const SizedBox(width: 4),
                _StatChip(label: 'SAT: ${university.averageSAT}', color: const Color(0xFF8B5CF6)),
              ],
              const SizedBox(width: 4),
              _StatChip(label: '\$${(university.tuitionPerYearUSD / 1000).toStringAsFixed(0)}k/yr', color: AppTheme.accentGold),
            ],
          ),
          const SizedBox(height: 4),
          // Programs (show first 3)
          Text(
            university.notablePrograms.take(3).join(' • '),
            style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _rankingColor(int rank) {
    if (rank <= 10) return const Color(0xFFFFD700);
    if (rank <= 25) return const Color(0xFF8B5CF6);
    if (rank <= 50) return const Color(0xFF3B82F6);
    if (rank <= 100) return const Color(0xFF10B981);
    return AppTheme.textMuted;
  }

  Color _acceptanceColor(double rate) {
    if (rate <= 10) return const Color(0xFFEF4444);
    if (rate <= 30) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

// ─── Non-US University Section ───

class _NonUSUniversitySection extends StatelessWidget {
  final String groupLabel;
  final List<University> universities;
  final Set<String> selectedReach;
  final Set<String> selectedMatch;
  final Set<String> selectedSafety;
  final ValueChanged<String> onToggleReach;
  final ValueChanged<String> onToggleMatch;
  final ValueChanged<String> onToggleSafety;

  const _NonUSUniversitySection({
    required this.groupLabel,
    required this.universities,
    required this.selectedReach,
    required this.selectedMatch,
    required this.selectedSafety,
    required this.onToggleReach,
    required this.onToggleMatch,
    required this.onToggleSafety,
  });

  String get _groupEmoji {
    switch (groupLabel) {
      case 'UK': return '🇬🇧';
      case 'Canada': return '🇨🇦';
      case 'Australia': return '🇦🇺';
      case 'Europe (EU)': return '🇪🇺';
      default: return '🌍';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(_groupEmoji, style: GoogleFonts.inter(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              groupLabel,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${universities.length} unis',
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.primaryBlue, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ).animate().fadeIn().slideX(begin: -0.1),
        const SizedBox(height: 12),
        ...universities.map((uni) {
          final isReach = selectedReach.contains(uni.name);
          final isMatch = selectedMatch.contains(uni.name);
          final isSafety = selectedSafety.contains(uni.name);
          final tier = isReach ? 'Reach' : (isMatch ? 'Match' : (isSafety ? 'Safety' : null));
          return _NonUSUniversityCard(
            university: uni,
            currentTier: tier,
            onAssignTier: (tier) {
              switch (tier) {
                case 'Reach': onToggleReach(uni.name); break;
                case 'Match': onToggleMatch(uni.name); break;
                case 'Safety': onToggleSafety(uni.name); break;
              }
            },
          );
        }),
      ],
    );
  }
}

class _NonUSUniversityCard extends StatelessWidget {
  final University university;
  final String? currentTier;
  final ValueChanged<String> onAssignTier;

  const _NonUSUniversityCard({
    required this.university,
    required this.currentTier,
    required this.onAssignTier,
  });

  @override
  Widget build(BuildContext context) {
    final tierColor = currentTier == 'Reach'
        ? const Color(0xFF8B5CF6)
        : currentTier == 'Match'
            ? const Color(0xFF3B82F6)
            : currentTier == 'Safety'
                ? const Color(0xFF10B981)
                : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tierColor != null ? tierColor.withValues(alpha: 0.05) : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tierColor != null ? tierColor.withValues(alpha: 0.3) : AppTheme.textMuted.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ranking
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: _rankColor(university.worldRanking).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#${university.worldRanking}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _rankColor(university.worldRanking),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  university.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (currentTier != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tierColor!.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    currentTier!,
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: tierColor),
                  ),
                )
              else
                PopupMenuButton<String>(
                  onSelected: onAssignTier,
                  icon: Icon(Icons.add_circle_outline, size: 18, color: AppTheme.textSecondary),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'Reach', child: Text('🎯 Reach', style: GoogleFonts.inter(fontSize: 12))),
                    PopupMenuItem(value: 'Match', child: Text('🎯 Match', style: GoogleFonts.inter(fontSize: 12))),
                    PopupMenuItem(value: 'Safety', child: Text('🛡️ Safety', style: GoogleFonts.inter(fontSize: 12))),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 6),
          // Info row
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 12, color: AppTheme.textMuted),
              const SizedBox(width: 3),
              Text(
                '${university.city}, ${university.country}',
                style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textMuted),
              ),
              const Spacer(),
              Text(
                'Accept: ${university.acceptanceRate.toStringAsFixed(0)}%  •  GPA: ${university.averageGPA}  •  \$${(university.tuitionPerYearUSD / 1000).toStringAsFixed(0)}k/yr',
                style: GoogleFonts.inter(fontSize: 9, color: AppTheme.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Tests & Platform
          Row(
            children: [
              Icon(Icons.quiz_outlined, size: 11, color: AppTheme.textMuted),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  university.requiredTests.first,
                  style: GoogleFonts.inter(fontSize: 9, color: AppTheme.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  university.applicationPlatform,
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.accentGold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Notable programs
          Text(
            university.notablePrograms.take(4).join(' • '),
            style: GoogleFonts.inter(fontSize: 9, color: AppTheme.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _rankColor(int rank) {
    if (rank <= 10) return const Color(0xFFFFD700);
    if (rank <= 25) return const Color(0xFF8B5CF6);
    if (rank <= 50) return const Color(0xFF3B82F6);
    if (rank <= 100) return const Color(0xFF10B981);
    return AppTheme.textMuted;
  }
}

// ─── Dropdown Field (original) ───

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final int delay;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter()))).toList(),
      onChanged: (_) {},
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
      dropdownColor: context.surfaceElevated,
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}

// ─── University Tier Section ───

class _UniversityTierSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Set<String> universities;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final int delay;

  const _UniversityTierSection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.universities,
    required this.selected,
    required this.onToggle,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: -0.1),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: delay + 100)).slideX(begin: -0.1),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: universities.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final uni = entry.value;
            return _UniversityChip(
              name: uni,
              color: color,
              delay: delay + 200 + index * 40,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── University Chip (original) ───

class _UniversityChip extends StatelessWidget {
  final String name;
  final Color color;
  final int delay;

  const _UniversityChip({
    required this.name,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.check_circle_outline_rounded, size: 14, color: color.withValues(alpha: 0.7)),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.8, 0.8));
  }
}
