import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// DataExportImportScreen — Export/import user data.
///
/// Features:
/// - Export data as JSON
/// - Import data from file
/// - Clear all data
/// - Data size info
/// ────────────────────────────────────────────────────────────────────────────
class DataExportImportScreen extends StatefulWidget {
  const DataExportImportScreen({super.key});

  @override
  State<DataExportImportScreen> createState() =>
      _DataExportImportScreenState();
}

class _DataExportImportScreenState extends State<DataExportImportScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  bool _isClearing = false;

  Future<void> _exportData() async {
    HapticFeedback.mediumImpact();
    setState(() => _isExporting = true);

    // Simulate export
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data exported successfully!'),
          backgroundColor: Palette.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _importData() async {
    HapticFeedback.mediumImpact();
    setState(() => _isImporting = true);

    // Simulate import
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isImporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data imported successfully!'),
          backgroundColor: Palette.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _clearData() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Data'),
        content: Text(
          'This action cannot be undone. All your profile data, progress, and settings will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isClearing = true);
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) {
                setState(() => _isClearing = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All data cleared.'),
                    backgroundColor: Palette.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            child: Text('Clear', style: TextStyle(color: Palette.error)),
          ),
        ],
      ),
    );
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color:
                              dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Data Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            dark ? Palette.textPrimary : Palette.textInverse,
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

                      // ── Data Size Info ──
                      _buildDataSizeCard(dark),
                      const SizedBox(height: 24),

                      // ── Export ──
                      _buildSectionTitle('Export Data', dark),
                      const SizedBox(height: 8),
                      Text(
                        'Download your profile data as a JSON file for backup or transfer.',
                        style: TextStyle(
                          fontSize: 13,
                          color: dark
                              ? Palette.textSecondary
                              : Palette.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        icon: Icons.download,
                        title: 'Export Data',
                        subtitle: 'Download JSON file',
                        onTap: _exportData,
                        isLoading: _isExporting,
                        color: Palette.primary,
                        dark: dark,
                      ),
                      const SizedBox(height: 24),

                      // ── Import ──
                      _buildSectionTitle('Import Data', dark),
                      const SizedBox(height: 8),
                      Text(
                        'Restore your profile from a previously exported JSON file.',
                        style: TextStyle(
                          fontSize: 13,
                          color: dark
                              ? Palette.textSecondary
                              : Palette.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        icon: Icons.upload,
                        title: 'Import Data',
                        subtitle: 'Upload JSON file',
                        onTap: _importData,
                        isLoading: _isImporting,
                        color: Palette.success,
                        dark: dark,
                      ),
                      const SizedBox(height: 24),

                      // ── Danger Zone ──
                      _buildSectionTitle('Danger Zone', dark),
                      const SizedBox(height: 8),
                      Text(
                        'Permanently delete all your data. This action cannot be undone.',
                        style: TextStyle(
                          fontSize: 13,
                          color: dark
                              ? Palette.textSecondary
                              : Palette.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        icon: Icons.delete_forever,
                        title: 'Clear All Data',
                        subtitle: 'Delete everything',
                        onTap: _clearData,
                        isLoading: _isClearing,
                        color: Palette.error,
                        dark: dark,
                      ),
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

  Widget _buildDataSizeCard(bool dark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: Palette.gradientPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDataItem('Profile', '2.4 KB', Icons.person),
          _buildDataItem('Activities', '5.1 KB', Icons.star),
          _buildDataItem('Settings', '0.8 KB', Icons.settings),
          _buildDataItem('Total', '8.3 KB', Icons.storage),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String size, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 8),
        Text(
          size,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
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

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isLoading,
    required Color color,
    required bool dark,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark
              ? Palette.surface1.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    )
                  : Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: dark ? Palette.textPrimary : Palette.textInverse,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: dark
                          ? Palette.textSecondary
                          : Palette.textTertiary,
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
      ),
    );
  }
}
