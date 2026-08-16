import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// GemWalletPanel — the wallet's real balance + spending hero card.
/// Shows the current gem balance (live from the wallet ledger) and how many
/// gems have genuinely been spent in the skin shop.
/// ────────────────────────────────────────────────────────────────────────────
class GemWalletPanel extends ConsumerWidget {
  const GemWalletPanel({super.key, required this.profileId, this.subtitle});

  final String profileId;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider(profileId)).valueOrNull;
    final gems = wallet?.gems ?? 0;
    final spent = ref.watch(gemsSpentOnSkinsProvider(profileId)).valueOrNull ?? 0;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Palette.accentBlue,
                  Palette.accentViolet,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Palette.accentViolet.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.diamond_rounded, size: 26, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$gems',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Palette.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  subtitle ?? 'gems available',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Palette.textSecondary,
                  ),
                ),
                if (spent > 0)
                  Text(
                    '$spent 💎 spent on skins',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Palette.accentViolet,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}