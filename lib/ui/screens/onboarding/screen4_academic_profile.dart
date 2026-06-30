import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class Screen4AcademicProfile extends StatelessWidget {
  const Screen4AcademicProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {'name': 'Physics', 'controller': TextEditingController(text: '85')},
      {'name': 'Chemistry', 'controller': TextEditingController(text: '82')},
      {'name': 'Mathematics', 'controller': TextEditingController(text: '90')},
      {'name': 'English', 'controller': TextEditingController(text: '88')},
      {'name': 'Computer Science', 'controller': TextEditingController(text: '92')},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Academic Profile',
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
            'Your grades help us calibrate admissions probability',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 32),
          // Board & Stream
          Row(
            children: [
              Expanded(
                child: _DropdownField(
                  label: 'Board',
                  value: 'CBSE',
                  items: ['CBSE', 'ICSE', 'State Board', 'IB', 'IGCSE', 'NIOS'],
                  delay: 200,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DropdownField(
                  label: 'Stream',
                  value: 'Science',
                  items: ['Science', 'Commerce', 'Humanities', 'Vocational'],
                  delay: 250,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Grade',
            value: '11th',
            items: ['9th', '10th', '11th', '12th'],
            delay: 300,
          ),
          const SizedBox(height: 24),
          Text(
            'Subjects & Current %',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ).animate().fadeIn(delay: 350.ms),
          const SizedBox(height: 12),
          Column(
            children: subjects.asMap().entries.map((entry) {
              final index = entry.key;
              final subject = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        subject['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: subject['controller'] as TextEditingController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '%',
                          suffixText: '%',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: Duration(milliseconds: 400 + index * 50)).slideX(begin: 0.1),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _InputField(
            label: '10th Board Percentage',
            hintText: 'e.g., 94.2%',
            prefixIcon: Icons.percent_rounded,
            delay: 600,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  label: 'Coaching Institute',
                  hintText: 'e.g., Allen, Aakash, FIITJEE',
                  prefixIcon: Icons.business_rounded,
                  delay: 650,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InputField(
                  label: 'Coaching Hours/Week',
                  hintText: 'e.g., 20',
                  prefixIcon: Icons.access_time_rounded,
                  keyboardType: TextInputType.number,
                  delay: 700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  label: 'SAT Score',
                  hintText: 'e.g., 1450',
                  prefixIcon: Icons.grade_rounded,
                  keyboardType: TextInputType.number,
                  delay: 750,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InputField(
                  label: 'IELTS Score',
                  hintText: 'e.g., 7.5',
                  prefixIcon: Icons.language_rounded,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  delay: 800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '11th grade marks are critical — they\'re used for predicted grades (US/UK) and early admissions (Canada/Australia)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 850.ms),
        ],
      ),
    );
  }
}

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
      dropdownColor: AppTheme.surfaceWhite,
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final int delay;
  final TextInputType? keyboardType;

  const _InputField({
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.delay,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppTheme.primaryBlue),
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}