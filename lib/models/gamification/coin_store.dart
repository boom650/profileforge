/// Coin Store & Shop System
///
/// Provides a full shop economy where earned coins can be spent on
/// consumables, cosmetics, boosters, and limited-time special items.

// ---------------------------------------------------------------------------
// Shop Category Enum
// ---------------------------------------------------------------------------

enum ShopCategory {
  consumable,
  cosmetic,
  booster,
  special,
}

extension ShopCategoryExtension on ShopCategory {
  String get displayName {
    switch (this) {
      case ShopCategory.consumable:
        return 'Consumables';
      case ShopCategory.cosmetic:
        return 'Cosmetics';
      case ShopCategory.booster:
        return 'Boosters';
      case ShopCategory.special:
        return 'Special';
    }
  }

  String get description {
    switch (this) {
      case ShopCategory.consumable:
        return 'Tokens & items that help you progress';
      case ShopCategory.cosmetic:
        return 'Customize your profile appearance';
      case ShopCategory.booster:
        return 'Temporary power-ups & boosts';
      case ShopCategory.special:
        return 'Limited-time seasonal & exclusive items';
    }
  }

  /// Material icon code point for the category tab.
  int get iconCodePoint {
    switch (this) {
      case ShopCategory.consumable:
        return 0xe559; // Icons.local_grocery_store
      case ShopCategory.cosmetic:
        return 0xe3b4; // Icons.palette
      case ShopCategory.booster:
        return 0xe86e; // Icons.speed
      case ShopCategory.special:
        return 0xe838; // Icons.stars
    }
  }
}

// ---------------------------------------------------------------------------
// Shop Item Model
// ---------------------------------------------------------------------------

class ShopItem {
  final String id;
  final String name;
  final String description;
  final ShopCategory category;
  final int coinCost;
  final int iconCodePoint;
  final bool isPurchased;
  final bool isLimited;
  final Duration? limitedTimeRemaining;
  final List<String> tags;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.coinCost,
    required this.iconCodePoint,
    this.isPurchased = false,
    this.isLimited = false,
    this.limitedTimeRemaining,
    this.tags = const [],
  });

  ShopItem copyWith({
    String? id,
    String? name,
    String? description,
    ShopCategory? category,
    int? coinCost,
    int? iconCodePoint,
    bool? isPurchased,
    bool? isLimited,
    Duration? limitedTimeRemaining,
    List<String>? tags,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      coinCost: coinCost ?? this.coinCost,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isPurchased: isPurchased ?? this.isPurchased,
      isLimited: isLimited ?? this.isLimited,
      limitedTimeRemaining: limitedTimeRemaining ?? this.limitedTimeRemaining,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category.name,
        'coinCost': coinCost,
        'iconCodePoint': iconCodePoint,
        'isPurchased': isPurchased,
        'isLimited': isLimited,
        'limitedTimeRemaining': limitedTimeRemaining?.inSeconds,
        'tags': tags,
      };

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: ShopCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ShopCategory.consumable,
      ),
      coinCost: json['coinCost'] as int,
      iconCodePoint: json['iconCodePoint'] as int,
      isPurchased: json['isPurchased'] as bool? ?? false,
      isLimited: json['isLimited'] as bool? ?? false,
      limitedTimeRemaining: json['limitedTimeRemaining'] != null
          ? Duration(seconds: json['limitedTimeRemaining'] as int)
          : null,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

// ---------------------------------------------------------------------------
// Daily Reward Configuration
// ---------------------------------------------------------------------------

class DailyRewardConfig {
  /// Coin rewards for each day of the 7-day login streak cycle.
  static const List<int> streakRewards = [50, 75, 100, 150, 200, 300, 500];

  /// Total coins earned over a full 7-day cycle.
  static int get totalCycleCoins =>
      streakRewards.fold(0, (sum, reward) => sum + reward);

  /// Get the reward for a specific day (1-indexed).
  static int rewardForDay(int day) {
    if (day < 1 || day > 7) return 0;
    return streakRewards[day - 1];
  }

  /// Get the streak multiplier text (shown as bonus info).
  static String multiplierText(int day) {
    if (day <= 1) return '';
    final base = streakRewards[0];
    final current = streakRewards[day - 1];
    final multiplier = current / base;
    return '${multiplier.toStringAsFixed(1)}x';
  }
}

// ---------------------------------------------------------------------------
// Daily Reward State
// ---------------------------------------------------------------------------

class DailyRewardState {
  final int currentStreakDay; // 1-7, resets after day 7
  final int totalDaysClaimed;
  final DateTime? lastClaimDate;
  final bool canClaimToday;
  final int totalCoinsEarnedFromRewards;

  const DailyRewardState({
    this.currentStreakDay = 1,
    this.totalDaysClaimed = 0,
    this.lastClaimDate,
    this.canClaimToday = true,
    this.totalCoinsEarnedFromRewards = 0,
  });

  DailyRewardState copyWith({
    int? currentStreakDay,
    int? totalDaysClaimed,
    DateTime? lastClaimDate,
    bool? canClaimToday,
    int? totalCoinsEarnedFromRewards,
  }) {
    return DailyRewardState(
      currentStreakDay: currentStreakDay ?? this.currentStreakDay,
      totalDaysClaimed: totalDaysClaimed ?? this.totalDaysClaimed,
      lastClaimDate: lastClaimDate ?? this.lastClaimDate,
      canClaimToday: canClaimToday ?? this.canClaimToday,
      totalCoinsEarnedFromRewards:
          totalCoinsEarnedFromRewards ?? this.totalCoinsEarnedFromRewards,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentStreakDay': currentStreakDay,
        'totalDaysClaimed': totalDaysClaimed,
        'lastClaimDate': lastClaimDate?.toIso8601String(),
        'canClaimToday': canClaimToday,
        'totalCoinsEarnedFromRewards': totalCoinsEarnedFromRewards,
      };

  factory DailyRewardState.fromJson(Map<String, dynamic> json) {
    return DailyRewardState(
      currentStreakDay: json['currentStreakDay'] as int? ?? 1,
      totalDaysClaimed: json['totalDaysClaimed'] as int? ?? 0,
      lastClaimDate: json['lastClaimDate'] != null
          ? DateTime.parse(json['lastClaimDate'] as String)
          : null,
      canClaimToday: json['canClaimToday'] as bool? ?? true,
      totalCoinsEarnedFromRewards:
          json['totalCoinsEarnedFromRewards'] as int? ?? 0,
    );
  }

  factory DailyRewardState.initial() => const DailyRewardState();
}

// ---------------------------------------------------------------------------
// Purchase Result
// ---------------------------------------------------------------------------

class PurchaseResult {
  final bool success;
  final String message;
  final ShopItem? item;
  final int coinsSpent;

  const PurchaseResult({
    required this.success,
    required this.message,
    this.item,
    this.coinsSpent = 0,
  });

  factory PurchaseResult.success(ShopItem item) {
    return PurchaseResult(
      success: true,
      message: 'Successfully purchased ${item.name}!',
      item: item,
      coinsSpent: item.coinCost,
    );
  }

  factory PurchaseResult.insufficientCoins(int needed, int available) {
    return PurchaseResult(
      success: false,
      message:
          'You need $needed coins but only have $available. Complete missions to earn more!',
    );
  }

  factory PurchaseResult.alreadyPurchased(ShopItem item) {
    return PurchaseResult(
      success: false,
      message: 'You already own ${item.name}!',
    );
  }
}

// ---------------------------------------------------------------------------
// CoinStore – the main store controller
// ---------------------------------------------------------------------------

class CoinStore {
  int _balance;
  final List<ShopItem> _items;
  DailyRewardState _dailyRewardState;
  final List<String> _purchaseHistory;

  CoinStore({
    int initialBalance = 0,
    List<ShopItem>? items,
    DailyRewardState? dailyRewardState,
    List<String>? purchaseHistory,
  })  : _balance = initialBalance,
        _items = items ?? ShopCatalog.allItems(),
        _dailyRewardState = dailyRewardState ?? DailyRewardState.initial(),
        _purchaseHistory = purchaseHistory ?? [];

  // ── Getters ──────────────────────────────────────────────────────────────

  int get balance => _balance;
  List<ShopItem> get items => List.unmodifiable(_items);
  DailyRewardState get dailyRewardState => _dailyRewardState;
  List<String> get purchaseHistory => List.unmodifiable(_purchaseHistory);

  // ── Catalog queries ──────────────────────────────────────────────────────

  /// All items in a given category.
  List<ShopItem> getItemsByCategory(ShopCategory category) {
    return _items.where((i) => i.category == category).toList();
  }

  /// Items the user can afford (not yet purchased).
  List<ShopItem> getAffordableItems() {
    return _items
        .where((i) => !i.isPurchased && i.coinCost <= _balance)
        .toList();
  }

  /// Items the user cannot yet afford.
  List<ShopItem> getUnaffordableItems() {
    return _items
        .where((i) => !i.isPurchased && i.coinCost > _balance)
        .toList();
  }

  /// Purchased items.
  List<ShopItem> getPurchasedItems() {
    return _items.where((i) => i.isPurchased).toList();
  }

  /// Limited-time items still available.
  List<ShopItem> getLimitedItems() {
    return _items
        .where((i) => i.isLimited && !i.isPurchased)
        .toList();
  }

  /// Find an item by ID.
  ShopItem? getItemById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  // ── Coin management ──────────────────────────────────────────────────────

  /// Add coins (from missions, daily rewards, etc.).
  void addCoins(int amount) {
    if (amount <= 0) return;
    _balance += amount;
  }

  /// Spend coins (returns true if successful).
  bool spendCoins(int amount) {
    if (amount <= 0 || amount > _balance) return false;
    _balance -= amount;
    return true;
  }

  // ── Purchase ─────────────────────────────────────────────────────────────

  /// Attempt to purchase an item. Returns the result with success/failure info.
  PurchaseResult purchaseItem(String itemId) {
    final itemIndex = _items.indexWhere((i) => i.id == itemId);
    if (itemIndex == -1) {
      return const PurchaseResult(
        success: false,
        message: 'Item not found in the shop.',
      );
    }

    final item = _items[itemIndex];

    if (item.isPurchased) {
      return PurchaseResult.alreadyPurchased(item);
    }

    if (item.coinCost > _balance) {
      return PurchaseResult.insufficientCoins(item.coinCost, _balance);
    }

    // Deduct coins and mark as purchased
    _balance -= item.coinCost;
    _items[itemIndex] = item.copyWith(isPurchased: true);
    _purchaseHistory.add(item.id);

    return PurchaseResult.success(item);
  }

  // ── Daily Rewards ────────────────────────────────────────────────────────

  /// Check if the user can claim today's daily reward.
  bool get canClaimDailyReward => _dailyRewardState.canClaimToday;

  /// Current daily reward streak day (1-7).
  int get currentStreakDay => _dailyRewardState.currentStreakDay;

  /// Today's reward amount if claimed.
  int get todayRewardAmount =>
      DailyRewardConfig.rewardForDay(_dailyRewardState.currentStreakDay);

  /// Claim the daily reward. Returns the coin amount earned.
  /// If the streak was broken (missed a day), the cycle resets.
  int claimDailyReward() {
    if (!_dailyRewardState.canClaimToday) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if the streak should reset (missed a day)
    if (_dailyRewardState.lastClaimDate != null) {
      final lastClaim = _dailyRewardState.lastClaimDate!;
      final lastClaimDay = DateTime(
          lastClaim.year, lastClaim.month, lastClaim.day);
      final daysDiff = today.difference(lastClaimDay).inDays;

      if (daysDiff > 1) {
        // Streak broken – reset to day 1
        _dailyRewardState = _dailyRewardState.copyWith(
          currentStreakDay: 1,
        );
      }
    }

    final rewardDay = _dailyRewardState.currentStreakDay;
    final coinsEarned = DailyRewardConfig.rewardForDay(rewardDay);

    // Add coins
    _balance += coinsEarned;

    // Advance the streak
    final nextDay = rewardDay >= 7 ? 1 : rewardDay + 1;

    _dailyRewardState = _dailyRewardState.copyWith(
      currentStreakDay: nextDay,
      totalDaysClaimed: _dailyRewardState.totalDaysClaimed + 1,
      lastClaimDate: now,
      canClaimToday: false,
      totalCoinsEarnedFromRewards:
          _dailyRewardState.totalCoinsEarnedFromRewards + coinsEarned,
    );

    return coinsEarned;
  }

  /// Reset the daily claim flag (call at midnight / app launch).
  void refreshDailyClaim() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_dailyRewardState.lastClaimDate != null) {
      final lastClaim = _dailyRewardState.lastClaimDate!;
      final lastClaimDay =
          DateTime(lastClaim.year, lastClaim.month, lastClaim.day);
      final daysDiff = today.difference(lastClaimDay).inDays;

      // If a new day has started, allow claiming
      if (daysDiff >= 1) {
        _dailyRewardState = _dailyRewardState.copyWith(
          canClaimToday: true,
        );
      }
    } else {
      // Never claimed before – allow it
      _dailyRewardState = _dailyRewardState.copyWith(
        canClaimToday: true,
      );
    }
  }

  // ── Serialization ────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'balance': _balance,
        'items': _items.map((i) => i.toJson()).toList(),
        'dailyRewardState': _dailyRewardState.toJson(),
        'purchaseHistory': _purchaseHistory,
      };

  factory CoinStore.fromJson(Map<String, dynamic> json) {
    return CoinStore(
      initialBalance: json['balance'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ShopItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          ShopCatalog.allItems(),
      dailyRewardState: json['dailyRewardState'] != null
          ? DailyRewardState.fromJson(
              json['dailyRewardState'] as Map<String, dynamic>)
          : null,
      purchaseHistory: (json['purchaseHistory'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

// ---------------------------------------------------------------------------
// Shop Catalog – all available items
// ---------------------------------------------------------------------------

class ShopCatalog {
  static List<ShopItem> allItems() => [
        // ── Consumables ────────────────────────────────────────────────────
        ...consumables,
        // ── Cosmetics ──────────────────────────────────────────────────────
        ...cosmetics,
        // ── Boosters ───────────────────────────────────────────────────────
        ...boosters,
        // ── Special ────────────────────────────────────────────────────────
        ...special,
      ];

  static const List<ShopItem> consumables = [
    ShopItem(
      id: 'freeze_token',
      name: 'Freeze Token',
      description:
          'Protect your streak for 1 day. Use it when life gets in the way — no guilt.',
      category: ShopCategory.consumable,
      coinCost: 500,
      iconCodePoint: 0xe53e, // Icons.ac_unit
      tags: ['streak', 'protection'],
    ),
    ShopItem(
      id: 'grace_day',
      name: 'Grace Day',
      description:
          'A free pass to miss one day without breaking your streak. Everyone needs a break.',
      category: ShopCategory.consumable,
      coinCost: 750,
      iconCodePoint: 0xe814, // Icons.favorite_border
      tags: ['streak', 'protection'],
    ),
    ShopItem(
      id: 'extra_mission_slot',
      name: 'Extra Mission Slot',
      description:
          'Unlock an additional active mission slot. Take on more challenges simultaneously.',
      category: ShopCategory.consumable,
      coinCost: 300,
      iconCodePoint: 0xe145, // Icons.add_circle_outline
      tags: ['missions', 'productivity'],
    ),
  ];

  static const List<ShopItem> cosmetics = [
    ShopItem(
      id: 'frame_classic_gold',
      name: 'Classic Gold Frame',
      description: 'A warm golden frame around your profile photo. Timeless.',
      category: ShopCategory.cosmetic,
      coinCost: 200,
      iconCodePoint: 0xe437, // Icons.crop_square
      tags: ['frame', 'gold'],
    ),
    ShopItem(
      id: 'frame_neon_glow',
      name: 'Neon Glow Frame',
      description: 'Electric neon border that pulses with your achievement energy.',
      category: ShopCategory.cosmetic,
      coinCost: 500,
      iconCodePoint: 0xe437,
      tags: ['frame', 'neon'],
    ),
    ShopItem(
      id: 'frame_diamond',
      name: 'Diamond Frame',
      description: 'Crystal-clear diamond frame. Reserved for the truly dedicated.',
      category: ShopCategory.cosmetic,
      coinCost: 1200,
      iconCodePoint: 0xe437,
      tags: ['frame', 'premium'],
    ),
    ShopItem(
      id: 'frame_legendary',
      name: 'Legendary Frame',
      description: 'The ultimate frame — shimmering with the power of a thousand missions.',
      category: ShopCategory.cosmetic,
      coinCost: 2000,
      iconCodePoint: 0xe437,
      tags: ['frame', 'legendary'],
    ),
    ShopItem(
      id: 'avatar_border_glow',
      name: 'Glowing Avatar Border',
      description: 'A soft glowing ring around your avatar. Subtle flex.',
      category: ShopCategory.cosmetic,
      coinCost: 300,
      iconCodePoint: 0xe3af, // Icons.brightness_1
      tags: ['avatar', 'glow'],
    ),
    ShopItem(
      id: 'streak_color_crimson',
      name: 'Crimson Streak Color',
      description: 'Change your streak flame to a deep crimson red.',
      category: ShopCategory.cosmetic,
      coinCost: 400,
      iconCodePoint: 0xe23b, // Icons.palette
      tags: ['streak', 'color'],
    ),
  ];

  static const List<ShopItem> boosters = [
    ShopItem(
      id: 'xp_boost_24h',
      name: '2x XP Boost (24h)',
      description:
          'Double all XP earned for 24 hours. Perfect for mission marathons.',
      category: ShopCategory.booster,
      coinCost: 1000,
      iconCodePoint: 0xe86e, // Icons.speed
      tags: ['xp', 'temporary'],
    ),
    ShopItem(
      id: 'mission_refresh',
      name: 'Mission Refresh',
      description:
          'Reroll all available missions and get a fresh set of challenges.',
      category: ShopCategory.booster,
      coinCost: 200,
      iconCodePoint: 0xe5d8, // Icons.refresh
      tags: ['missions', 'utility'],
    ),
    ShopItem(
      id: 'probability_boost_scan',
      name: 'Probability Boost Scan',
      description:
          'Get a deep analysis of your admission probability with actionable tips.',
      category: ShopCategory.booster,
      coinCost: 1500,
      iconCodePoint: 0xe00f, // Icons.analytics
      tags: ['admissions', 'analysis'],
    ),
  ];

  static const List<ShopItem> special = [
    ShopItem(
      id: 'seasonal_spring_skin',
      name: 'Spring Blossom Skin',
      description:
          'Limited-time profile skin with cherry blossom particles. Available this season only.',
      category: ShopCategory.special,
      coinCost: 800,
      iconCodePoint: 0xe90e, // Icons.local_florist
      isLimited: true,
      tags: ['seasonal', 'spring'],
    ),
    ShopItem(
      id: 'seasonal_monsoon_skin',
      name: 'Monsoon Splash Skin',
      description:
          'Limited-time profile skin with rain drop particles. Ride the monsoon wave.',
      category: ShopCategory.special,
      coinCost: 800,
      iconCodePoint: 0xe531, // Icons.water_drop
      isLimited: true,
      tags: ['seasonal', 'monsoon'],
    ),
    ShopItem(
      id: 'festival_skin_diwali',
      name: 'Diwali Sparkle Skin',
      description:
          'Exclusive Diwali profile skin with fireworks particles. Light up your profile!',
      category: ShopCategory.special,
      coinCost: 1000,
      iconCodePoint: 0xe893, // Icons.celebration
      isLimited: true,
      tags: ['seasonal', 'diwali', 'festival'],
    ),
  ];
}
