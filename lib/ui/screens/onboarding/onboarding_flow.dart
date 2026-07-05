import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/app_providers.dart';
import 'screen1_welcome.dart';
import 'screen2_quick_profile.dart';
import 'screen3_goals.dart';
import 'screen4_activities.dart';
import 'screen9_roadmap.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  // Remove const since ConsumerStatefulWidget instances need widget tree setup
  final List<Widget> _screens = [
    Screen1Welcome(),
    Screen2QuickProfile(onFormChanged: () {
      // Trigger rebuild when form validity changes
      if (mounted) setState(() {});
    }),
    Screen3Goals(onFormChanged: () {
      // Trigger rebuild when form validity changes
      if (mounted) setState(() {});
    }),
    Screen4Activities(),
    Screen9Roadmap(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Returns true if the current page's form (if any) is valid.
  bool _isCurrentPageValid() {
    switch (_currentPage) {
      case 1: // Screen2QuickProfile
        return Screen2QuickProfile.isFormValid;
      case 2: // Screen3Goals
        return Screen3Goals.isFormValid;
      case 3: // Screen4Activities (display only, always valid)
        return true;
      default:
        // Pages without form validation (welcome, roadmap) are always valid
        return true;
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      // Check form validation for pages with forms
      if (!_isCurrentPageValid()) {
        // Trigger validation display by validating the form
        _triggerCurrentPageValidation();
        return;
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _triggerCurrentPageValidation() {
    switch (_currentPage) {
      case 1:
        final form = Screen2QuickProfile.formKey.currentState;
        if (form != null) {
          form.validate();
        }
        break;
      case 2:
        final form = Screen3Goals.formKey.currentState;
        if (form != null) {
          form.validate();
        }
        break;
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
    // 1. Read accumulated onboarding data
    final onboardingData = ref.read(onboardingDataProvider);

    // 2. Build a StudentProfile from the onboarding data
    final profile = buildStudentProfileFromOnboarding(onboardingData);

    // 3. Set the profile in the Riverpod provider (in-memory for the rest of the app)
    ref.read(studentProfileProvider.notifier).setProfile(profile);

    // 4. Mark onboarding as completed (persists to SharedPreferences)
    final setCompleted = ref.read(setOnboardingCompletedProvider);
    await setCompleted(true);

    // 6. Reset onboarding data (no longer needed in memory)
    ref.read(onboardingDataProvider.notifier).reset();
    // The provider change will trigger main.dart to rebuild and show HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    final bool canProceed = _isCurrentPageValid();
    final bool isLastPage = _currentPage == _totalPages - 1;
    final bool hasForm = _currentPage == 1 || _currentPage == 2;

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
                      onPressed: () { HapticFeedback.lightImpact(); _previousPage(); },
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: Text('Back', style: GoogleFonts.inter(fontSize: 14)),
                    ),
                ],
              ),
            ),
            // Validation hint for form pages
            if (hasForm && !canProceed && !isLastPage)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.warningAmber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.warningAmber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.warningAmber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Please fill in all required fields to continue',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.warningAmber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Screen content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
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
                        onPressed: () { HapticFeedback.lightImpact(); _previousPage(); },
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: _currentPage > 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: (canProceed || isLastPage) ? () { HapticFeedback.mediumImpact(); _nextPage(); } : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppTheme.primaryBlue,
                        disabledBackgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        isLastPage ? 'Begin Journey' : 'Continue',
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
