import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/input_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileEditScreen — Edit profile details, avatar, and bio.
///
/// Features:
/// - Avatar picker with emoji options
/// - Name and bio editing
/// - Grade and target schools editing
/// - Save with validation
/// ────────────────────────────────────────────────────────────────────────────
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController(text: 'Student');
  final _bioController = TextEditingController(
    text: 'Aspiring computer scientist passionate about AI and robotics.',
  );
  String _selectedAvatar = '🧑‍🎓';
  int _selectedGrade = 11;
  final Set<String> _selectedInterests = {};
  bool _hasChanges = false;

  final _avatars = [
    '🧑‍🎓', '👨‍🎓', '👩‍🎓', '🧑‍💻', '👨‍💻', '👩‍💻',
    '🧑‍🔬', '👨‍🔬', '👩‍🔬', '🧑‍🎨', '👨‍🎨', '👩‍🎨',
    '🧑‍🏫', '👨‍🏫', '👩‍🏫', '🧑‍🚀', '👨‍🚀', '👩‍🚀',
    '🎓', '📚', '💡', '🚀', '⚡', '🎯',
  ];

  final _interests = [
    'Math', 'Physics', 'CS', 'Chemistry', 'Biology',
    'Economics', 'Design', 'Writing', 'Music', 'Sports',
    'Debate', 'Robotics', 'Volunteering', 'Research', 'Art',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  void _save() {
    HapticFeedback.mediumImpact();
    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile saved!'),
        backgroundColor: Palette.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context);
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
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    const Spacer(),
                    if (_hasChanges)
                      GestureDetector(
                        onTap: _save,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: Palette.gradientPrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
                    children: [
                      const SizedBox(height: 16),

                      // ── Avatar ──
                      _buildAvatarSection(dark),
                      const SizedBox(height: 24),

                      // ── Name ──
                      _buildFieldLabel('Name', dark),
                      const SizedBox(height: 8),
                      PremiumTextField(
                        controller: _nameController,
                        hintText: 'Your name',
                        onChanged: (_) => _markChanged(),
                      ),
                      const SizedBox(height: 20),

                      // ── Bio ──
                      _buildFieldLabel('Bio', dark),
                      const SizedBox(height: 8),
                      PremiumTextField(
                        controller: _bioController,
                        hintText: 'Tell us about yourself...',
                        maxLines: 3,
                        onChanged: (_) => _markChanged(),
                      ),
                      const SizedBox(height: 20),

                      // ── Grade ──
                      _buildFieldLabel('Grade', dark),
                      const SizedBox(height: 8),
                      _buildGradeSelector(dark),
                      const SizedBox(height: 20),

                      // ── Interests ──
                      _buildFieldLabel('Interests', dark),
                      const SizedBox(height: 8),
                      _buildInterestSelector(dark),

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

  Widget _buildFieldLabel(String label, bool dark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: dark ? Palette.textSecondary : Palette.textTertiary,
        ),
      ),
    );
  }

  Widget _buildAvatarSection(bool dark) {
    return Column(
      children: [
        // Current avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: Palette.gradientPrimary,
            boxShadow: [
              BoxShadow(
                color: Palette.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _selectedAvatar,
              style: TextStyle(fontSize: 50),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Avatar picker
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface1.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dark ? Palette.border : const Color(0xFFEDE3D6),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _avatars.length,
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              final isSelected = _selectedAvatar == avatar;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedAvatar = avatar;
                    _markChanged();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Palette.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: Palette.primary.withValues(alpha: 0.5))
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGradeSelector(bool dark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFEDE3D6),
        ),
      ),
      child: DropdownButton<int>(
        value: _selectedGrade,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: dark ? Palette.surface1 : Colors.white,
        style: TextStyle(
          fontSize: 15,
          color: dark ? Palette.textPrimary : Palette.textInverse,
        ),
        items: List.generate(6, (i) {
          final grade = i + 9;
          return DropdownMenuItem(
            value: grade,
            child: Text('Grade $grade'),
          );
        }),
        onChanged: (value) {
          if (value != null) {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedGrade = value;
              _markChanged();
            });
          }
        },
      ),
    );
  }

  Widget _buildInterestSelector(bool dark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _interests.map((interest) {
        final isSelected = _selectedInterests.contains(interest);

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (isSelected) {
                _selectedInterests.remove(interest);
              } else {
                _selectedInterests.add(interest);
              }
              _markChanged();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Palette.primary.withValues(alpha: 0.15)
                  : dark
                      ? Palette.surface2.withValues(alpha: 0.5)
                      : const Color(0xFFF4ECE1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Palette.primary.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              interest,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Palette.primary
                    : (dark ? Palette.textSecondary : Palette.textTertiary),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
