// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skins.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Skin _$SkinFromJson(Map<String, dynamic> json) {
  return _Skin.fromJson(json);
}

/// @nodoc
mixin _$Skin {
  String get id => throw _privateConstructorUsedError;
  @SkinTierConverter()
  SkinTier get tier => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get loreDescription => throw _privateConstructorUsedError;
  @SkinRarityConverter()
  SkinRarity get rarity => throw _privateConstructorUsedError;
  String get previewAssetPath => throw _privateConstructorUsedError;
  String get unlockedAssetPath => throw _privateConstructorUsedError;
  String get lockedAssetPath => throw _privateConstructorUsedError;
  String get iconAssetPath => throw _privateConstructorUsedError;
  String get particleEffectPath => throw _privateConstructorUsedError;
  String get backgroundAssetPath => throw _privateConstructorUsedError;
  int get xpRequired => throw _privateConstructorUsedError;
  int get tierOrder => throw _privateConstructorUsedError;
  Map<String, int> get pillarXPRequirements =>
      throw _privateConstructorUsedError;
  List<String> get unlockCriteria => throw _privateConstructorUsedError;
  Map<String, dynamic> get visualProperties =>
      throw _privateConstructorUsedError;
  DateTime? get unlockedAt => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;
  bool get isEquipped => throw _privateConstructorUsedError;
  DateTime? get equippedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SkinCopyWith<Skin> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkinCopyWith<$Res> {
  factory $SkinCopyWith(Skin value, $Res Function(Skin) then) =
      _$SkinCopyWithImpl<$Res, Skin>;
  @useResult
  $Res call(
      {String id,
      @SkinTierConverter() SkinTier tier,
      String name,
      String displayName,
      String description,
      String loreDescription,
      @SkinRarityConverter() SkinRarity rarity,
      String previewAssetPath,
      String unlockedAssetPath,
      String lockedAssetPath,
      String iconAssetPath,
      String particleEffectPath,
      String backgroundAssetPath,
      int xpRequired,
      int tierOrder,
      Map<String, int> pillarXPRequirements,
      List<String> unlockCriteria,
      Map<String, dynamic> visualProperties,
      DateTime? unlockedAt,
      bool isUnlocked,
      bool isEquipped,
      DateTime? equippedAt});
}

/// @nodoc
class _$SkinCopyWithImpl<$Res, $Val extends Skin>
    implements $SkinCopyWith<$Res> {
  _$SkinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tier = null,
    Object? name = null,
    Object? displayName = null,
    Object? description = null,
    Object? loreDescription = null,
    Object? rarity = null,
    Object? previewAssetPath = null,
    Object? unlockedAssetPath = null,
    Object? lockedAssetPath = null,
    Object? iconAssetPath = null,
    Object? particleEffectPath = null,
    Object? backgroundAssetPath = null,
    Object? xpRequired = null,
    Object? tierOrder = null,
    Object? pillarXPRequirements = null,
    Object? unlockCriteria = null,
    Object? visualProperties = null,
    Object? unlockedAt = freezed,
    Object? isUnlocked = null,
    Object? isEquipped = null,
    Object? equippedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      loreDescription: null == loreDescription
          ? _value.loreDescription
          : loreDescription // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as SkinRarity,
      previewAssetPath: null == previewAssetPath
          ? _value.previewAssetPath
          : previewAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAssetPath: null == unlockedAssetPath
          ? _value.unlockedAssetPath
          : unlockedAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      lockedAssetPath: null == lockedAssetPath
          ? _value.lockedAssetPath
          : lockedAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      iconAssetPath: null == iconAssetPath
          ? _value.iconAssetPath
          : iconAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      particleEffectPath: null == particleEffectPath
          ? _value.particleEffectPath
          : particleEffectPath // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundAssetPath: null == backgroundAssetPath
          ? _value.backgroundAssetPath
          : backgroundAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      xpRequired: null == xpRequired
          ? _value.xpRequired
          : xpRequired // ignore: cast_nullable_to_non_nullable
              as int,
      tierOrder: null == tierOrder
          ? _value.tierOrder
          : tierOrder // ignore: cast_nullable_to_non_nullable
              as int,
      pillarXPRequirements: null == pillarXPRequirements
          ? _value.pillarXPRequirements
          : pillarXPRequirements // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      unlockCriteria: null == unlockCriteria
          ? _value.unlockCriteria
          : unlockCriteria // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visualProperties: null == visualProperties
          ? _value.visualProperties
          : visualProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isEquipped: null == isEquipped
          ? _value.isEquipped
          : isEquipped // ignore: cast_nullable_to_non_nullable
              as bool,
      equippedAt: freezed == equippedAt
          ? _value.equippedAt
          : equippedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkinImplCopyWith<$Res> implements $SkinCopyWith<$Res> {
  factory _$$SkinImplCopyWith(
          _$SkinImpl value, $Res Function(_$SkinImpl) then) =
      __$$SkinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @SkinTierConverter() SkinTier tier,
      String name,
      String displayName,
      String description,
      String loreDescription,
      @SkinRarityConverter() SkinRarity rarity,
      String previewAssetPath,
      String unlockedAssetPath,
      String lockedAssetPath,
      String iconAssetPath,
      String particleEffectPath,
      String backgroundAssetPath,
      int xpRequired,
      int tierOrder,
      Map<String, int> pillarXPRequirements,
      List<String> unlockCriteria,
      Map<String, dynamic> visualProperties,
      DateTime? unlockedAt,
      bool isUnlocked,
      bool isEquipped,
      DateTime? equippedAt});
}

/// @nodoc
class __$$SkinImplCopyWithImpl<$Res>
    extends _$SkinCopyWithImpl<$Res, _$SkinImpl>
    implements _$$SkinImplCopyWith<$Res> {
  __$$SkinImplCopyWithImpl(_$SkinImpl _value, $Res Function(_$SkinImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tier = null,
    Object? name = null,
    Object? displayName = null,
    Object? description = null,
    Object? loreDescription = null,
    Object? rarity = null,
    Object? previewAssetPath = null,
    Object? unlockedAssetPath = null,
    Object? lockedAssetPath = null,
    Object? iconAssetPath = null,
    Object? particleEffectPath = null,
    Object? backgroundAssetPath = null,
    Object? xpRequired = null,
    Object? tierOrder = null,
    Object? pillarXPRequirements = null,
    Object? unlockCriteria = null,
    Object? visualProperties = null,
    Object? unlockedAt = freezed,
    Object? isUnlocked = null,
    Object? isEquipped = null,
    Object? equippedAt = freezed,
  }) {
    return _then(_$SkinImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      loreDescription: null == loreDescription
          ? _value.loreDescription
          : loreDescription // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as SkinRarity,
      previewAssetPath: null == previewAssetPath
          ? _value.previewAssetPath
          : previewAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAssetPath: null == unlockedAssetPath
          ? _value.unlockedAssetPath
          : unlockedAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      lockedAssetPath: null == lockedAssetPath
          ? _value.lockedAssetPath
          : lockedAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      iconAssetPath: null == iconAssetPath
          ? _value.iconAssetPath
          : iconAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      particleEffectPath: null == particleEffectPath
          ? _value.particleEffectPath
          : particleEffectPath // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundAssetPath: null == backgroundAssetPath
          ? _value.backgroundAssetPath
          : backgroundAssetPath // ignore: cast_nullable_to_non_nullable
              as String,
      xpRequired: null == xpRequired
          ? _value.xpRequired
          : xpRequired // ignore: cast_nullable_to_non_nullable
              as int,
      tierOrder: null == tierOrder
          ? _value.tierOrder
          : tierOrder // ignore: cast_nullable_to_non_nullable
              as int,
      pillarXPRequirements: null == pillarXPRequirements
          ? _value._pillarXPRequirements
          : pillarXPRequirements // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      unlockCriteria: null == unlockCriteria
          ? _value._unlockCriteria
          : unlockCriteria // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visualProperties: null == visualProperties
          ? _value._visualProperties
          : visualProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      isEquipped: null == isEquipped
          ? _value.isEquipped
          : isEquipped // ignore: cast_nullable_to_non_nullable
              as bool,
      equippedAt: freezed == equippedAt
          ? _value.equippedAt
          : equippedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkinImpl implements _Skin {
  const _$SkinImpl(
      {required this.id,
      @SkinTierConverter() required this.tier,
      required this.name,
      required this.displayName,
      required this.description,
      required this.loreDescription,
      @SkinRarityConverter() required this.rarity,
      required this.previewAssetPath,
      required this.unlockedAssetPath,
      required this.lockedAssetPath,
      required this.iconAssetPath,
      required this.particleEffectPath,
      required this.backgroundAssetPath,
      required this.xpRequired,
      required this.tierOrder,
      required final Map<String, int> pillarXPRequirements,
      required final List<String> unlockCriteria,
      required final Map<String, dynamic> visualProperties,
      required this.unlockedAt,
      required this.isUnlocked,
      required this.isEquipped,
      required this.equippedAt})
      : _pillarXPRequirements = pillarXPRequirements,
        _unlockCriteria = unlockCriteria,
        _visualProperties = visualProperties;

  factory _$SkinImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkinImplFromJson(json);

  @override
  final String id;
  @override
  @SkinTierConverter()
  final SkinTier tier;
  @override
  final String name;
  @override
  final String displayName;
  @override
  final String description;
  @override
  final String loreDescription;
  @override
  @SkinRarityConverter()
  final SkinRarity rarity;
  @override
  final String previewAssetPath;
  @override
  final String unlockedAssetPath;
  @override
  final String lockedAssetPath;
  @override
  final String iconAssetPath;
  @override
  final String particleEffectPath;
  @override
  final String backgroundAssetPath;
  @override
  final int xpRequired;
  @override
  final int tierOrder;
  final Map<String, int> _pillarXPRequirements;
  @override
  Map<String, int> get pillarXPRequirements {
    if (_pillarXPRequirements is EqualUnmodifiableMapView)
      return _pillarXPRequirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pillarXPRequirements);
  }

  final List<String> _unlockCriteria;
  @override
  List<String> get unlockCriteria {
    if (_unlockCriteria is EqualUnmodifiableListView) return _unlockCriteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockCriteria);
  }

  final Map<String, dynamic> _visualProperties;
  @override
  Map<String, dynamic> get visualProperties {
    if (_visualProperties is EqualUnmodifiableMapView) return _visualProperties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_visualProperties);
  }

  @override
  final DateTime? unlockedAt;
  @override
  final bool isUnlocked;
  @override
  final bool isEquipped;
  @override
  final DateTime? equippedAt;

  @override
  String toString() {
    return 'Skin(id: $id, tier: $tier, name: $name, displayName: $displayName, description: $description, loreDescription: $loreDescription, rarity: $rarity, previewAssetPath: $previewAssetPath, unlockedAssetPath: $unlockedAssetPath, lockedAssetPath: $lockedAssetPath, iconAssetPath: $iconAssetPath, particleEffectPath: $particleEffectPath, backgroundAssetPath: $backgroundAssetPath, xpRequired: $xpRequired, tierOrder: $tierOrder, pillarXPRequirements: $pillarXPRequirements, unlockCriteria: $unlockCriteria, visualProperties: $visualProperties, unlockedAt: $unlockedAt, isUnlocked: $isUnlocked, isEquipped: $isEquipped, equippedAt: $equippedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkinImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.loreDescription, loreDescription) ||
                other.loreDescription == loreDescription) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.previewAssetPath, previewAssetPath) ||
                other.previewAssetPath == previewAssetPath) &&
            (identical(other.unlockedAssetPath, unlockedAssetPath) ||
                other.unlockedAssetPath == unlockedAssetPath) &&
            (identical(other.lockedAssetPath, lockedAssetPath) ||
                other.lockedAssetPath == lockedAssetPath) &&
            (identical(other.iconAssetPath, iconAssetPath) ||
                other.iconAssetPath == iconAssetPath) &&
            (identical(other.particleEffectPath, particleEffectPath) ||
                other.particleEffectPath == particleEffectPath) &&
            (identical(other.backgroundAssetPath, backgroundAssetPath) ||
                other.backgroundAssetPath == backgroundAssetPath) &&
            (identical(other.xpRequired, xpRequired) ||
                other.xpRequired == xpRequired) &&
            (identical(other.tierOrder, tierOrder) ||
                other.tierOrder == tierOrder) &&
            const DeepCollectionEquality()
                .equals(other._pillarXPRequirements, _pillarXPRequirements) &&
            const DeepCollectionEquality()
                .equals(other._unlockCriteria, _unlockCriteria) &&
            const DeepCollectionEquality()
                .equals(other._visualProperties, _visualProperties) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.isEquipped, isEquipped) ||
                other.isEquipped == isEquipped) &&
            (identical(other.equippedAt, equippedAt) ||
                other.equippedAt == equippedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        tier,
        name,
        displayName,
        description,
        loreDescription,
        rarity,
        previewAssetPath,
        unlockedAssetPath,
        lockedAssetPath,
        iconAssetPath,
        particleEffectPath,
        backgroundAssetPath,
        xpRequired,
        tierOrder,
        const DeepCollectionEquality().hash(_pillarXPRequirements),
        const DeepCollectionEquality().hash(_unlockCriteria),
        const DeepCollectionEquality().hash(_visualProperties),
        unlockedAt,
        isUnlocked,
        isEquipped,
        equippedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkinImplCopyWith<_$SkinImpl> get copyWith =>
      __$$SkinImplCopyWithImpl<_$SkinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkinImplToJson(
      this,
    );
  }
}

abstract class _Skin implements Skin {
  const factory _Skin(
      {required final String id,
      @SkinTierConverter() required final SkinTier tier,
      required final String name,
      required final String displayName,
      required final String description,
      required final String loreDescription,
      @SkinRarityConverter() required final SkinRarity rarity,
      required final String previewAssetPath,
      required final String unlockedAssetPath,
      required final String lockedAssetPath,
      required final String iconAssetPath,
      required final String particleEffectPath,
      required final String backgroundAssetPath,
      required final int xpRequired,
      required final int tierOrder,
      required final Map<String, int> pillarXPRequirements,
      required final List<String> unlockCriteria,
      required final Map<String, dynamic> visualProperties,
      required final DateTime? unlockedAt,
      required final bool isUnlocked,
      required final bool isEquipped,
      required final DateTime? equippedAt}) = _$SkinImpl;

  factory _Skin.fromJson(Map<String, dynamic> json) = _$SkinImpl.fromJson;

  @override
  String get id;
  @override
  @SkinTierConverter()
  SkinTier get tier;
  @override
  String get name;
  @override
  String get displayName;
  @override
  String get description;
  @override
  String get loreDescription;
  @override
  @SkinRarityConverter()
  SkinRarity get rarity;
  @override
  String get previewAssetPath;
  @override
  String get unlockedAssetPath;
  @override
  String get lockedAssetPath;
  @override
  String get iconAssetPath;
  @override
  String get particleEffectPath;
  @override
  String get backgroundAssetPath;
  @override
  int get xpRequired;
  @override
  int get tierOrder;
  @override
  Map<String, int> get pillarXPRequirements;
  @override
  List<String> get unlockCriteria;
  @override
  Map<String, dynamic> get visualProperties;
  @override
  DateTime? get unlockedAt;
  @override
  bool get isUnlocked;
  @override
  bool get isEquipped;
  @override
  DateTime? get equippedAt;
  @override
  @JsonKey(ignore: true)
  _$$SkinImplCopyWith<_$SkinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PillarXPRequirements _$PillarXPRequirementsFromJson(Map<String, dynamic> json) {
  return _PillarXPRequirements.fromJson(json);
}

/// @nodoc
mixin _$PillarXPRequirements {
  int get academicsXP => throw _privateConstructorUsedError;
  int get evidenceXP => throw _privateConstructorUsedError;
  int get consistencyXP => throw _privateConstructorUsedError;
  int get researchXP => throw _privateConstructorUsedError;
  int get leadershipXP => throw _privateConstructorUsedError;
  int get creativityXP => throw _privateConstructorUsedError;
  int get communityImpactXP => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillarXPRequirementsCopyWith<PillarXPRequirements> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillarXPRequirementsCopyWith<$Res> {
  factory $PillarXPRequirementsCopyWith(PillarXPRequirements value,
          $Res Function(PillarXPRequirements) then) =
      _$PillarXPRequirementsCopyWithImpl<$Res, PillarXPRequirements>;
  @useResult
  $Res call(
      {int academicsXP,
      int evidenceXP,
      int consistencyXP,
      int researchXP,
      int leadershipXP,
      int creativityXP,
      int communityImpactXP});
}

/// @nodoc
class _$PillarXPRequirementsCopyWithImpl<$Res,
        $Val extends PillarXPRequirements>
    implements $PillarXPRequirementsCopyWith<$Res> {
  _$PillarXPRequirementsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? academicsXP = null,
    Object? evidenceXP = null,
    Object? consistencyXP = null,
    Object? researchXP = null,
    Object? leadershipXP = null,
    Object? creativityXP = null,
    Object? communityImpactXP = null,
  }) {
    return _then(_value.copyWith(
      academicsXP: null == academicsXP
          ? _value.academicsXP
          : academicsXP // ignore: cast_nullable_to_non_nullable
              as int,
      evidenceXP: null == evidenceXP
          ? _value.evidenceXP
          : evidenceXP // ignore: cast_nullable_to_non_nullable
              as int,
      consistencyXP: null == consistencyXP
          ? _value.consistencyXP
          : consistencyXP // ignore: cast_nullable_to_non_nullable
              as int,
      researchXP: null == researchXP
          ? _value.researchXP
          : researchXP // ignore: cast_nullable_to_non_nullable
              as int,
      leadershipXP: null == leadershipXP
          ? _value.leadershipXP
          : leadershipXP // ignore: cast_nullable_to_non_nullable
              as int,
      creativityXP: null == creativityXP
          ? _value.creativityXP
          : creativityXP // ignore: cast_nullable_to_non_nullable
              as int,
      communityImpactXP: null == communityImpactXP
          ? _value.communityImpactXP
          : communityImpactXP // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PillarXPRequirementsImplCopyWith<$Res>
    implements $PillarXPRequirementsCopyWith<$Res> {
  factory _$$PillarXPRequirementsImplCopyWith(_$PillarXPRequirementsImpl value,
          $Res Function(_$PillarXPRequirementsImpl) then) =
      __$$PillarXPRequirementsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int academicsXP,
      int evidenceXP,
      int consistencyXP,
      int researchXP,
      int leadershipXP,
      int creativityXP,
      int communityImpactXP});
}

/// @nodoc
class __$$PillarXPRequirementsImplCopyWithImpl<$Res>
    extends _$PillarXPRequirementsCopyWithImpl<$Res, _$PillarXPRequirementsImpl>
    implements _$$PillarXPRequirementsImplCopyWith<$Res> {
  __$$PillarXPRequirementsImplCopyWithImpl(_$PillarXPRequirementsImpl _value,
      $Res Function(_$PillarXPRequirementsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? academicsXP = null,
    Object? evidenceXP = null,
    Object? consistencyXP = null,
    Object? researchXP = null,
    Object? leadershipXP = null,
    Object? creativityXP = null,
    Object? communityImpactXP = null,
  }) {
    return _then(_$PillarXPRequirementsImpl(
      academicsXP: null == academicsXP
          ? _value.academicsXP
          : academicsXP // ignore: cast_nullable_to_non_nullable
              as int,
      evidenceXP: null == evidenceXP
          ? _value.evidenceXP
          : evidenceXP // ignore: cast_nullable_to_non_nullable
              as int,
      consistencyXP: null == consistencyXP
          ? _value.consistencyXP
          : consistencyXP // ignore: cast_nullable_to_non_nullable
              as int,
      researchXP: null == researchXP
          ? _value.researchXP
          : researchXP // ignore: cast_nullable_to_non_nullable
              as int,
      leadershipXP: null == leadershipXP
          ? _value.leadershipXP
          : leadershipXP // ignore: cast_nullable_to_non_nullable
              as int,
      creativityXP: null == creativityXP
          ? _value.creativityXP
          : creativityXP // ignore: cast_nullable_to_non_nullable
              as int,
      communityImpactXP: null == communityImpactXP
          ? _value.communityImpactXP
          : communityImpactXP // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PillarXPRequirementsImpl implements _PillarXPRequirements {
  const _$PillarXPRequirementsImpl(
      {required this.academicsXP,
      required this.evidenceXP,
      required this.consistencyXP,
      required this.researchXP,
      required this.leadershipXP,
      required this.creativityXP,
      required this.communityImpactXP});

  factory _$PillarXPRequirementsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PillarXPRequirementsImplFromJson(json);

  @override
  final int academicsXP;
  @override
  final int evidenceXP;
  @override
  final int consistencyXP;
  @override
  final int researchXP;
  @override
  final int leadershipXP;
  @override
  final int creativityXP;
  @override
  final int communityImpactXP;

  @override
  String toString() {
    return 'PillarXPRequirements(academicsXP: $academicsXP, evidenceXP: $evidenceXP, consistencyXP: $consistencyXP, researchXP: $researchXP, leadershipXP: $leadershipXP, creativityXP: $creativityXP, communityImpactXP: $communityImpactXP)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillarXPRequirementsImpl &&
            (identical(other.academicsXP, academicsXP) ||
                other.academicsXP == academicsXP) &&
            (identical(other.evidenceXP, evidenceXP) ||
                other.evidenceXP == evidenceXP) &&
            (identical(other.consistencyXP, consistencyXP) ||
                other.consistencyXP == consistencyXP) &&
            (identical(other.researchXP, researchXP) ||
                other.researchXP == researchXP) &&
            (identical(other.leadershipXP, leadershipXP) ||
                other.leadershipXP == leadershipXP) &&
            (identical(other.creativityXP, creativityXP) ||
                other.creativityXP == creativityXP) &&
            (identical(other.communityImpactXP, communityImpactXP) ||
                other.communityImpactXP == communityImpactXP));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, academicsXP, evidenceXP,
      consistencyXP, researchXP, leadershipXP, creativityXP, communityImpactXP);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillarXPRequirementsImplCopyWith<_$PillarXPRequirementsImpl>
      get copyWith =>
          __$$PillarXPRequirementsImplCopyWithImpl<_$PillarXPRequirementsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PillarXPRequirementsImplToJson(
      this,
    );
  }
}

abstract class _PillarXPRequirements implements PillarXPRequirements {
  const factory _PillarXPRequirements(
      {required final int academicsXP,
      required final int evidenceXP,
      required final int consistencyXP,
      required final int researchXP,
      required final int leadershipXP,
      required final int creativityXP,
      required final int communityImpactXP}) = _$PillarXPRequirementsImpl;

  factory _PillarXPRequirements.fromJson(Map<String, dynamic> json) =
      _$PillarXPRequirementsImpl.fromJson;

  @override
  int get academicsXP;
  @override
  int get evidenceXP;
  @override
  int get consistencyXP;
  @override
  int get researchXP;
  @override
  int get leadershipXP;
  @override
  int get creativityXP;
  @override
  int get communityImpactXP;
  @override
  @JsonKey(ignore: true)
  _$$PillarXPRequirementsImplCopyWith<_$PillarXPRequirementsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SkinConfig _$SkinConfigFromJson(Map<String, dynamic> json) {
  return _SkinConfig.fromJson(json);
}

/// @nodoc
mixin _$SkinConfig {
  SkinTier get tier => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get loreDescription => throw _privateConstructorUsedError;
  SkinRarity get rarity => throw _privateConstructorUsedError;
  int get xpRequired => throw _privateConstructorUsedError;
  int get tierOrder => throw _privateConstructorUsedError;
  PillarXPRequirements get pillarXPRequirements =>
      throw _privateConstructorUsedError;
  List<String> get unlockCriteria => throw _privateConstructorUsedError;
  Map<String, dynamic> get visualProperties =>
      throw _privateConstructorUsedError;
  String get previewAsset => throw _privateConstructorUsedError;
  String get unlockedAsset => throw _privateConstructorUsedError;
  String get lockedAsset => throw _privateConstructorUsedError;
  String get iconAsset => throw _privateConstructorUsedError;
  String get particleEffect => throw _privateConstructorUsedError;
  String get backgroundAsset => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SkinConfigCopyWith<SkinConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkinConfigCopyWith<$Res> {
  factory $SkinConfigCopyWith(
          SkinConfig value, $Res Function(SkinConfig) then) =
      _$SkinConfigCopyWithImpl<$Res, SkinConfig>;
  @useResult
  $Res call(
      {SkinTier tier,
      String name,
      String displayName,
      String description,
      String loreDescription,
      SkinRarity rarity,
      int xpRequired,
      int tierOrder,
      PillarXPRequirements pillarXPRequirements,
      List<String> unlockCriteria,
      Map<String, dynamic> visualProperties,
      String previewAsset,
      String unlockedAsset,
      String lockedAsset,
      String iconAsset,
      String particleEffect,
      String backgroundAsset});

  $PillarXPRequirementsCopyWith<$Res> get pillarXPRequirements;
}

/// @nodoc
class _$SkinConfigCopyWithImpl<$Res, $Val extends SkinConfig>
    implements $SkinConfigCopyWith<$Res> {
  _$SkinConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? name = null,
    Object? displayName = null,
    Object? description = null,
    Object? loreDescription = null,
    Object? rarity = null,
    Object? xpRequired = null,
    Object? tierOrder = null,
    Object? pillarXPRequirements = null,
    Object? unlockCriteria = null,
    Object? visualProperties = null,
    Object? previewAsset = null,
    Object? unlockedAsset = null,
    Object? lockedAsset = null,
    Object? iconAsset = null,
    Object? particleEffect = null,
    Object? backgroundAsset = null,
  }) {
    return _then(_value.copyWith(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      loreDescription: null == loreDescription
          ? _value.loreDescription
          : loreDescription // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as SkinRarity,
      xpRequired: null == xpRequired
          ? _value.xpRequired
          : xpRequired // ignore: cast_nullable_to_non_nullable
              as int,
      tierOrder: null == tierOrder
          ? _value.tierOrder
          : tierOrder // ignore: cast_nullable_to_non_nullable
              as int,
      pillarXPRequirements: null == pillarXPRequirements
          ? _value.pillarXPRequirements
          : pillarXPRequirements // ignore: cast_nullable_to_non_nullable
              as PillarXPRequirements,
      unlockCriteria: null == unlockCriteria
          ? _value.unlockCriteria
          : unlockCriteria // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visualProperties: null == visualProperties
          ? _value.visualProperties
          : visualProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      previewAsset: null == previewAsset
          ? _value.previewAsset
          : previewAsset // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAsset: null == unlockedAsset
          ? _value.unlockedAsset
          : unlockedAsset // ignore: cast_nullable_to_non_nullable
              as String,
      lockedAsset: null == lockedAsset
          ? _value.lockedAsset
          : lockedAsset // ignore: cast_nullable_to_non_nullable
              as String,
      iconAsset: null == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String,
      particleEffect: null == particleEffect
          ? _value.particleEffect
          : particleEffect // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundAsset: null == backgroundAsset
          ? _value.backgroundAsset
          : backgroundAsset // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PillarXPRequirementsCopyWith<$Res> get pillarXPRequirements {
    return $PillarXPRequirementsCopyWith<$Res>(_value.pillarXPRequirements,
        (value) {
      return _then(_value.copyWith(pillarXPRequirements: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SkinConfigImplCopyWith<$Res>
    implements $SkinConfigCopyWith<$Res> {
  factory _$$SkinConfigImplCopyWith(
          _$SkinConfigImpl value, $Res Function(_$SkinConfigImpl) then) =
      __$$SkinConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SkinTier tier,
      String name,
      String displayName,
      String description,
      String loreDescription,
      SkinRarity rarity,
      int xpRequired,
      int tierOrder,
      PillarXPRequirements pillarXPRequirements,
      List<String> unlockCriteria,
      Map<String, dynamic> visualProperties,
      String previewAsset,
      String unlockedAsset,
      String lockedAsset,
      String iconAsset,
      String particleEffect,
      String backgroundAsset});

  @override
  $PillarXPRequirementsCopyWith<$Res> get pillarXPRequirements;
}

/// @nodoc
class __$$SkinConfigImplCopyWithImpl<$Res>
    extends _$SkinConfigCopyWithImpl<$Res, _$SkinConfigImpl>
    implements _$$SkinConfigImplCopyWith<$Res> {
  __$$SkinConfigImplCopyWithImpl(
      _$SkinConfigImpl _value, $Res Function(_$SkinConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? name = null,
    Object? displayName = null,
    Object? description = null,
    Object? loreDescription = null,
    Object? rarity = null,
    Object? xpRequired = null,
    Object? tierOrder = null,
    Object? pillarXPRequirements = null,
    Object? unlockCriteria = null,
    Object? visualProperties = null,
    Object? previewAsset = null,
    Object? unlockedAsset = null,
    Object? lockedAsset = null,
    Object? iconAsset = null,
    Object? particleEffect = null,
    Object? backgroundAsset = null,
  }) {
    return _then(_$SkinConfigImpl(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      loreDescription: null == loreDescription
          ? _value.loreDescription
          : loreDescription // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as SkinRarity,
      xpRequired: null == xpRequired
          ? _value.xpRequired
          : xpRequired // ignore: cast_nullable_to_non_nullable
              as int,
      tierOrder: null == tierOrder
          ? _value.tierOrder
          : tierOrder // ignore: cast_nullable_to_non_nullable
              as int,
      pillarXPRequirements: null == pillarXPRequirements
          ? _value.pillarXPRequirements
          : pillarXPRequirements // ignore: cast_nullable_to_non_nullable
              as PillarXPRequirements,
      unlockCriteria: null == unlockCriteria
          ? _value._unlockCriteria
          : unlockCriteria // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visualProperties: null == visualProperties
          ? _value._visualProperties
          : visualProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      previewAsset: null == previewAsset
          ? _value.previewAsset
          : previewAsset // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAsset: null == unlockedAsset
          ? _value.unlockedAsset
          : unlockedAsset // ignore: cast_nullable_to_non_nullable
              as String,
      lockedAsset: null == lockedAsset
          ? _value.lockedAsset
          : lockedAsset // ignore: cast_nullable_to_non_nullable
              as String,
      iconAsset: null == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String,
      particleEffect: null == particleEffect
          ? _value.particleEffect
          : particleEffect // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundAsset: null == backgroundAsset
          ? _value.backgroundAsset
          : backgroundAsset // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkinConfigImpl implements _SkinConfig {
  const _$SkinConfigImpl(
      {required this.tier,
      required this.name,
      required this.displayName,
      required this.description,
      required this.loreDescription,
      required this.rarity,
      required this.xpRequired,
      required this.tierOrder,
      required this.pillarXPRequirements,
      required final List<String> unlockCriteria,
      required final Map<String, dynamic> visualProperties,
      required this.previewAsset,
      required this.unlockedAsset,
      required this.lockedAsset,
      required this.iconAsset,
      required this.particleEffect,
      required this.backgroundAsset})
      : _unlockCriteria = unlockCriteria,
        _visualProperties = visualProperties;

  factory _$SkinConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkinConfigImplFromJson(json);

  @override
  final SkinTier tier;
  @override
  final String name;
  @override
  final String displayName;
  @override
  final String description;
  @override
  final String loreDescription;
  @override
  final SkinRarity rarity;
  @override
  final int xpRequired;
  @override
  final int tierOrder;
  @override
  final PillarXPRequirements pillarXPRequirements;
  final List<String> _unlockCriteria;
  @override
  List<String> get unlockCriteria {
    if (_unlockCriteria is EqualUnmodifiableListView) return _unlockCriteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockCriteria);
  }

  final Map<String, dynamic> _visualProperties;
  @override
  Map<String, dynamic> get visualProperties {
    if (_visualProperties is EqualUnmodifiableMapView) return _visualProperties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_visualProperties);
  }

  @override
  final String previewAsset;
  @override
  final String unlockedAsset;
  @override
  final String lockedAsset;
  @override
  final String iconAsset;
  @override
  final String particleEffect;
  @override
  final String backgroundAsset;

  @override
  String toString() {
    return 'SkinConfig(tier: $tier, name: $name, displayName: $displayName, description: $description, loreDescription: $loreDescription, rarity: $rarity, xpRequired: $xpRequired, tierOrder: $tierOrder, pillarXPRequirements: $pillarXPRequirements, unlockCriteria: $unlockCriteria, visualProperties: $visualProperties, previewAsset: $previewAsset, unlockedAsset: $unlockedAsset, lockedAsset: $lockedAsset, iconAsset: $iconAsset, particleEffect: $particleEffect, backgroundAsset: $backgroundAsset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkinConfigImpl &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.loreDescription, loreDescription) ||
                other.loreDescription == loreDescription) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.xpRequired, xpRequired) ||
                other.xpRequired == xpRequired) &&
            (identical(other.tierOrder, tierOrder) ||
                other.tierOrder == tierOrder) &&
            (identical(other.pillarXPRequirements, pillarXPRequirements) ||
                other.pillarXPRequirements == pillarXPRequirements) &&
            const DeepCollectionEquality()
                .equals(other._unlockCriteria, _unlockCriteria) &&
            const DeepCollectionEquality()
                .equals(other._visualProperties, _visualProperties) &&
            (identical(other.previewAsset, previewAsset) ||
                other.previewAsset == previewAsset) &&
            (identical(other.unlockedAsset, unlockedAsset) ||
                other.unlockedAsset == unlockedAsset) &&
            (identical(other.lockedAsset, lockedAsset) ||
                other.lockedAsset == lockedAsset) &&
            (identical(other.iconAsset, iconAsset) ||
                other.iconAsset == iconAsset) &&
            (identical(other.particleEffect, particleEffect) ||
                other.particleEffect == particleEffect) &&
            (identical(other.backgroundAsset, backgroundAsset) ||
                other.backgroundAsset == backgroundAsset));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tier,
      name,
      displayName,
      description,
      loreDescription,
      rarity,
      xpRequired,
      tierOrder,
      pillarXPRequirements,
      const DeepCollectionEquality().hash(_unlockCriteria),
      const DeepCollectionEquality().hash(_visualProperties),
      previewAsset,
      unlockedAsset,
      lockedAsset,
      iconAsset,
      particleEffect,
      backgroundAsset);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkinConfigImplCopyWith<_$SkinConfigImpl> get copyWith =>
      __$$SkinConfigImplCopyWithImpl<_$SkinConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkinConfigImplToJson(
      this,
    );
  }
}

abstract class _SkinConfig implements SkinConfig {
  const factory _SkinConfig(
      {required final SkinTier tier,
      required final String name,
      required final String displayName,
      required final String description,
      required final String loreDescription,
      required final SkinRarity rarity,
      required final int xpRequired,
      required final int tierOrder,
      required final PillarXPRequirements pillarXPRequirements,
      required final List<String> unlockCriteria,
      required final Map<String, dynamic> visualProperties,
      required final String previewAsset,
      required final String unlockedAsset,
      required final String lockedAsset,
      required final String iconAsset,
      required final String particleEffect,
      required final String backgroundAsset}) = _$SkinConfigImpl;

  factory _SkinConfig.fromJson(Map<String, dynamic> json) =
      _$SkinConfigImpl.fromJson;

  @override
  SkinTier get tier;
  @override
  String get name;
  @override
  String get displayName;
  @override
  String get description;
  @override
  String get loreDescription;
  @override
  SkinRarity get rarity;
  @override
  int get xpRequired;
  @override
  int get tierOrder;
  @override
  PillarXPRequirements get pillarXPRequirements;
  @override
  List<String> get unlockCriteria;
  @override
  Map<String, dynamic> get visualProperties;
  @override
  String get previewAsset;
  @override
  String get unlockedAsset;
  @override
  String get lockedAsset;
  @override
  String get iconAsset;
  @override
  String get particleEffect;
  @override
  String get backgroundAsset;
  @override
  @JsonKey(ignore: true)
  _$$SkinConfigImplCopyWith<_$SkinConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SkinCollection {
  Map<SkinTier, Skin> get ownedSkins => throw _privateConstructorUsedError;
  SkinTier? get equippedSkin => throw _privateConstructorUsedError;
  Map<SkinTier, DateTime> get unlockDates => throw _privateConstructorUsedError;
  Map<SkinTier, int> get unlockOrder => throw _privateConstructorUsedError;
  List<UnlockCelebration> get celebrationHistory =>
      throw _privateConstructorUsedError;
  Map<SkinSynergy, bool> get activeSynergies =>
      throw _privateConstructorUsedError;
  SkinTier? get featuredSkin => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SkinCollectionCopyWith<SkinCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkinCollectionCopyWith<$Res> {
  factory $SkinCollectionCopyWith(
          SkinCollection value, $Res Function(SkinCollection) then) =
      _$SkinCollectionCopyWithImpl<$Res, SkinCollection>;
  @useResult
  $Res call(
      {Map<SkinTier, Skin> ownedSkins,
      SkinTier? equippedSkin,
      Map<SkinTier, DateTime> unlockDates,
      Map<SkinTier, int> unlockOrder,
      List<UnlockCelebration> celebrationHistory,
      Map<SkinSynergy, bool> activeSynergies,
      SkinTier? featuredSkin});
}

/// @nodoc
class _$SkinCollectionCopyWithImpl<$Res, $Val extends SkinCollection>
    implements $SkinCollectionCopyWith<$Res> {
  _$SkinCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownedSkins = null,
    Object? equippedSkin = freezed,
    Object? unlockDates = null,
    Object? unlockOrder = null,
    Object? celebrationHistory = null,
    Object? activeSynergies = null,
    Object? featuredSkin = freezed,
  }) {
    return _then(_value.copyWith(
      ownedSkins: null == ownedSkins
          ? _value.ownedSkins
          : ownedSkins // ignore: cast_nullable_to_non_nullable
              as Map<SkinTier, Skin>,
      equippedSkin: freezed == equippedSkin
          ? _value.equippedSkin
          : equippedSkin // ignore: cast_nullable_to_non_nullable
              as SkinTier?,
      unlockDates: null == unlockDates
          ? _value.unlockDates
          : unlockDates // ignore: cast_nullable_to_non_nullable
              as Map<SkinTier, DateTime>,
      unlockOrder: null == unlockOrder
          ? _value.unlockOrder
          : unlockOrder // ignore: cast_nullable_to_non_nullable
              as Map<SkinTier, int>,
      celebrationHistory: null == celebrationHistory
          ? _value.celebrationHistory
          : celebrationHistory // ignore: cast_nullable_to_non_nullable
              as List<UnlockCelebration>,
      activeSynergies: null == activeSynergies
          ? _value.activeSynergies
          : activeSynergies // ignore: cast_nullable_to_non_nullable
              as Map<SkinSynergy, bool>,
      featuredSkin: freezed == featuredSkin
          ? _value.featuredSkin
          : featuredSkin // ignore: cast_nullable_to_non_nullable
              as SkinTier?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkinCollectionImplCopyWith<$Res>
    implements $SkinCollectionCopyWith<$Res> {
  factory _$$SkinCollectionImplCopyWith(_$SkinCollectionImpl value,
          $Res Function(_$SkinCollectionImpl) then) =
      __$$SkinCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<SkinTier, Skin> ownedSkins,
      SkinTier? equippedSkin,
      Map<SkinTier, DateTime> unlockDates,
      Map<SkinTier, int> unlockOrder,
      List<UnlockCelebration> celebrationHistory,
      Map<SkinSynergy, bool> activeSynergies,
      SkinTier? featuredSkin});
}

/// @nodoc
class __$$SkinCollectionImplCopyWithImpl<$Res>
    extends _$SkinCollectionCopyWithImpl<$Res, _$SkinCollectionImpl>
    implements _$$SkinCollectionImplCopyWith<$Res> {
  __$$SkinCollectionImplCopyWithImpl(
      _$SkinCollectionImpl _value, $Res Function(_$SkinCollectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownedSkins = null,
    Object? equippedSkin = freezed,
    Object? unlockDates = null,
    Object? unlockOrder = null,
    Object? celebrationHistory = null,
    Object? activeSynergies = null,
    Object? featuredSkin = freezed,
  }) {
    return _then(_$SkinCollectionImpl(
      ownedSkins: null == ownedSkins
          ? _value._ownedSkins
          : ownedSkins // ignore: cast_nullable_to_non_nullable
              as Map<SkinTier, Skin>,
      equippedSkin: freezed == equippedSkin
          ? _value.equippedSkin
          : equippedSkin // ignore: cast_nullable_to_non_nullable
              as SkinTier?,
      unlockDates: null == unlockDates
          ? _value._unlockDates
          : unlockDates // ignore: cast_nullable_to_non_nullable
              as Map<SkinTier, DateTime>,
      unlockOrder: null == unlockOrder
          ? _value._unlockOrder
          : unlockOrder // ignore: cast_nullable_to_non_nullable
              as Map<SkinTier, int>,
      celebrationHistory: null == celebrationHistory
          ? _value._celebrationHistory
          : celebrationHistory // ignore: cast_nullable_to_non_nullable
              as List<UnlockCelebration>,
      activeSynergies: null == activeSynergies
          ? _value._activeSynergies
          : activeSynergies // ignore: cast_nullable_to_non_nullable
              as Map<SkinSynergy, bool>,
      featuredSkin: freezed == featuredSkin
          ? _value.featuredSkin
          : featuredSkin // ignore: cast_nullable_to_non_nullable
              as SkinTier?,
    ));
  }
}

/// @nodoc

class _$SkinCollectionImpl implements _SkinCollection {
  const _$SkinCollectionImpl(
      {required final Map<SkinTier, Skin> ownedSkins,
      required this.equippedSkin,
      required final Map<SkinTier, DateTime> unlockDates,
      required final Map<SkinTier, int> unlockOrder,
      required final List<UnlockCelebration> celebrationHistory,
      required final Map<SkinSynergy, bool> activeSynergies,
      required this.featuredSkin})
      : _ownedSkins = ownedSkins,
        _unlockDates = unlockDates,
        _unlockOrder = unlockOrder,
        _celebrationHistory = celebrationHistory,
        _activeSynergies = activeSynergies;

  final Map<SkinTier, Skin> _ownedSkins;
  @override
  Map<SkinTier, Skin> get ownedSkins {
    if (_ownedSkins is EqualUnmodifiableMapView) return _ownedSkins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ownedSkins);
  }

  @override
  final SkinTier? equippedSkin;
  final Map<SkinTier, DateTime> _unlockDates;
  @override
  Map<SkinTier, DateTime> get unlockDates {
    if (_unlockDates is EqualUnmodifiableMapView) return _unlockDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_unlockDates);
  }

  final Map<SkinTier, int> _unlockOrder;
  @override
  Map<SkinTier, int> get unlockOrder {
    if (_unlockOrder is EqualUnmodifiableMapView) return _unlockOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_unlockOrder);
  }

  final List<UnlockCelebration> _celebrationHistory;
  @override
  List<UnlockCelebration> get celebrationHistory {
    if (_celebrationHistory is EqualUnmodifiableListView)
      return _celebrationHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_celebrationHistory);
  }

  final Map<SkinSynergy, bool> _activeSynergies;
  @override
  Map<SkinSynergy, bool> get activeSynergies {
    if (_activeSynergies is EqualUnmodifiableMapView) return _activeSynergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_activeSynergies);
  }

  @override
  final SkinTier? featuredSkin;

  @override
  String toString() {
    return 'SkinCollection(ownedSkins: $ownedSkins, equippedSkin: $equippedSkin, unlockDates: $unlockDates, unlockOrder: $unlockOrder, celebrationHistory: $celebrationHistory, activeSynergies: $activeSynergies, featuredSkin: $featuredSkin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkinCollectionImpl &&
            const DeepCollectionEquality()
                .equals(other._ownedSkins, _ownedSkins) &&
            (identical(other.equippedSkin, equippedSkin) ||
                other.equippedSkin == equippedSkin) &&
            const DeepCollectionEquality()
                .equals(other._unlockDates, _unlockDates) &&
            const DeepCollectionEquality()
                .equals(other._unlockOrder, _unlockOrder) &&
            const DeepCollectionEquality()
                .equals(other._celebrationHistory, _celebrationHistory) &&
            const DeepCollectionEquality()
                .equals(other._activeSynergies, _activeSynergies) &&
            (identical(other.featuredSkin, featuredSkin) ||
                other.featuredSkin == featuredSkin));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_ownedSkins),
      equippedSkin,
      const DeepCollectionEquality().hash(_unlockDates),
      const DeepCollectionEquality().hash(_unlockOrder),
      const DeepCollectionEquality().hash(_celebrationHistory),
      const DeepCollectionEquality().hash(_activeSynergies),
      featuredSkin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkinCollectionImplCopyWith<_$SkinCollectionImpl> get copyWith =>
      __$$SkinCollectionImplCopyWithImpl<_$SkinCollectionImpl>(
          this, _$identity);
}

abstract class _SkinCollection implements SkinCollection {
  const factory _SkinCollection(
      {required final Map<SkinTier, Skin> ownedSkins,
      required final SkinTier? equippedSkin,
      required final Map<SkinTier, DateTime> unlockDates,
      required final Map<SkinTier, int> unlockOrder,
      required final List<UnlockCelebration> celebrationHistory,
      required final Map<SkinSynergy, bool> activeSynergies,
      required final SkinTier? featuredSkin}) = _$SkinCollectionImpl;

  @override
  Map<SkinTier, Skin> get ownedSkins;
  @override
  SkinTier? get equippedSkin;
  @override
  Map<SkinTier, DateTime> get unlockDates;
  @override
  Map<SkinTier, int> get unlockOrder;
  @override
  List<UnlockCelebration> get celebrationHistory;
  @override
  Map<SkinSynergy, bool> get activeSynergies;
  @override
  SkinTier? get featuredSkin;
  @override
  @JsonKey(ignore: true)
  _$$SkinCollectionImplCopyWith<_$SkinCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UnlockCelebration {
  SkinTier get tier => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  UnlockCelebrationType get celebrationType =>
      throw _privateConstructorUsedError;
  List<String> get particlesUsed => throw _privateConstructorUsedError;
  int get xpAwarded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UnlockCelebrationCopyWith<UnlockCelebration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnlockCelebrationCopyWith<$Res> {
  factory $UnlockCelebrationCopyWith(
          UnlockCelebration value, $Res Function(UnlockCelebration) then) =
      _$UnlockCelebrationCopyWithImpl<$Res, UnlockCelebration>;
  @useResult
  $Res call(
      {SkinTier tier,
      DateTime timestamp,
      UnlockCelebrationType celebrationType,
      List<String> particlesUsed,
      int xpAwarded});
}

/// @nodoc
class _$UnlockCelebrationCopyWithImpl<$Res, $Val extends UnlockCelebration>
    implements $UnlockCelebrationCopyWith<$Res> {
  _$UnlockCelebrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? timestamp = null,
    Object? celebrationType = null,
    Object? particlesUsed = null,
    Object? xpAwarded = null,
  }) {
    return _then(_value.copyWith(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      celebrationType: null == celebrationType
          ? _value.celebrationType
          : celebrationType // ignore: cast_nullable_to_non_nullable
              as UnlockCelebrationType,
      particlesUsed: null == particlesUsed
          ? _value.particlesUsed
          : particlesUsed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      xpAwarded: null == xpAwarded
          ? _value.xpAwarded
          : xpAwarded // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnlockCelebrationImplCopyWith<$Res>
    implements $UnlockCelebrationCopyWith<$Res> {
  factory _$$UnlockCelebrationImplCopyWith(_$UnlockCelebrationImpl value,
          $Res Function(_$UnlockCelebrationImpl) then) =
      __$$UnlockCelebrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SkinTier tier,
      DateTime timestamp,
      UnlockCelebrationType celebrationType,
      List<String> particlesUsed,
      int xpAwarded});
}

/// @nodoc
class __$$UnlockCelebrationImplCopyWithImpl<$Res>
    extends _$UnlockCelebrationCopyWithImpl<$Res, _$UnlockCelebrationImpl>
    implements _$$UnlockCelebrationImplCopyWith<$Res> {
  __$$UnlockCelebrationImplCopyWithImpl(_$UnlockCelebrationImpl _value,
      $Res Function(_$UnlockCelebrationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? timestamp = null,
    Object? celebrationType = null,
    Object? particlesUsed = null,
    Object? xpAwarded = null,
  }) {
    return _then(_$UnlockCelebrationImpl(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      celebrationType: null == celebrationType
          ? _value.celebrationType
          : celebrationType // ignore: cast_nullable_to_non_nullable
              as UnlockCelebrationType,
      particlesUsed: null == particlesUsed
          ? _value._particlesUsed
          : particlesUsed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      xpAwarded: null == xpAwarded
          ? _value.xpAwarded
          : xpAwarded // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UnlockCelebrationImpl implements _UnlockCelebration {
  const _$UnlockCelebrationImpl(
      {required this.tier,
      required this.timestamp,
      required this.celebrationType,
      required final List<String> particlesUsed,
      required this.xpAwarded})
      : _particlesUsed = particlesUsed;

  @override
  final SkinTier tier;
  @override
  final DateTime timestamp;
  @override
  final UnlockCelebrationType celebrationType;
  final List<String> _particlesUsed;
  @override
  List<String> get particlesUsed {
    if (_particlesUsed is EqualUnmodifiableListView) return _particlesUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_particlesUsed);
  }

  @override
  final int xpAwarded;

  @override
  String toString() {
    return 'UnlockCelebration(tier: $tier, timestamp: $timestamp, celebrationType: $celebrationType, particlesUsed: $particlesUsed, xpAwarded: $xpAwarded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnlockCelebrationImpl &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.celebrationType, celebrationType) ||
                other.celebrationType == celebrationType) &&
            const DeepCollectionEquality()
                .equals(other._particlesUsed, _particlesUsed) &&
            (identical(other.xpAwarded, xpAwarded) ||
                other.xpAwarded == xpAwarded));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tier, timestamp, celebrationType,
      const DeepCollectionEquality().hash(_particlesUsed), xpAwarded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnlockCelebrationImplCopyWith<_$UnlockCelebrationImpl> get copyWith =>
      __$$UnlockCelebrationImplCopyWithImpl<_$UnlockCelebrationImpl>(
          this, _$identity);
}

abstract class _UnlockCelebration implements UnlockCelebration {
  const factory _UnlockCelebration(
      {required final SkinTier tier,
      required final DateTime timestamp,
      required final UnlockCelebrationType celebrationType,
      required final List<String> particlesUsed,
      required final int xpAwarded}) = _$UnlockCelebrationImpl;

  @override
  SkinTier get tier;
  @override
  DateTime get timestamp;
  @override
  UnlockCelebrationType get celebrationType;
  @override
  List<String> get particlesUsed;
  @override
  int get xpAwarded;
  @override
  @JsonKey(ignore: true)
  _$$UnlockCelebrationImplCopyWith<_$UnlockCelebrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeeklySkinRotation {
  int get weekNumber => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  SkinTier get featuredSkin => throw _privateConstructorUsedError;
  SkinTier? get exclusiveVariant => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  Map<String, dynamic> get bonusRewards => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WeeklySkinRotationCopyWith<WeeklySkinRotation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklySkinRotationCopyWith<$Res> {
  factory $WeeklySkinRotationCopyWith(
          WeeklySkinRotation value, $Res Function(WeeklySkinRotation) then) =
      _$WeeklySkinRotationCopyWithImpl<$Res, WeeklySkinRotation>;
  @useResult
  $Res call(
      {int weekNumber,
      int year,
      SkinTier featuredSkin,
      SkinTier? exclusiveVariant,
      DateTime startDate,
      DateTime endDate,
      Map<String, dynamic> bonusRewards});
}

/// @nodoc
class _$WeeklySkinRotationCopyWithImpl<$Res, $Val extends WeeklySkinRotation>
    implements $WeeklySkinRotationCopyWith<$Res> {
  _$WeeklySkinRotationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekNumber = null,
    Object? year = null,
    Object? featuredSkin = null,
    Object? exclusiveVariant = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? bonusRewards = null,
  }) {
    return _then(_value.copyWith(
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      featuredSkin: null == featuredSkin
          ? _value.featuredSkin
          : featuredSkin // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      exclusiveVariant: freezed == exclusiveVariant
          ? _value.exclusiveVariant
          : exclusiveVariant // ignore: cast_nullable_to_non_nullable
              as SkinTier?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bonusRewards: null == bonusRewards
          ? _value.bonusRewards
          : bonusRewards // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklySkinRotationImplCopyWith<$Res>
    implements $WeeklySkinRotationCopyWith<$Res> {
  factory _$$WeeklySkinRotationImplCopyWith(_$WeeklySkinRotationImpl value,
          $Res Function(_$WeeklySkinRotationImpl) then) =
      __$$WeeklySkinRotationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int weekNumber,
      int year,
      SkinTier featuredSkin,
      SkinTier? exclusiveVariant,
      DateTime startDate,
      DateTime endDate,
      Map<String, dynamic> bonusRewards});
}

/// @nodoc
class __$$WeeklySkinRotationImplCopyWithImpl<$Res>
    extends _$WeeklySkinRotationCopyWithImpl<$Res, _$WeeklySkinRotationImpl>
    implements _$$WeeklySkinRotationImplCopyWith<$Res> {
  __$$WeeklySkinRotationImplCopyWithImpl(_$WeeklySkinRotationImpl _value,
      $Res Function(_$WeeklySkinRotationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekNumber = null,
    Object? year = null,
    Object? featuredSkin = null,
    Object? exclusiveVariant = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? bonusRewards = null,
  }) {
    return _then(_$WeeklySkinRotationImpl(
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      featuredSkin: null == featuredSkin
          ? _value.featuredSkin
          : featuredSkin // ignore: cast_nullable_to_non_nullable
              as SkinTier,
      exclusiveVariant: freezed == exclusiveVariant
          ? _value.exclusiveVariant
          : exclusiveVariant // ignore: cast_nullable_to_non_nullable
              as SkinTier?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bonusRewards: null == bonusRewards
          ? _value._bonusRewards
          : bonusRewards // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$WeeklySkinRotationImpl implements _WeeklySkinRotation {
  const _$WeeklySkinRotationImpl(
      {required this.weekNumber,
      required this.year,
      required this.featuredSkin,
      required this.exclusiveVariant,
      required this.startDate,
      required this.endDate,
      required final Map<String, dynamic> bonusRewards})
      : _bonusRewards = bonusRewards;

  @override
  final int weekNumber;
  @override
  final int year;
  @override
  final SkinTier featuredSkin;
  @override
  final SkinTier? exclusiveVariant;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final Map<String, dynamic> _bonusRewards;
  @override
  Map<String, dynamic> get bonusRewards {
    if (_bonusRewards is EqualUnmodifiableMapView) return _bonusRewards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bonusRewards);
  }

  @override
  String toString() {
    return 'WeeklySkinRotation(weekNumber: $weekNumber, year: $year, featuredSkin: $featuredSkin, exclusiveVariant: $exclusiveVariant, startDate: $startDate, endDate: $endDate, bonusRewards: $bonusRewards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklySkinRotationImpl &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.featuredSkin, featuredSkin) ||
                other.featuredSkin == featuredSkin) &&
            (identical(other.exclusiveVariant, exclusiveVariant) ||
                other.exclusiveVariant == exclusiveVariant) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._bonusRewards, _bonusRewards));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      weekNumber,
      year,
      featuredSkin,
      exclusiveVariant,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_bonusRewards));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklySkinRotationImplCopyWith<_$WeeklySkinRotationImpl> get copyWith =>
      __$$WeeklySkinRotationImplCopyWithImpl<_$WeeklySkinRotationImpl>(
          this, _$identity);
}

abstract class _WeeklySkinRotation implements WeeklySkinRotation {
  const factory _WeeklySkinRotation(
          {required final int weekNumber,
          required final int year,
          required final SkinTier featuredSkin,
          required final SkinTier? exclusiveVariant,
          required final DateTime startDate,
          required final DateTime endDate,
          required final Map<String, dynamic> bonusRewards}) =
      _$WeeklySkinRotationImpl;

  @override
  int get weekNumber;
  @override
  int get year;
  @override
  SkinTier get featuredSkin;
  @override
  SkinTier? get exclusiveVariant;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  Map<String, dynamic> get bonusRewards;
  @override
  @JsonKey(ignore: true)
  _$$WeeklySkinRotationImplCopyWith<_$WeeklySkinRotationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
