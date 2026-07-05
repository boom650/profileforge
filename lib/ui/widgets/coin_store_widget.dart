/// Coin Store Screen
///
/// A game-shop-style screen where users can browse and purchase items
/// with their earned coins. Uses flutter_animate for entrance animations
/// and the project's AppTheme for consistent styling.

// ignore_for_file: non_const_argument_for_const_parameter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../../models/gamification/coin_store.dart';
import 'daily_reward_widget.dart';

// ---------------------------------------------------------------------------
// CoinStoreScreen
// ---------------------------------------------------------------------------

class CoinStoreScreen extends StatefulWidget {
  final CoinStore store;
  final VoidCallback? onBalanceChanged;

  const CoinStoreScreen({
    super.key,
    required this.store,
    this.onBalanceChanged,
  });

  @override
  State<CoinStoreScreen> createState() => _CoinStoreScreenState();
}

class _CoinStoreScreenState extends State<CoinStoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ShopCategory.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceElevated,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header with balance ────────────────────────────────────────
            _buildHeader(),

            // ── Daily Reward Banner ────────────────────────────────────────
            if (widget.store.canClaimDailyReward)
              _buildDailyRewardBanner(),

            // ── Tab Bar ────────────────────────────────────────────────────
            _buildTabBar(),

            // ── Item Grid ──────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: ShopCategory.values
                    .map((cat) => _buildItemGrid(cat))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        border: Border(
          bottom: BorderSide(color: context.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.borderColor),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coin Store',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Spend your hard-earned coins wisely',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Coin balance pill
          _buildBalancePill(),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildBalancePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppTheme.gradientGold,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.monetization_on_rounded,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            '${widget.store.balance}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Daily Reward Banner ──────────────────────────────────────────────────

  Widget _buildDailyRewardBanner() {
    return GestureDetector(
      onTap: () => _showDailyReward(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accentGold.withValues(alpha: 0.15),
              AppTheme.accentOrange.withValues(alpha: 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentGold.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Gift icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppTheme.accentGold,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Reward Available!',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Day ${widget.store.currentStreakDay} of 7 — '
                    'Claim ${widget.store.todayRewardAmount} coins',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Claim arrow
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.accentGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: 200.ms, duration: 400.ms)
          .slideX(begin: 0.05, end: 0),
    );
  }

  void _showDailyReward(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyRewardWidget(
        store: widget.store,
        onClaimed: (coins) {
          setState(() {});
          widget.onBalanceChanged?.call();
        },
      ),
    );
  }

  // ── Tab Bar ──────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        indicatorSize: TabBarIndicatorSize.label,
        dividerHeight: 0,
        tabs: ShopCategory.values.map((cat) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  IconData(cat.iconCodePoint, fontFamily: 'MaterialIcons'),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(cat.displayName),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
  }

  // ── Item Grid ────────────────────────────────────────────────────────────

  Widget _buildItemGrid(ShopCategory category) {
    final items = widget.store.getItemsByCategory(category);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
              size: 48,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No items in this category yet',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category description
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              category.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // Items
          ...List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ShopItemCard(
                item: items[index],
                canAfford: items[index].coinCost <= widget.store.balance,
                index: index,
                onPurchase: () => _handlePurchase(items[index]),
              ),
            );
          }),

          // Earn more coins hint
          const SizedBox(height: 8),
          _buildEarnMoreHint(),
        ],
      ),
    );
  }

  Widget _buildEarnMoreHint() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 20,
            color: AppTheme.primaryBlue.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Earn coins by completing missions, maintaining streaks, and claiming daily rewards.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  // ── Purchase Handler ─────────────────────────────────────────────────────

  void _handlePurchase(ShopItem item) {
    HapticFeedback.mediumImpact();

    if (item.isPurchased) {
      _showSnackBar('You already own ${item.name}!', isError: false);
      return;
    }

    if (item.coinCost > widget.store.balance) {
      _showInsufficientCoinsDialog(item);
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => _PurchaseConfirmDialog(
        item: item,
        currentBalance: widget.store.balance,
        onConfirm: () {
          Navigator.of(context).pop();
          final result = widget.store.purchaseItem(item.id);
          if (result.success) {
            HapticFeedback.heavyImpact();
            _showPurchaseSuccess(result);
            setState(() {});
            widget.onBalanceChanged?.call();
          } else {
            _showSnackBar(result.message, isError: true);
          }
        },
      ),
    );
  }

  void _showPurchaseSuccess(PurchaseResult result) {
    showDialog(
      context: context,
      builder: (context) => _PurchaseSuccessDialog(result: result),
    );
  }

  void _showInsufficientCoinsDialog(ShopItem item) {
    final deficit = item.coinCost - widget.store.balance;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Not Enough Coins',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Coin icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monetization_on_rounded,
                size: 32,
                color: AppTheme.errorRed,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You need $deficit more coins to buy ${item.name}.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            // Earn-more suggestions
            _buildEarnSuggestion(
              icon: Icons.check_circle_outline,
              text: 'Complete daily missions',
              color: AppTheme.successGreen,
            ),
            const SizedBox(height: 8),
            _buildEarnSuggestion(
              icon: Icons.local_fire_department,
              text: 'Maintain your streak',
              color: AppTheme.accentOrange,
            ),
            const SizedBox(height: 8),
            _buildEarnSuggestion(
              icon: Icons.card_giftcard,
              text: 'Claim daily rewards',
              color: AppTheme.accentGold,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnSuggestion({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorRed : AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shop Item Card
// ---------------------------------------------------------------------------

class _ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool canAfford;
  final int index;
  final VoidCallback onPurchase;

  const _ShopItemCard({
    required this.item,
    required this.canAfford,
    required this.index,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final isOwned = item.isPurchased;

    return GestureDetector(
      onTap: onPurchase,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isOwned
              ? AppTheme.successGreen.withValues(alpha: 0.05)
              : context.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOwned
                ? AppTheme.successGreen.withValues(alpha: 0.3)
                : canAfford
                    ? AppTheme.accentGold.withValues(alpha: 0.3)
                    : const Color(0xFFE2D5C8),
            width: 1.5,
          ),
          boxShadow: canAfford && !isOwned
              ? [
                  BoxShadow(
                    color: AppTheme.accentGold.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Item icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isOwned
                    ? AppTheme.successGreen.withValues(alpha: 0.15)
                    : _getCategoryColor().withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
                size: 26,
                color: isOwned
                    ? AppTheme.successGreen
                    : _getCategoryColor(),
              ),
            ),
            const SizedBox(width: 14),

            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isLimited && !isOwned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'LIMITED',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentOrange,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Price / status
            isOwned
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppTheme.successGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Owned',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: canAfford ? AppTheme.gradientGold : null,
                      color: canAfford ? null : AppTheme.textMuted.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on_rounded,
                          size: 14,
                          color: canAfford ? Colors.white : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.coinCost}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: canAfford ? Colors.white : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 + (index * 80)),
          duration: 400.ms,
        )
        .slideX(
          begin: 0.05,
          end: 0,
          delay: Duration(milliseconds: 100 + (index * 80)),
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Color _getCategoryColor() {
    switch (item.category) {
      case ShopCategory.consumable:
        return AppTheme.primaryBlue;
      case ShopCategory.cosmetic:
        return AppTheme.primaryPurple;
      case ShopCategory.booster:
        return AppTheme.accentOrange;
      case ShopCategory.special:
        return AppTheme.accentGold;
    }
  }
}

// ---------------------------------------------------------------------------
// Purchase Confirmation Dialog
// ---------------------------------------------------------------------------

class _PurchaseConfirmDialog extends StatelessWidget {
  final ShopItem item;
  final int currentBalance;
  final VoidCallback onConfirm;

  const _PurchaseConfirmDialog({
    required this.item,
    required this.currentBalance,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Item icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
                size: 36,
                color: AppTheme.accentGold,
              ),
            ),
            const SizedBox(height: 16),

            // Item name
            Text(
              item.name,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              item.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Price vs balance
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriceRow('Price', item.coinCost),
                  _buildPriceRow('Balance', currentBalance),
                  _buildPriceRow(
                    'After',
                    currentBalance - item.coinCost,
                    isResult: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.monetization_on_rounded, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Buy for ${item.coinCost}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, int value, {bool isResult = false}) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isResult ? AppTheme.successGreen : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Purchase Success Dialog
// ---------------------------------------------------------------------------

class _PurchaseSuccessDialog extends StatefulWidget {
  final PurchaseResult result;

  const _PurchaseSuccessDialog({required this.result});

  @override
  State<_PurchaseSuccessDialog> createState() => _PurchaseSuccessDialogState();
}

class _PurchaseSuccessDialogState extends State<_PurchaseSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.result.item;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated checkmark
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 48,
                  color: AppTheme.successGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Purchase Complete!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You got ${item?.name ?? 'the item'}!',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '-${widget.result.coinsSpent} coins',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentGold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Awesome!',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
