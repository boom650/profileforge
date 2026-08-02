import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/effects/error_widgets.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/ai/artifact_prompts.dart';
import '../../../core/theme/app_theme.dart';

/// Admissions readiness check — uses AI to assess student's college app profile
class ReadinessCheckScreen extends ConsumerStatefulWidget {
  const ReadinessCheckScreen({super.key});

  @override
  ConsumerState<ReadinessCheckScreen> createState() => _ReadinessCheckScreenState();
}

class _ReadinessCheckScreenState extends ConsumerState<ReadinessCheckScreen> {
  bool _isLoading = false;
  String? _result;
  String? _error;

  // Student data fields
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController(text: '11');
  String _goal = 'both';
  String _targetUniversity = 'MIT';
  final Set<String> _interests = {};

  final _universities = [
    'MIT', 'Stanford', 'Harvard', 'Oxford', 'Cambridge',
    'Yale', 'Princeton', 'NUS', 'ETH Zürich', 'Imperial',
  ];

  final _interestOptions = [
    'STEM', 'Research', 'Debate', 'Sports', 'Music',
    'Art', 'Community Service', 'Entrepreneurship', 'Coding', 'Writing',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  Future<void> _runCheck() async {
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final service = AiService.instance;
      final prompt = ArtifactPrompts.readinessCheck(
        studentData: {
          'name': _nameController.text.trim(),
          'grade': _gradeController.text.trim(),
          'goal': _goal,
          'interests': _interests.join(', '),
          'target': _targetUniversity,
        },
        targetUniversity: _targetUniversity,
      );

      final response = await service.generate(prompt);
      setState(() {
        _isLoading = false;
        _result = response;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to run readiness check: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(
        backgroundColor: Palette.surface1,
        title: const Text(
          'Admissions Readiness',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_result != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white70),
              onPressed: () => setState(() { _result = null; _error = null; }),
              tooltip: 'New check',
            ),
        ],
      ),
      body: _result != null
          ? _buildResult()
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Palette.primary, Palette.primary.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.assessment, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How ready are you?',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Text(
                        'AI will analyze your profile against ${_targetUniversity} requirements',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Name
          _buildTextField(controller: _nameController, label: 'Your name', hint: 'e.g., Alex'),
          const SizedBox(height: 16),

          // Grade
          _buildTextField(controller: _gradeController, label: 'Grade', hint: 'e.g., 11'),
          const SizedBox(height: 16),

          // Goal
          Text('Primary goal', style: TextStyle(color: Palette.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'academics', label: Text('Academics'), icon: Icon(Icons.school, size: 16)),
              ButtonSegment(value: 'activities', label: Text('Activities'), icon: Icon(Icons.emoji_events, size: 16)),
              ButtonSegment(value: 'both', label: Text('Both'), icon: Icon(Icons.star, size: 16)),
            ],
            selected: {_goal},
            onSelectionChanged: (s) => setState(() => _goal = s.first),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected) ? Colors.white : Palette.textSecondary),
              backgroundColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected) ? Palette.primary : Palette.surface1),
            ),
          ),
          const SizedBox(height: 20),

          // Target university
          Text('Target university', style: TextStyle(color: Palette.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _universities.map((u) {
              final selected = u == _targetUniversity;
              return ChoiceChip(
                label: Text(u, style: TextStyle(fontSize: 12)),
                selected: selected,
                onSelected: (_) => setState(() => _targetUniversity = u),
                selectedColor: Palette.primary,
                backgroundColor: Palette.surface1,
                side: BorderSide(color: selected ? Palette.primary : Palette.border),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Interests
          Text('Interests', style: TextStyle(color: Palette.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interestOptions.map((i) {
              final selected = _interests.contains(i);
              return FilterChip(
                label: Text(i, style: TextStyle(fontSize: 12)),
                selected: selected,
                onSelected: (v) => setState(() => v ? _interests.add(i) : _interests.remove(i)),
                selectedColor: Palette.primary,
                backgroundColor: Palette.surface1,
                side: BorderSide(color: selected ? Palette.primary : Palette.border),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Run button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _runCheck,
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 18),
                        SizedBox(width: 8),
                        Text('Run Readiness Check', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
          ),

          // Error
          if (_error != null) ...[
            const SizedBox(height: 16),
            PremiumErrorWidget(
              title: 'Error',
              message: _error!,
              onRetry: _runCheck,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => setState(() { _result = null; }),
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Palette.primary, size: 18),
                const SizedBox(width: 4),
                Text('New check', style: TextStyle(color: Palette.primary, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Result card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Palette.surface1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assessment, color: Palette.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Readiness Report — $_targetUniversity',
                      style: TextStyle(
                        color: Palette.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'For ${_nameController.text.trim()} • Grade ${_gradeController.text.trim()}',
                  style: TextStyle(color: Palette.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 16),

          // AI response
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Palette.surface1,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SelectableText(
              _result!,
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 24),

          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/ai-chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Discuss with AI', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Palette.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(color: Palette.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Palette.textTertiary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Palette.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Palette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Palette.primary),
            ),
            filled: true,
            fillColor: Palette.surface1,
          ),
        ),
      ],
    );
  }
}
