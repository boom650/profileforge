import 'package:flutter/material.dart';
import 'package:profileforge/core/effects/shimmer_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/effects/error_widgets.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../application/artifact_analyzer_provider.dart';

/// Artifact Analyzer screen — analyze research, essays, activities
class ArtifactAnalyzerScreen extends ConsumerStatefulWidget {
  const ArtifactAnalyzerScreen({super.key});

  @override
  ConsumerState<ArtifactAnalyzerScreen> createState() => _ArtifactAnalyzerScreenState();
}

class _ArtifactAnalyzerScreenState extends ConsumerState<ArtifactAnalyzerScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(artifactAnalyzerProvider);
    final aiConfigured = ref.watch(aiConfiguredProvider);

    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(
        backgroundColor: Palette.surface1,
        title: const Text(
          'Artifact Analyzer',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (state.analysis != null || state.isLoading)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white70),
              onPressed: () => ref.read(artifactAnalyzerProvider.notifier).reset(),
              tooltip: 'New analysis',
            ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI status
            aiConfigured.when(
              data: (configured) => configured
                  ? const SizedBox.shrink()
                  : _banner('Add API key in Settings', Palette.primary),
              loading: () => const SizedBox.shrink(),
              error: (e, _) => PremiumErrorWidget(
                title: 'Config Error',
                message: '$e',
              ),
            ),

            // Artifact type selector
            Text(
              'What are you analyzing?',
              style: TextStyle(color: Palette.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildTypeSelector(state.selectedType),
            const SizedBox(height: 20),

            // Title input
            _buildTextField(
              controller: _titleController,
              label: state.selectedType == ArtifactType.essay
                  ? 'Essay prompt or title'
                  : 'Title',
              hint: state.selectedType == ArtifactType.essay
                  ? 'e.g., "Describe a challenge you overcame"'
                  : 'e.g., "Machine Learning Research on Predicting..."',
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // Content input
            _buildTextField(
              controller: _contentController,
              label: 'Content to analyze',
              hint: 'Paste your research paper, essay, activity description, or project details...',
              maxLines: 10,
            ),
            const SizedBox(height: 16),

            // Analyze button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 18),
                          SizedBox(width: 8),
                          Text('Analyze', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Error
            if (state.error != null) _banner(state.error!, Palette.error),

            // Results
            if (state.analysis != null) _buildResults(state.analysis!),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(ArtifactType selected) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ArtifactType.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = ArtifactType.values[index];
          final isSelected = type == selected;
          return ChoiceChip(
            label: Text(type.label, style: TextStyle(fontSize: 12)),
            avatar: Icon(type.icon, size: 14),
            selected: isSelected,
            onSelected: (_) => ref.read(artifactAnalyzerProvider.notifier).setType(type),
            selectedColor: Palette.primary.withOpacity(0.2),
            backgroundColor: Palette.surface1,
            side: BorderSide(
              color: isSelected
                  ? Palette.primary
                  : Palette.border.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Palette.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: Palette.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Palette.textTertiary, fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Palette.border.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Palette.border.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Palette.primary),
            ),
            filled: true,
            fillColor: Palette.surface1,
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _banner(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 13))),
        ],
      ),
      ),
    );
  }

  Widget _buildResults(ArtifactAnalysis analysis) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.border.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Palette.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                analysis.summary,
                style: TextStyle(
                  color: Palette.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Analyzed: ${_formatDate(analysis.analyzedAt)}',
            style: TextStyle(color: Palette.textTertiary, fontSize: 11),
          ),
          const SizedBox(height: 12),
          SelectableText(
            analysis.rawResponse,
            style: TextStyle(
              color: Palette.textPrimary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _analyze() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both title and content'),
          backgroundColor: Palette.error,
        ),
      );
      return;
    }
    ref.read(artifactAnalyzerProvider.notifier).analyze(
          title: title,
          content: content,
        );
  }
}
