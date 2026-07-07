import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/app_providers.dart';
import '../../../services/api_service.dart';
import 'screen1_welcome.dart';
import 'screen2_quick_profile.dart';
import 'screen3_goals.dart';
import 'screen4_activities.dart';
import 'screen10_school_timetable.dart';
import 'screen11_free_slots.dart';
import 'screen12_school_frequency.dart';
import 'screen9_roadmap.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 8;
  late final List<Widget> _screens;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    // Reset stale static flags from previous onboarding sessions
    Screen2QuickProfile.isFormValid = false;
    Screen2QuickProfile.hasSubmitted = false;
    Screen3Goals.isFormValid = false;
    Screen3Goals.hasSubmitted = false;
    _screens = [
      const Screen1Welcome(),
      Screen2QuickProfile(onFormChanged: () {
        if (mounted) setState(() {});
      }),
      Screen3Goals(onFormChanged: () {
        if (mounted) setState(() {});
      }),
      const Screen4Activities(),
      Screen10SchoolTimetable(onFormChanged: () {
        if (mounted) setState(() {});
      }),
      Screen11FreeSlots(onFormChanged: () {
        if (mounted) setState(() {});
      }),
      Screen12SchoolFrequency(onFormChanged: () {
        if (mounted) setState(() {});
      }),
      const Screen9Roadmap(),
    ];
  }

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
      case 4: // Screen10SchoolTimetable (school start/end required)
        return Screen10SchoolTimetable.isFormValid;
      case 5: // Screen11FreeSlots (always valid — confirmation)
        return true;
      case 6: // Screen12SchoolFrequency (days per week required)
        return Screen12SchoolFrequency.isFormValid;
      default:
        return true;
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      if (!_isCurrentPageValid()) {
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
        Screen2QuickProfile.hasSubmitted = true;
        final form = Screen2QuickProfile.formKey.currentState;
        if (form != null) {
          form.validate();
        }
        break;
      case 2:
        Screen3Goals.hasSubmitted = true;
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

  /// Complete onboarding: save data, create user via API, store profile, navigate.
  void _completeOnboarding() async {
    if (_isCompleting) return; // prevent double-tap
    setState(() => _isCompleting = true);

    try {
      // 1. Read accumulated onboarding data
      final onboardingData = ref.read(onboardingDataProvider);
      debugPrint(
        '[Onboarding] Completing: name=${onboardingData.name}, '
        'board=${onboardingData.board}, countries=${onboardingData.targetCountries.length}, '
        'subjects=${onboardingData.subjects.length}',
      );

      // 2. Build a StudentProfile from the onboarding data
      final profile = buildStudentProfileFromOnboarding(onboardingData);

      // 3. Create user via backend API (best-effort — don't block onboarding)
      try {
        final apiService = ref.read(apiServiceProvider);
        final userResult = await apiService.createUser(
          name: profile.name,
          grade: profile.grade,
          board: profile.board,
          stream: profile.stream,
        );
        debugPrint('[Onboarding] User created on backend: $userResult');
      } catch (e) {
        // API is optional — app works offline
        debugPrint('[Onboarding] API user creation failed (offline mode): $e');
      }

      // 4. Set the profile in the Riverpod provider (in-memory for the rest of the app)
      ref.read(studentProfileProvider.notifier).setProfile(profile);

      // 5. Mark onboarding as completed (persists to SharedPreferences)
      final setCompleted = ref.read(setOnboardingCompletedProvider);
      await setCompleted(true);

      // 6. Persist onboarding profile to the database provider
      try {
        final persist = ref.read(persistOnboardingProfileProvider);
        await persist(profile);
      } catch (e) {
        debugPrint('[Onboarding] Profile persist warning: $e');
      }

      // 7. Reset onboarding data (no longer needed in memory)
      ref.read(onboardingDataProvider.notifier).reset();

      // The provider change will trigger main.dart to rebuild and show HomeScreen
      debugPrint('[Onboarding] Onboarding completed successfully!');
    } catch (e) {
      debugPrint('[Onboarding] Error completing onboarding: $e');
      // Still mark onboarding as completed even if there's an error
      try {
        final setCompleted = ref.read(setOnboardingCompletedProvider);
        await setCompleted(true);
      } catch (_) {}
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canProceed = _isCurrentPageValid();
    final bool isLastPage = _currentPage == _totalPages - 1;
    final bool hasForm = _currentPage == 1 || _currentPage == 2 || _currentPage == 4 || _currentPage == 6;

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
                physics: _isCurrentPageValid()
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
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
                        onPressed: _isCompleting ? null : () { HapticFeedback.lightImpact(); _previousPage(); },
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: _currentPage > 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: (canProceed || isLastPage) && !_isCompleting
                          ? () { HapticFeedback.mediumImpact(); _nextPage(); }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppTheme.primaryBlue,
                        disabledBackgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.4),
                      ),
                      child: _isCompleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isLastPage ? 'Begin Journey 🚀' : 'Continue',
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
