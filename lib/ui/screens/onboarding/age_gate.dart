import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';

/// Age verification status stored in SharedPreferences.
enum AgeVerificationStatus {
  notVerified,
  under13,       // COPPA blocked
  minor13to17,   // Limited features
  adult18plus,   // Full access
}

/// Provider for age verification state.
final ageVerificationProvider = FutureProvider<AgeVerificationStatus>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final statusIndex = prefs.getInt('age_verification_status') ?? 0;
  return AgeVerificationStatus.values[statusIndex];
});

/// Provider to set age verification status.
final setAgeVerificationProvider = Provider<Future<void> Function(AgeVerificationStatus)>((ref) {
  return (AgeVerificationStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age_verification_status', status.index);
    ref.invalidate(ageVerificationProvider);
  };
});

class AgeGateScreen extends ConsumerStatefulWidget {
  const AgeGateScreen({super.key});

  @override
  ConsumerState<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends ConsumerState<AgeGateScreen> {
  DateTime? _selectedDate;
  AgeVerificationStatus? _resultStatus;
  bool _isLoading = false;

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  AgeVerificationStatus _getStatusForAge(int age) {
    if (age < 13) return AgeVerificationStatus.under13;
    if (age < 18) return AgeVerificationStatus.minor13to17;
    return AgeVerificationStatus.adult18plus;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(now.year - 15, now.month, now.day),
      firstDate: DateTime(1990, 1, 1),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              surface: AppTheme.surfaceWhite,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        final age = _calculateAge(picked);
        _resultStatus = _getStatusForAge(age);
      });
    }
  }

  Future<void> _confirmAge() async {
    if (_selectedDate == null || _resultStatus == null) return;

    setState(() => _isLoading = true);

    final setAgeVerification = ref.read(setAgeVerificationProvider);
    await setAgeVerification(_resultStatus!);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (_resultStatus == AgeVerificationStatus.under13) {
      // Show block message - COPPA requires parental consent
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: Icon(
            Icons.lock_rounded,
            color: AppTheme.errorRed,
            size: 48,
          ),
          title: Text(
            'Parental Consent Required',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Under the Children\'s Online Privacy Protection Act (COPPA), users under 13 '
            'require parental consent to use this app. Please ask a parent or guardian '
            'to help you set up your account.',
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedDate = null;
                  _resultStatus = null;
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    } else {
      // Navigate to onboarding or home
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ageText = _selectedDate != null
        ? '${_calculateAge(_selectedDate!)} years old'
        : null;

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Shield icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.gradientPrimary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ).animate().scale(
                    delay: 200.ms,
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Welcome to ProfileForge',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'To provide you with the best experience and comply with privacy regulations, '
                'we need to verify your age.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

              const SizedBox(height: 48),

              // Date of birth selector
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedDate != null
                        ? AppTheme.primaryBlue.withValues(alpha: 0.3)
                        : AppTheme.textMuted.withValues(alpha: 0.3),
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
                  children: [
                    Text(
                      'Date of Birth',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.textMuted.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: _selectedDate != null
                                  ? AppTheme.primaryBlue
                                  : AppTheme.textMuted,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select your date of birth',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: _selectedDate != null
                                    ? AppTheme.textPrimary
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (ageText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        ageText,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

              const SizedBox(height: 24),

              // Age status indicator
              if (_resultStatus != null) ...[
                _buildStatusBadge(_resultStatus!),
                const SizedBox(height: 24),
              ],

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedDate != null && !_isLoading
                      ? _confirmAge
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    disabledBackgroundColor: AppTheme.textMuted.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _selectedDate != null
                                ? Colors.white
                                : AppTheme.textMuted,
                          ),
                        ),
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

              const SizedBox(height: 24),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.primaryBlue.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your age information is stored locally on your device and is used '
                        'only to comply with privacy regulations. It is never shared with third parties.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AgeVerificationStatus status) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case AgeVerificationStatus.under13:
        bgColor = AppTheme.errorRed.withValues(alpha: 0.1);
        textColor = AppTheme.errorRed;
        icon = Icons.block_rounded;
        text = 'COPPA: Parental consent required';
        break;
      case AgeVerificationStatus.minor13to17:
        bgColor = AppTheme.warningAmber.withValues(alpha: 0.1);
        textColor = AppTheme.warningAmber;
        icon = Icons.info_rounded;
        text = 'Minor account — some features may be limited';
        break;
      case AgeVerificationStatus.adult18plus:
        bgColor = AppTheme.successGreen.withValues(alpha: 0.1);
        textColor = AppTheme.successGreen;
        icon = Icons.check_circle_rounded;
        text = 'Full access granted';
        break;
      case AgeVerificationStatus.notVerified:
        bgColor = AppTheme.textMuted.withValues(alpha: 0.1);
        textColor = AppTheme.textMuted;
        icon = Icons.help_outline_rounded;
        text = 'Not verified';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1);
  }
}
