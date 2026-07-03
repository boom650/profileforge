import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/app_providers.dart';
import 'screen1_welcome.dart';
import 'screen2_consent.dart';
import 'screen3_location_school.dart';
import 'screen4_academic_profile.dart';
import 'screen5_activity_inventory.dart';
import 'screen6_target_universities.dart';
import 'screen7_schedule_builder.dart';
import 'screen8_motivation_personality.dart';
import 'screen9_roadmap.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 9;

  final List<Widget> _screens = const [
    Screen1Welcome(),
    Screen2Consent(),
    Screen3LocationSchool(),
    Screen4AcademicProfile(),
    Screen5ActivityInventory(),
    Screen6TargetUniversities(),
    Screen7ScheduleBuilder(),
    Screen8MotivationPersonality(),
    Screen9Roadmap(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _completeOnboarding() async {
    final setCompleted = ref.read(setOnboardingCompletedProvider);
    await setCompleted(true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: List.generate(_totalPages, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < _totalPages - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: index <= _currentPage 
                            ? AppTheme.primaryBlue 
                            : AppTheme.primaryBlue.withValues(alpha: 0.15),
                      ),
                    ).animate().scaleX(
                      delay: Duration(milliseconds: 100 * index),
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                    ),
                  );
                }),
              ),
            ),
            // Page indicator text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_currentPage + 1} of $_totalPages',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: Text('Back', style: GoogleFonts.inter(fontSize: 14)),
                    ),
                ],
              ),
            ),
            // Screen content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _totalPages,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _screens[index],
              ),
            ),
            // Bottom navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: _currentPage > 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppTheme.primaryBlue,
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1 ? 'Begin Journey' : 'Continue',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ).animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}