// Profile Edit Screen — Edit user profile with real-time validation
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../theme/app_theme.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;

  String? _selectedGrade;
  String? _selectedBoard;
  String? _selectedStream;

  bool _isLoading = false;
  bool _isSaving = false;

  static const List<String> _grades = [
    'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10',
    'Grade 11', 'Grade 12',
  ];
  static const List<String> _boards = ['CBSE', 'ICSE', 'State', 'IB', 'IGCSE'];
  static const List<String> _streams = ['Science', 'Commerce', 'Arts', 'Humanities'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _selectedGrade = prefs.getString('user_grade');
      _selectedBoard = prefs.getString('user_board');
      _selectedStream = prefs.getString('user_stream');
      _cityController.text = prefs.getString('user_city') ?? '';
      _stateController.text = prefs.getString('user_state') ?? '';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';
      final data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'grade': _selectedGrade ?? '',
        'board': _selectedBoard ?? '',
        'stream': _selectedStream ?? '',
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
      };

      // Save locally
      await prefs.setString('user_name', data['name']!);
      await prefs.setString('user_email', data['email']!);
      await prefs.setString('user_grade', data['grade']!);
      await prefs.setString('user_board', data['board']!);
      await prefs.setString('user_stream', data['stream']!);
      await prefs.setString('user_city', data['city']!);
      await prefs.setString('user_state', data['state']!);

      // POST to API
      final uri = Uri.parse('$kApiBaseUrl/api/users/$userId/profile');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (mounted) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Profile updated successfully',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                ],
              ),
              backgroundColor: AppTheme.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          _showError('Failed to save profile. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) _showError('Network error. Profile saved locally.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(message, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite;
    final cardBg = isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite;
    final textPrimary = isDark ? AppTheme.textPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.textSecondary : AppTheme.textSecondary;
    final border = isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit Profile',
            style: GoogleFonts.inter(
                fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
          semanticLabel: 'Close edit profile',
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: AppTheme.accentPurple, strokeWidth: 3))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  _buildPersonalSection(
                      cardBg, textPrimary, textSecondary, border),
                  const SizedBox(height: 20),
                  _buildAcademicSection(
                      cardBg, textPrimary, textSecondary, border),
                  const SizedBox(height: 20),
                  _buildLocationSection(
                      cardBg, textPrimary, textSecondary, border),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child, Color cardBg, Color border) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accentColor,
    required Color textPrimary,
    required Color border,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        style: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: accentColor),
          labelStyle: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w500, color: border),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: accentColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.errorRed),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required Color accentColor,
    required Color textPrimary,
    required Color border,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: border),
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        style: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: accentColor),
          labelStyle: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w500, color: border),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: accentColor, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null || v.isEmpty ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildPersonalSection(
      Color cardBg, Color textPrimary, Color textSecondary, Color border) {
    final accent = AppTheme.accentPurple;
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Personal Information', Icons.person_rounded, accent),
          const SizedBox(height: 16),
          _buildField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.badge_rounded,
            accentColor: accent,
            textPrimary: textPrimary,
            border: border,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name is required';
              if (v.trim().length < 2) return 'Name must be at least 2 characters';
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_rounded,
            accentColor: accent,
            textPrimary: textPrimary,
            border: border,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
              if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 14),
        ],
      ),
      cardBg,
      border,
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildAcademicSection(
      Color cardBg, Color textPrimary, Color textSecondary, Color border) {
    final accent = AppTheme.accentGold;
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Academic Details', Icons.school_rounded, accent),
          const SizedBox(height: 16),
          _buildDropdown(
            value: _selectedGrade,
            label: 'Grade',
            icon: Icons.stairs_rounded,
            items: _grades,
            onChanged: (v) => setState(() => _selectedGrade = v),
            accentColor: accent,
            textPrimary: textPrimary,
            border: border,
          ),
          const SizedBox(height: 10),
          _buildDropdown(
            value: _selectedBoard,
            label: 'Board',
            icon: Icons.account_balance_rounded,
            items: _boards,
            onChanged: (v) => setState(() => _selectedBoard = v),
            accentColor: accent,
            textPrimary: textPrimary,
            border: border,
          ),
          const SizedBox(height: 10),
          _buildDropdown(
            value: _selectedStream,
            label: 'Stream',
            icon: Icons.auto_stories_rounded,
            items: _streams,
            onChanged: (v) => setState(() => _selectedStream = v),
            accentColor: accent,
            textPrimary: textPrimary,
            border: border,
          ),
          const SizedBox(height: 14),
        ],
      ),
      cardBg,
      border,
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildLocationSection(
      Color cardBg, Color textPrimary, Color textSecondary, Color border) {
    final accent = AppTheme.accentTeal;
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Location', Icons.location_on_rounded, accent),
          const SizedBox(height: 16),
          _buildField(
            controller: _cityController,
            label: 'City',
            icon: Icons.location_city_rounded,
            accentColor: accent,
            textPrimary: textPrimary,
            border: border,
          ),
          const SizedBox(height: 10),
          _buildField(
            controller: _stateController,
            label: 'State',
            icon: Icons.map_rounded,
            accentColor: accent,
            textPrimary: textPrimary,
            border: border,
          ),
          const SizedBox(height: 14),
        ],
      ),
      cardBg,
      border,
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textSecondary,
                  side: BorderSide(color: border, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveProfile,
            icon: _isSaving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.check_rounded, size: 18),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }
}
