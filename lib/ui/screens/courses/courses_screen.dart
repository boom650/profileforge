import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

class FreeCourse {
  final String id;
  final String title;
  final String provider;
  final String category;
  final String duration;
  final String difficulty;
  final String description;
  final IconData icon;

  const FreeCourse({
    required this.id,
    required this.title,
    required this.provider,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.description,
    required this.icon,
  });
}

class EnrolledCourse extends FreeCourse {
  final double progress; // 0.0 to 1.0
  final DateTime enrolledDate;
  final bool certificateUploaded;

  const EnrolledCourse({
    required super.id,
    required super.title,
    required super.provider,
    required super.category,
    required super.duration,
    required super.difficulty,
    required super.description,
    required super.icon,
    required this.progress,
    required this.enrolledDate,
    this.certificateUploaded = false,
  });

  EnrolledCourse copyWith({double? progress, bool? certificateUploaded}) {
    return EnrolledCourse(
      id: id,
      title: title,
      provider: provider,
      category: category,
      duration: duration,
      difficulty: difficulty,
      description: description,
      icon: icon,
      progress: progress ?? this.progress,
      enrolledDate: enrolledDate,
      certificateUploaded: certificateUploaded ?? this.certificateUploaded,
    );
  }
}

// ─── Hardcoded Free Courses (Real courses from major platforms) ───────────────

const List<FreeCourse> _freeCourses = [
  FreeCourse(
    id: 'cs50',
    title: 'CS50: Introduction to Computer Science',
    provider: 'Harvard (edX)',
    category: 'Computer Science',
    duration: '12 weeks',
    difficulty: 'Beginner',
    description: 'Learn to think algorithmically and solve problems efficiently.',
    icon: Icons.computer_rounded,
  ),
  FreeCourse(
    id: 'ml_spec',
    title: 'Machine Learning Specialization',
    provider: 'Stanford (Coursera)',
    category: 'AI & ML',
    duration: '16 weeks',
    difficulty: 'Intermediate',
    description: 'Build ML models with NumPy & scikit-learn.',
    icon: Icons.psychology_rounded,
  ),
  FreeCourse(
    id: 'google_ux',
    title: 'Google UX Design Certificate',
    provider: 'Google (Coursera)',
    category: 'Design',
    duration: '8 weeks',
    difficulty: 'Beginner',
    description: 'Foundations of user experience design — audit free.',
    icon: Icons.design_services_rounded,
  ),
  FreeCourse(
    id: 'khan_calc',
    title: 'AP Calculus AB',
    provider: 'Khan Academy',
    category: 'Mathematics',
    duration: 'Self-paced',
    difficulty: 'Intermediate',
    description: 'Limits, derivatives, integrals — full AP prep.',
    icon: Icons.calculate_rounded,
  ),
  FreeCourse(
    id: 'mit_algo',
    title: 'Introduction to Algorithms',
    provider: 'MIT OpenCourseWare',
    category: 'Computer Science',
    duration: '14 weeks',
    difficulty: 'Advanced',
    description: 'Comprehensive introduction to algorithms and data structures.',
    icon: Icons.account_tree_rounded,
  ),
  FreeCourse(
    id: 'google_data',
    title: 'Google Data Analytics',
    provider: 'Google (Coursera)',
    category: 'Data Science',
    duration: '10 weeks',
    difficulty: 'Beginner',
    description: 'Ask, prepare, process, analyze, act on data — audit free.',
    icon: Icons.analytics_rounded,
  ),
  FreeCourse(
    id: 'khan_bio',
    title: 'AP Biology',
    provider: 'Khan Academy',
    category: 'Science',
    duration: 'Self-paced',
    difficulty: 'Intermediate',
    description: 'Evolution, genetics, ecology, and cellular processes.',
    icon: Icons.biotech_rounded,
  ),
  FreeCourse(
    id: 'ibm_ai',
    title: 'AI Foundations for Everyone',
    provider: 'IBM (Coursera)',
    category: 'AI & ML',
    duration: '6 weeks',
    difficulty: 'Beginner',
    description: 'Introduction to artificial intelligence concepts and applications.',
    icon: Icons.smart_toy_rounded,
  ),
  FreeCourse(
    id: 'coursera_python',
    title: 'Programming for Everybody (Python)',
    provider: 'University of Michigan (Coursera)',
    category: 'Programming',
    duration: '7 weeks',
    difficulty: 'Beginner',
    description: 'Get started with Python — no prior experience needed.',
    icon: Icons.code_rounded,
  ),
  FreeCourse(
    id: 'khan_econ',
    title: 'AP Microeconomics',
    provider: 'Khan Academy',
    category: 'Economics',
    duration: 'Self-paced',
    difficulty: 'Intermediate',
    description: 'Supply & demand, market structures, and game theory.',
    icon: Icons.trending_up_rounded,
  ),
  FreeCourse(
    id: 'edx_writing',
    title: 'English Composition',
    provider: 'Arizona State University (edX)',
    category: 'Writing',
    duration: '8 weeks',
    difficulty: 'Beginner',
    description: 'Develop effective writing skills for college and beyond.',
    icon: Icons.edit_note_rounded,
  ),
  FreeCourse(
    id: 'google_angular',
    title: 'Angular: Getting Started',
    provider: 'Google (Coursera)',
    category: 'Programming',
    duration: '4 weeks',
    difficulty: 'Intermediate',
    description: 'Build modern web apps with the Angular framework.',
    icon: Icons.web_rounded,
  ),
  FreeCourse(
    id: 'mit_physics',
    title: 'Mechanics: Kinematics and Dynamics',
    provider: 'MIT OpenCourseWare',
    category: 'Science',
    duration: '10 weeks',
    difficulty: 'Intermediate',
    description: 'Newtonian mechanics — forces, energy, and momentum.',
    icon: Icons.rocket_launch_rounded,
  ),
  FreeCourse(
    id: 'coursera_sustainability',
    title: 'Sustainable Development',
    provider: 'University of Copenhagen (Coursera)',
    category: 'Environment',
    duration: '5 weeks',
    difficulty: 'Beginner',
    description: 'Understand the SDGs and sustainable practices.',
    icon: Icons.eco_rounded,
  ),
  FreeCourse(
    id: 'google_digital',
    title: 'Fundamentals of Digital Marketing',
    provider: 'Google (Skillshop)',
    category: 'Marketing',
    duration: '40 hours',
    difficulty: 'Beginner',
    description: 'Learn SEO, SEM, social media, and analytics — certified free.',
    icon: Icons.campaign_rounded,
  ),
];

// ─── Category Color Mapping ──────────────────────────────────────────────────

Color _categoryColor(String category) {
  switch (category) {
    case 'Computer Science':
      return const Color(0xFF6C63FF);
    case 'AI & ML':
      return const Color(0xFF7C3AED);
    case 'Design':
      return const Color(0xFFE11D48);
    case 'Mathematics':
      return const Color(0xFF0891B2);
    case 'Science':
      return const Color(0xFF059669);
    case 'Data Science':
      return const Color(0xFF0EA5E9);
    case 'Programming':
      return const Color(0xFF2563EB);
    case 'Economics':
      return const Color(0xFFD97706);
    case 'Writing':
      return const Color(0xFFDB2777);
    case 'Environment':
      return const Color(0xFF16A34A);
    case 'Marketing':
      return const Color(0xFFEA580C);
    default:
      return AppTheme.primary;
  }
}

// ─── Main Screen ─────────────────────────────────────────────────────────────

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  final Set<String> _enrolledIds = {};
  final Map<String, EnrolledCourse> _enrolledCourses = {};
  String _selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();

  static const _categories = [
    'All',
    'Computer Science',
    'AI & ML',
    'Programming',
    'Science',
    'Mathematics',
    'Design',
    'Economics',
    'Writing',
    'Environment',
    'Marketing',
  ];

  List<FreeCourse> get _filteredCourses {
    if (_selectedFilter == 'All') return _freeCourses;
    return _freeCourses.where((c) => c.category == _selectedFilter).toList();
  }

  void _enrollCourse(FreeCourse course) {
    HapticFeedback.lightImpact();
    setState(() {
      _enrolledIds.add(course.id);
      _enrolledCourses[course.id] = EnrolledCourse(
        id: course.id,
        title: course.title,
        provider: course.provider,
        category: course.category,
        duration: course.duration,
        difficulty: course.difficulty,
        description: course.description,
        icon: course.icon,
        progress: 0.0,
        enrolledDate: DateTime.now(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Enrolled in "${course.title}" — start learning! 🎓',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _simulateProgress(String courseId) {
    HapticFeedback.mediumImpact();
    final course = _enrolledCourses[courseId];
    if (course == null) return;

    final newProgress = (course.progress + 0.15).clamp(0.0, 1.0);
    setState(() {
      _enrolledCourses[courseId] = course.copyWith(progress: newProgress);
    });

    if (newProgress >= 1.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Course completed! Upload your certificate 🏆',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.accentGold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showCertificateSheet(String courseId) {
    HapticFeedback.heavyImpact();
    final course = _enrolledCourses[courseId];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CertificateUploadSheet(
        courseTitle: course?.title ?? '',
        onUpload: (method) {
          Navigator.of(ctx).pop();
          setState(() {
            _enrolledCourses[courseId] =
                _enrolledCourses[courseId]?.copyWith(certificateUploaded: true) ??
                    _enrolledCourses[courseId]!;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Certificate submitted for verification via $method ✅',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              backgroundColor: AppTheme.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceBg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Gradient Header ──────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader()),
          // ── Category Filters ────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildCategoryFilters()),
          // ── Enrolled Courses Section ────────────────────────────────────
          if (_enrolledCourses.isNotEmpty) ...[
            SliverToBoxAdapter(child: _buildSectionHeader('My Courses', Icons.school_rounded)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _buildEnrolledCard(_enrolledCourses.values.elementAt(i)),
                  childCount: _enrolledCourses.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
          // ── Discover Courses Section ────────────────────────────────────
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              'Discovered Courses',
              Icons.explore_rounded,
              count: _filteredCourses.length,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildCourseCard(_filteredCourses[i]),
                ),
                childCount: _filteredCourses.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      // ── Certificate Upload FAB ────────────────────────────────────────────
      floatingActionButton: _enrolledCourses.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                final unuploaded = _enrolledCourses.values
                    .where((c) => c.progress >= 1.0 && !c.certificateUploaded)
                    .toList();
                if (unuploaded.isNotEmpty) {
                  _showCertificateSheet(unuploaded.first.id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Complete a course first to upload a certificate 📚',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 8,
              icon: const Icon(Icons.verified_rounded),
              label: Text(
                'Upload Certificate',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3)
          : null,
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats row
              Row(
                children: [
                  _buildStatBubble('${_enrolledCourses.length}', 'Enrolled'),
                  const SizedBox(width: 12),
                  _buildStatBubble(
                    '${_enrolledCourses.values.where((c) => c.progress >= 1.0).length}',
                    'Completed',
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),
              const SizedBox(height: 24),
              Text(
                'Free Courses',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
              const SizedBox(height: 6),
              Text(
                'Discover free courses from top universities\nand earn certificates for your profile',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBubble(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Filters ───────────────────────────────────────────────────────

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final cat = _categories[i];
          final isSelected = _selectedFilter == cat;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedFilter = cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : context.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primary
                      : context.borderColor,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                cat,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : context.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.05);
  }

  // ── Section Header ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, IconData icon, {int? count}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  // ── Enrolled Course Card ───────────────────────────────────────────────────

  Widget _buildEnrolledCard(EnrolledCourse course) {
    final progressColor = course.progress >= 1.0
        ? AppTheme.successGreen
        : AppTheme.primary;
    final progressPercent = (course.progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: course.progress >= 1.0
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: progressColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Course icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _categoryColor(course.category).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  course.icon,
                  color: _categoryColor(course.category),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Title and provider
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      course.provider,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              if (course.certificateUploaded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, size: 12, color: AppTheme.successGreen),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                )
              else if (course.progress >= 1.0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Completed',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$progressPercent% complete',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: progressColor,
                    ),
                  ),
                  Text(
                    course.duration,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: context.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 6,
                  backgroundColor: context.borderColor,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _simulateProgress(course.id),
                  icon: Icon(
                    course.progress >= 1.0
                        ? Icons.check_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                    size: 18,
                  ),
                  label: Text(
                    course.progress >= 1.0 ? 'Completed' : 'Continue',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: progressColor),
                    foregroundColor: progressColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              if (course.progress >= 1.0 && !course.certificateUploaded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCertificateSheet(course.id),
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: Text(
                      'Upload Cert',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  // ── Discovered Course Card ─────────────────────────────────────────────────

  Widget _buildCourseCard(FreeCourse course) {
    final isEnrolled = _enrolledIds.contains(course.id);
    final catColor = _categoryColor(course.category);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEnrolled
              ? AppTheme.primary.withValues(alpha: 0.3)
              : context.borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      catColor.withValues(alpha: 0.15),
                      catColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(course.icon, color: catColor, size: 24),
              ),
              const SizedBox(width: 14),
              // Title and metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.provider,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _difficultyColor(course.difficulty).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  course.difficulty,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _difficultyColor(course.difficulty),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            course.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textMuted,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          // Tags row
          Row(
            children: [
              _buildTag(course.category, catColor),
              const SizedBox(width: 8),
              _buildTag(course.duration, AppTheme.textMuted),
              if (isEnrolled) ...[
                const SizedBox(width: 8),
                _buildTag('Enrolled', AppTheme.primary),
              ],
              const Spacer(),
              // Start / Enrolled button
              isEnrolled
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded, size: 16, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Enrolled',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => _enrollCourse(course),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(
                        'Start',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppTheme.primary.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return const Color(0xFF059669);
      case 'Intermediate':
        return const Color(0xFFD97706);
      case 'Advanced':
        return const Color(0xFFE11D48);
      default:
        return AppTheme.textMuted;
    }
  }
}

// ─── Certificate Upload Bottom Sheet ─────────────────────────────────────────

class _CertificateUploadSheet extends StatelessWidget {
  final String courseTitle;
  final ValueChanged<String> onUpload;

  const _CertificateUploadSheet({
    required this.courseTitle,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ).animate().scale(delay: 100.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Upload Certificate',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 4),
                  Text(
                    courseTitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.textMuted,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Upload options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildUploadOption(
                    context,
                    icon: Icons.camera_alt_rounded,
                    label: 'Take Photo',
                    description: 'Capture certificate with camera',
                    color: const Color(0xFF0891B2),
                    delay: 250.ms,
                    onTap: () => onUpload('Camera'),
                  ),
                  const SizedBox(height: 12),
                  _buildUploadOption(
                    context,
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    description: 'Choose from photo gallery',
                    color: const Color(0xFF7C3AED),
                    delay: 300.ms,
                    onTap: () => onUpload('Gallery'),
                  ),
                  const SizedBox(height: 12),
                  _buildUploadOption(
                    context,
                    icon: Icons.picture_as_pdf_rounded,
                    label: 'Upload PDF',
                    description: 'Select a PDF certificate file',
                    color: const Color(0xFFE11D48),
                    delay: 350.ms,
                    onTap: () => onUpload('PDF'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Cancel
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required Duration delay,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: context.textMuted),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: 0.05);
  }
}
