import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// HelpFeedbackScreen — FAQ, help articles, and feedback submission.
///
/// Features:
/// - Expandable FAQ sections
/// - Contact support
/// - Send feedback with rating
/// - App version and links
/// ────────────────────────────────────────────────────────────────────────────
class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({super.key});

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  final _feedbackController = TextEditingController();
  int _feedbackRating = 0;
  final _expandedFaq = <int>{};

  final _faqs = [
    _FaqItem(
      question: 'How does the AI profile analysis work?',
      answer:
          'ProfileForge uses advanced AI to analyze your activities, essays, and academic profile. It considers your unique strengths, personality traits, and target schools to provide personalized recommendations for improving your college application.',
    ),
    _FaqItem(
      question: 'What is the psychology assessment?',
      answer:
          'The psychology assessment helps our AI understand your personality type, stress response patterns, learning style, and communication preferences. This allows the AI to tailor its advice and feedback to how you work best.',
    ),
    _FaqItem(
      question: 'How accurate is the profile score?',
      answer:
          'The profile score is an estimate based on patterns from successful applicants to your target schools. It considers academic strength, test scores, activities, essays, and recommendations. While not definitive, it provides a useful benchmark.',
    ),
    _FaqItem(
      question: 'Can I change my target schools?',
      answer:
          'Yes! Go to Settings > Profile > Target Universities to update your list. The AI will adjust its recommendations based on your new targets.',
    ),
    _FaqItem(
      question: 'How do I connect my AI provider?',
      answer:
          'Go to Settings > AI > API Key Setup. You can connect OpenAI, Anthropic, Google, or other compatible providers. You will need an API key from your chosen provider.',
    ),
    _FaqItem(
      question: 'Is my data secure?',
      answer:
          'Yes. Your data is encrypted and stored securely on your device. API calls are made directly to your chosen AI provider. We never share your personal information with third parties.',
    ),
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [const Color(0xFFFBF1E3), Palette.cream, Palette.creamCard],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Help & Feedback',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── FAQ Section ──
                      _buildSectionTitle('Frequently Asked Questions', dark),
                      const SizedBox(height: 12),
                      ...List.generate(_faqs.length, (i) => _buildFaqItem(i, dark)),

                      const SizedBox(height: 24),

                      // ── Send Feedback ──
                      _buildSectionTitle('Send Feedback', dark),
                      const SizedBox(height: 12),
                      _buildFeedbackSection(dark),

                      const SizedBox(height: 24),

                      // ── Contact ──
                      _buildSectionTitle('Contact', dark),
                      const SizedBox(height: 12),
                      _buildContactOption(
                        icon: Icons.email_outlined,
                        title: 'Email Support',
                        subtitle: 'support@profileforge.app',
                        dark: dark,
                      ),
                      const SizedBox(height: 8),
                      _buildContactOption(
                        icon: Icons.chat_bubble_outline,
                        title: 'Live Chat',
                        subtitle: 'Available 9am-5pm EST',
                        dark: dark,
                      ),

                      const SizedBox(height: 24),

                      // ── App Info ──
                      _buildSectionTitle('About', dark),
                      const SizedBox(height: 12),
                      _buildAppInfo(dark),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: dark ? Palette.textPrimary : Palette.textInverse,
      ),
    );
  }

  Widget _buildFaqItem(int index, bool dark) {
    final isExpanded = _expandedFaq.contains(index);
    final faq = _faqs[index];

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          if (isExpanded) {
            _expandedFaq.remove(index);
          } else {
            _expandedFaq.add(index);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark
              ? Palette.surface1.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: dark ? Palette.border : const Color(0xFFEDE3D6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: dark ? Palette.textPrimary : Palette.textInverse,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Text(
                faq.answer,
                style: TextStyle(
                  fontSize: 13,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(bool dark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFEDE3D6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating
          Text(
            'How would you rate your experience?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _feedbackRating = i + 1);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    i < _feedbackRating ? Icons.star : Icons.star_border,
                    size: 32,
                    color: i < _feedbackRating
                        ? Palette.warning
                        : (dark ? Palette.textTertiary : Palette.textSecondary),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Feedback text
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tell us what you think...',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Palette.textTertiary,
              ),
              filled: true,
              fillColor: dark
                  ? Palette.surface2.withValues(alpha: 0.5)
                  : const Color(0xFFF4ECE1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 12),

          // Submit
          GestureDetector(
            onTap: () {
              if (_feedbackController.text.isNotEmpty) {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for your feedback!'),
                    backgroundColor: Palette.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
                _feedbackController.clear();
                setState(() => _feedbackRating = 0);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool dark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFEDE3D6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Palette.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Palette.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: dark ? Palette.textSecondary : Palette.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: dark ? Palette.textTertiary : Palette.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo(bool dark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFEDE3D6),
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow('Version', '1.0.0', dark),
          const Divider(height: 24),
          _buildInfoRow('Build', '2026.08.05', dark),
          const Divider(height: 24),
          _buildInfoRow('Flutter', '3.x', dark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool dark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: dark ? Palette.textSecondary : Palette.textTertiary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
      ],
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}
