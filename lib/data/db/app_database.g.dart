// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LevelsTable extends Levels with TableInfo<$LevelsTable, LevelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, sortOrder, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LevelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $LevelsTable createAlias(String alias) {
    return $LevelsTable(attachedDatabase, alias);
  }
}

class LevelRow extends DataClass implements Insertable<LevelRow> {
  final int id;
  final String code;
  final int sortOrder;
  final String title;
  const LevelRow({
    required this.id,
    required this.code,
    required this.sortOrder,
    required this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['sort_order'] = Variable<int>(sortOrder);
    map['title'] = Variable<String>(title);
    return map;
  }

  LevelsCompanion toCompanion(bool nullToAbsent) {
    return LevelsCompanion(
      id: Value(id),
      code: Value(code),
      sortOrder: Value(sortOrder),
      title: Value(title),
    );
  }

  factory LevelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'title': serializer.toJson<String>(title),
    };
  }

  LevelRow copyWith({int? id, String? code, int? sortOrder, String? title}) =>
      LevelRow(
        id: id ?? this.id,
        code: code ?? this.code,
        sortOrder: sortOrder ?? this.sortOrder,
        title: title ?? this.title,
      );
  LevelRow copyWithCompanion(LevelsCompanion data) {
    return LevelRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, sortOrder, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.sortOrder == this.sortOrder &&
          other.title == this.title);
}

class LevelsCompanion extends UpdateCompanion<LevelRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<int> sortOrder;
  final Value<String> title;
  const LevelsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.title = const Value.absent(),
  });
  LevelsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required int sortOrder,
    required String title,
  }) : code = Value(code),
       sortOrder = Value(sortOrder),
       title = Value(title);
  static Insertable<LevelRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<int>? sortOrder,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (title != null) 'title': title,
    });
  }

  LevelsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<int>? sortOrder,
    Value<String>? title,
  }) {
    return LevelsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      sortOrder: sortOrder ?? this.sortOrder,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, UnitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<int> levelId = GeneratedColumn<int>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES levels (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleTrMeta = const VerificationMeta(
    'titleTr',
  );
  @override
  late final GeneratedColumn<String> titleTr = GeneratedColumn<String>(
    'title_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    levelId,
    sortOrder,
    titleTr,
    theme,
    icon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('title_tr')) {
      context.handle(
        _titleTrMeta,
        titleTr.isAcceptableOrUnknown(data['title_tr']!, _titleTrMeta),
      );
    } else if (isInserting) {
      context.missing(_titleTrMeta);
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      titleTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_tr'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class UnitRow extends DataClass implements Insertable<UnitRow> {
  final int id;
  final int levelId;
  final int sortOrder;
  final String titleTr;
  final String theme;
  final String? icon;
  const UnitRow({
    required this.id,
    required this.levelId,
    required this.sortOrder,
    required this.titleTr,
    required this.theme,
    this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level_id'] = Variable<int>(levelId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['title_tr'] = Variable<String>(titleTr);
    map['theme'] = Variable<String>(theme);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      levelId: Value(levelId),
      sortOrder: Value(sortOrder),
      titleTr: Value(titleTr),
      theme: Value(theme),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory UnitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitRow(
      id: serializer.fromJson<int>(json['id']),
      levelId: serializer.fromJson<int>(json['levelId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      titleTr: serializer.fromJson<String>(json['titleTr']),
      theme: serializer.fromJson<String>(json['theme']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'levelId': serializer.toJson<int>(levelId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'titleTr': serializer.toJson<String>(titleTr),
      'theme': serializer.toJson<String>(theme),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  UnitRow copyWith({
    int? id,
    int? levelId,
    int? sortOrder,
    String? titleTr,
    String? theme,
    Value<String?> icon = const Value.absent(),
  }) => UnitRow(
    id: id ?? this.id,
    levelId: levelId ?? this.levelId,
    sortOrder: sortOrder ?? this.sortOrder,
    titleTr: titleTr ?? this.titleTr,
    theme: theme ?? this.theme,
    icon: icon.present ? icon.value : this.icon,
  );
  UnitRow copyWithCompanion(UnitsCompanion data) {
    return UnitRow(
      id: data.id.present ? data.id.value : this.id,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      titleTr: data.titleTr.present ? data.titleTr.value : this.titleTr,
      theme: data.theme.present ? data.theme.value : this.theme,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitRow(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('titleTr: $titleTr, ')
          ..write('theme: $theme, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, levelId, sortOrder, titleTr, theme, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitRow &&
          other.id == this.id &&
          other.levelId == this.levelId &&
          other.sortOrder == this.sortOrder &&
          other.titleTr == this.titleTr &&
          other.theme == this.theme &&
          other.icon == this.icon);
}

class UnitsCompanion extends UpdateCompanion<UnitRow> {
  final Value<int> id;
  final Value<int> levelId;
  final Value<int> sortOrder;
  final Value<String> titleTr;
  final Value<String> theme;
  final Value<String?> icon;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.levelId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.titleTr = const Value.absent(),
    this.theme = const Value.absent(),
    this.icon = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required int levelId,
    required int sortOrder,
    required String titleTr,
    required String theme,
    this.icon = const Value.absent(),
  }) : levelId = Value(levelId),
       sortOrder = Value(sortOrder),
       titleTr = Value(titleTr),
       theme = Value(theme);
  static Insertable<UnitRow> custom({
    Expression<int>? id,
    Expression<int>? levelId,
    Expression<int>? sortOrder,
    Expression<String>? titleTr,
    Expression<String>? theme,
    Expression<String>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelId != null) 'level_id': levelId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (titleTr != null) 'title_tr': titleTr,
      if (theme != null) 'theme': theme,
      if (icon != null) 'icon': icon,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<int>? levelId,
    Value<int>? sortOrder,
    Value<String>? titleTr,
    Value<String>? theme,
    Value<String?>? icon,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      sortOrder: sortOrder ?? this.sortOrder,
      titleTr: titleTr ?? this.titleTr,
      theme: theme ?? this.theme,
      icon: icon ?? this.icon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<int>(levelId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (titleTr.present) {
      map['title_tr'] = Variable<String>(titleTr.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('titleTr: $titleTr, ')
          ..write('theme: $theme, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, WordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id)',
    ),
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ipaMeta = const VerificationMeta('ipa');
  @override
  late final GeneratedColumn<String> ipa = GeneratedColumn<String>(
    'ipa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningTrMeta = const VerificationMeta(
    'meaningTr',
  );
  @override
  late final GeneratedColumn<String> meaningTr = GeneratedColumn<String>(
    'meaning_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyRankMeta = const VerificationMeta(
    'frequencyRank',
  );
  @override
  late final GeneratedColumn<int> frequencyRank = GeneratedColumn<int>(
    'frequency_rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitId,
    lemma,
    ipa,
    pos,
    meaningTr,
    frequencyRank,
    imagePath,
    audioPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    if (data.containsKey('ipa')) {
      context.handle(
        _ipaMeta,
        ipa.isAcceptableOrUnknown(data['ipa']!, _ipaMeta),
      );
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    } else if (isInserting) {
      context.missing(_posMeta);
    }
    if (data.containsKey('meaning_tr')) {
      context.handle(
        _meaningTrMeta,
        meaningTr.isAcceptableOrUnknown(data['meaning_tr']!, _meaningTrMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningTrMeta);
    }
    if (data.containsKey('frequency_rank')) {
      context.handle(
        _frequencyRankMeta,
        frequencyRank.isAcceptableOrUnknown(
          data['frequency_rank']!,
          _frequencyRankMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      lemma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma'],
      )!,
      ipa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ipa'],
      ),
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      )!,
      meaningTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_tr'],
      )!,
      frequencyRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_rank'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class WordRow extends DataClass implements Insertable<WordRow> {
  final int id;
  final int unitId;
  final String lemma;
  final String? ipa;
  final String pos;
  final String meaningTr;
  final int? frequencyRank;
  final String? imagePath;
  final String? audioPath;
  const WordRow({
    required this.id,
    required this.unitId,
    required this.lemma,
    this.ipa,
    required this.pos,
    required this.meaningTr,
    this.frequencyRank,
    this.imagePath,
    this.audioPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unit_id'] = Variable<int>(unitId);
    map['lemma'] = Variable<String>(lemma);
    if (!nullToAbsent || ipa != null) {
      map['ipa'] = Variable<String>(ipa);
    }
    map['pos'] = Variable<String>(pos);
    map['meaning_tr'] = Variable<String>(meaningTr);
    if (!nullToAbsent || frequencyRank != null) {
      map['frequency_rank'] = Variable<int>(frequencyRank);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      unitId: Value(unitId),
      lemma: Value(lemma),
      ipa: ipa == null && nullToAbsent ? const Value.absent() : Value(ipa),
      pos: Value(pos),
      meaningTr: Value(meaningTr),
      frequencyRank: frequencyRank == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyRank),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
    );
  }

  factory WordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordRow(
      id: serializer.fromJson<int>(json['id']),
      unitId: serializer.fromJson<int>(json['unitId']),
      lemma: serializer.fromJson<String>(json['lemma']),
      ipa: serializer.fromJson<String?>(json['ipa']),
      pos: serializer.fromJson<String>(json['pos']),
      meaningTr: serializer.fromJson<String>(json['meaningTr']),
      frequencyRank: serializer.fromJson<int?>(json['frequencyRank']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'unitId': serializer.toJson<int>(unitId),
      'lemma': serializer.toJson<String>(lemma),
      'ipa': serializer.toJson<String?>(ipa),
      'pos': serializer.toJson<String>(pos),
      'meaningTr': serializer.toJson<String>(meaningTr),
      'frequencyRank': serializer.toJson<int?>(frequencyRank),
      'imagePath': serializer.toJson<String?>(imagePath),
      'audioPath': serializer.toJson<String?>(audioPath),
    };
  }

  WordRow copyWith({
    int? id,
    int? unitId,
    String? lemma,
    Value<String?> ipa = const Value.absent(),
    String? pos,
    String? meaningTr,
    Value<int?> frequencyRank = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
  }) => WordRow(
    id: id ?? this.id,
    unitId: unitId ?? this.unitId,
    lemma: lemma ?? this.lemma,
    ipa: ipa.present ? ipa.value : this.ipa,
    pos: pos ?? this.pos,
    meaningTr: meaningTr ?? this.meaningTr,
    frequencyRank: frequencyRank.present
        ? frequencyRank.value
        : this.frequencyRank,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
  );
  WordRow copyWithCompanion(WordsCompanion data) {
    return WordRow(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      ipa: data.ipa.present ? data.ipa.value : this.ipa,
      pos: data.pos.present ? data.pos.value : this.pos,
      meaningTr: data.meaningTr.present ? data.meaningTr.value : this.meaningTr,
      frequencyRank: data.frequencyRank.present
          ? data.frequencyRank.value
          : this.frequencyRank,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordRow(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('lemma: $lemma, ')
          ..write('ipa: $ipa, ')
          ..write('pos: $pos, ')
          ..write('meaningTr: $meaningTr, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('imagePath: $imagePath, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    unitId,
    lemma,
    ipa,
    pos,
    meaningTr,
    frequencyRank,
    imagePath,
    audioPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordRow &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.lemma == this.lemma &&
          other.ipa == this.ipa &&
          other.pos == this.pos &&
          other.meaningTr == this.meaningTr &&
          other.frequencyRank == this.frequencyRank &&
          other.imagePath == this.imagePath &&
          other.audioPath == this.audioPath);
}

class WordsCompanion extends UpdateCompanion<WordRow> {
  final Value<int> id;
  final Value<int> unitId;
  final Value<String> lemma;
  final Value<String?> ipa;
  final Value<String> pos;
  final Value<String> meaningTr;
  final Value<int?> frequencyRank;
  final Value<String?> imagePath;
  final Value<String?> audioPath;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.lemma = const Value.absent(),
    this.ipa = const Value.absent(),
    this.pos = const Value.absent(),
    this.meaningTr = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.audioPath = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required int unitId,
    required String lemma,
    this.ipa = const Value.absent(),
    required String pos,
    required String meaningTr,
    this.frequencyRank = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.audioPath = const Value.absent(),
  }) : unitId = Value(unitId),
       lemma = Value(lemma),
       pos = Value(pos),
       meaningTr = Value(meaningTr);
  static Insertable<WordRow> custom({
    Expression<int>? id,
    Expression<int>? unitId,
    Expression<String>? lemma,
    Expression<String>? ipa,
    Expression<String>? pos,
    Expression<String>? meaningTr,
    Expression<int>? frequencyRank,
    Expression<String>? imagePath,
    Expression<String>? audioPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (lemma != null) 'lemma': lemma,
      if (ipa != null) 'ipa': ipa,
      if (pos != null) 'pos': pos,
      if (meaningTr != null) 'meaning_tr': meaningTr,
      if (frequencyRank != null) 'frequency_rank': frequencyRank,
      if (imagePath != null) 'image_path': imagePath,
      if (audioPath != null) 'audio_path': audioPath,
    });
  }

  WordsCompanion copyWith({
    Value<int>? id,
    Value<int>? unitId,
    Value<String>? lemma,
    Value<String?>? ipa,
    Value<String>? pos,
    Value<String>? meaningTr,
    Value<int?>? frequencyRank,
    Value<String?>? imagePath,
    Value<String?>? audioPath,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      lemma: lemma ?? this.lemma,
      ipa: ipa ?? this.ipa,
      pos: pos ?? this.pos,
      meaningTr: meaningTr ?? this.meaningTr,
      frequencyRank: frequencyRank ?? this.frequencyRank,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (ipa.present) {
      map['ipa'] = Variable<String>(ipa.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (meaningTr.present) {
      map['meaning_tr'] = Variable<String>(meaningTr.value);
    }
    if (frequencyRank.present) {
      map['frequency_rank'] = Variable<int>(frequencyRank.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('lemma: $lemma, ')
          ..write('ipa: $ipa, ')
          ..write('pos: $pos, ')
          ..write('meaningTr: $meaningTr, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('imagePath: $imagePath, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }
}

class $ExamplesTable extends Examples
    with TableInfo<$ExamplesTable, ExampleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _sentenceEnMeta = const VerificationMeta(
    'sentenceEn',
  );
  @override
  late final GeneratedColumn<String> sentenceEn = GeneratedColumn<String>(
    'sentence_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceTrMeta = const VerificationMeta(
    'sentenceTr',
  );
  @override
  late final GeneratedColumn<String> sentenceTr = GeneratedColumn<String>(
    'sentence_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, wordId, sentenceEn, sentenceTr];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExampleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('sentence_en')) {
      context.handle(
        _sentenceEnMeta,
        sentenceEn.isAcceptableOrUnknown(data['sentence_en']!, _sentenceEnMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceEnMeta);
    }
    if (data.containsKey('sentence_tr')) {
      context.handle(
        _sentenceTrMeta,
        sentenceTr.isAcceptableOrUnknown(data['sentence_tr']!, _sentenceTrMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceTrMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExampleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExampleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      sentenceEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence_en'],
      )!,
      sentenceTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence_tr'],
      )!,
    );
  }

  @override
  $ExamplesTable createAlias(String alias) {
    return $ExamplesTable(attachedDatabase, alias);
  }
}

class ExampleRow extends DataClass implements Insertable<ExampleRow> {
  final int id;
  final int wordId;
  final String sentenceEn;
  final String sentenceTr;
  const ExampleRow({
    required this.id,
    required this.wordId,
    required this.sentenceEn,
    required this.sentenceTr,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['sentence_en'] = Variable<String>(sentenceEn);
    map['sentence_tr'] = Variable<String>(sentenceTr);
    return map;
  }

  ExamplesCompanion toCompanion(bool nullToAbsent) {
    return ExamplesCompanion(
      id: Value(id),
      wordId: Value(wordId),
      sentenceEn: Value(sentenceEn),
      sentenceTr: Value(sentenceTr),
    );
  }

  factory ExampleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExampleRow(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      sentenceEn: serializer.fromJson<String>(json['sentenceEn']),
      sentenceTr: serializer.fromJson<String>(json['sentenceTr']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'sentenceEn': serializer.toJson<String>(sentenceEn),
      'sentenceTr': serializer.toJson<String>(sentenceTr),
    };
  }

  ExampleRow copyWith({
    int? id,
    int? wordId,
    String? sentenceEn,
    String? sentenceTr,
  }) => ExampleRow(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    sentenceEn: sentenceEn ?? this.sentenceEn,
    sentenceTr: sentenceTr ?? this.sentenceTr,
  );
  ExampleRow copyWithCompanion(ExamplesCompanion data) {
    return ExampleRow(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      sentenceEn: data.sentenceEn.present
          ? data.sentenceEn.value
          : this.sentenceEn,
      sentenceTr: data.sentenceTr.present
          ? data.sentenceTr.value
          : this.sentenceTr,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExampleRow(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('sentenceEn: $sentenceEn, ')
          ..write('sentenceTr: $sentenceTr')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, sentenceEn, sentenceTr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExampleRow &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.sentenceEn == this.sentenceEn &&
          other.sentenceTr == this.sentenceTr);
}

class ExamplesCompanion extends UpdateCompanion<ExampleRow> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<String> sentenceEn;
  final Value<String> sentenceTr;
  const ExamplesCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.sentenceEn = const Value.absent(),
    this.sentenceTr = const Value.absent(),
  });
  ExamplesCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required String sentenceEn,
    required String sentenceTr,
  }) : wordId = Value(wordId),
       sentenceEn = Value(sentenceEn),
       sentenceTr = Value(sentenceTr);
  static Insertable<ExampleRow> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? sentenceEn,
    Expression<String>? sentenceTr,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (sentenceEn != null) 'sentence_en': sentenceEn,
      if (sentenceTr != null) 'sentence_tr': sentenceTr,
    });
  }

  ExamplesCompanion copyWith({
    Value<int>? id,
    Value<int>? wordId,
    Value<String>? sentenceEn,
    Value<String>? sentenceTr,
  }) {
    return ExamplesCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      sentenceEn: sentenceEn ?? this.sentenceEn,
      sentenceTr: sentenceTr ?? this.sentenceTr,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (sentenceEn.present) {
      map['sentence_en'] = Variable<String>(sentenceEn.value);
    }
    if (sentenceTr.present) {
      map['sentence_tr'] = Variable<String>(sentenceTr.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamplesCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('sentenceEn: $sentenceEn, ')
          ..write('sentenceTr: $sentenceTr')
          ..write(')'))
        .toString();
  }
}

class $WordRelationsTable extends WordRelations
    with TableInfo<$WordRelationsTable, WordRelationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _relatedWordIdMeta = const VerificationMeta(
    'relatedWordId',
  );
  @override
  late final GeneratedColumn<int> relatedWordId = GeneratedColumn<int>(
    'related_word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [wordId, relatedWordId, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordRelationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('related_word_id')) {
      context.handle(
        _relatedWordIdMeta,
        relatedWordId.isAcceptableOrUnknown(
          data['related_word_id']!,
          _relatedWordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relatedWordIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId, relatedWordId, type};
  @override
  WordRelationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordRelationRow(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      relatedWordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_word_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $WordRelationsTable createAlias(String alias) {
    return $WordRelationsTable(attachedDatabase, alias);
  }
}

class WordRelationRow extends DataClass implements Insertable<WordRelationRow> {
  final int wordId;
  final int relatedWordId;
  final String type;
  const WordRelationRow({
    required this.wordId,
    required this.relatedWordId,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<int>(wordId);
    map['related_word_id'] = Variable<int>(relatedWordId);
    map['type'] = Variable<String>(type);
    return map;
  }

  WordRelationsCompanion toCompanion(bool nullToAbsent) {
    return WordRelationsCompanion(
      wordId: Value(wordId),
      relatedWordId: Value(relatedWordId),
      type: Value(type),
    );
  }

  factory WordRelationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordRelationRow(
      wordId: serializer.fromJson<int>(json['wordId']),
      relatedWordId: serializer.fromJson<int>(json['relatedWordId']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<int>(wordId),
      'relatedWordId': serializer.toJson<int>(relatedWordId),
      'type': serializer.toJson<String>(type),
    };
  }

  WordRelationRow copyWith({int? wordId, int? relatedWordId, String? type}) =>
      WordRelationRow(
        wordId: wordId ?? this.wordId,
        relatedWordId: relatedWordId ?? this.relatedWordId,
        type: type ?? this.type,
      );
  WordRelationRow copyWithCompanion(WordRelationsCompanion data) {
    return WordRelationRow(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      relatedWordId: data.relatedWordId.present
          ? data.relatedWordId.value
          : this.relatedWordId,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordRelationRow(')
          ..write('wordId: $wordId, ')
          ..write('relatedWordId: $relatedWordId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, relatedWordId, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordRelationRow &&
          other.wordId == this.wordId &&
          other.relatedWordId == this.relatedWordId &&
          other.type == this.type);
}

class WordRelationsCompanion extends UpdateCompanion<WordRelationRow> {
  final Value<int> wordId;
  final Value<int> relatedWordId;
  final Value<String> type;
  final Value<int> rowid;
  const WordRelationsCompanion({
    this.wordId = const Value.absent(),
    this.relatedWordId = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordRelationsCompanion.insert({
    required int wordId,
    required int relatedWordId,
    required String type,
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId),
       relatedWordId = Value(relatedWordId),
       type = Value(type);
  static Insertable<WordRelationRow> custom({
    Expression<int>? wordId,
    Expression<int>? relatedWordId,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (relatedWordId != null) 'related_word_id': relatedWordId,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordRelationsCompanion copyWith({
    Value<int>? wordId,
    Value<int>? relatedWordId,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return WordRelationsCompanion(
      wordId: wordId ?? this.wordId,
      relatedWordId: relatedWordId ?? this.relatedWordId,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (relatedWordId.present) {
      map['related_word_id'] = Variable<int>(relatedWordId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordRelationsCompanion(')
          ..write('wordId: $wordId, ')
          ..write('relatedWordId: $relatedWordId, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewCardsTable extends ReviewCards
    with TableInfo<$ReviewCardsTable, ReviewCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('new'),
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    wordId,
    state,
    easeFactor,
    intervalDays,
    repetitions,
    dueAt,
    lapses,
    lastReviewedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  ReviewCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewCardRow(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReviewCardsTable createAlias(String alias) {
    return $ReviewCardsTable(attachedDatabase, alias);
  }
}

class ReviewCardRow extends DataClass implements Insertable<ReviewCardRow> {
  final int wordId;
  final String state;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final DateTime? dueAt;
  final int lapses;
  final DateTime? lastReviewedAt;
  final DateTime updatedAt;
  const ReviewCardRow({
    required this.wordId,
    required this.state,
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    this.dueAt,
    required this.lapses,
    this.lastReviewedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<int>(wordId);
    map['state'] = Variable<String>(state);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    map['repetitions'] = Variable<int>(repetitions);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReviewCardsCompanion toCompanion(bool nullToAbsent) {
    return ReviewCardsCompanion(
      wordId: Value(wordId),
      state: Value(state),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      repetitions: Value(repetitions),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      lapses: Value(lapses),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReviewCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewCardRow(
      wordId: serializer.fromJson<int>(json['wordId']),
      state: serializer.fromJson<String>(json['state']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<int>(wordId),
      'state': serializer.toJson<String>(state),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'repetitions': serializer.toJson<int>(repetitions),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'lapses': serializer.toJson<int>(lapses),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReviewCardRow copyWith({
    int? wordId,
    String? state,
    double? easeFactor,
    int? intervalDays,
    int? repetitions,
    Value<DateTime?> dueAt = const Value.absent(),
    int? lapses,
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => ReviewCardRow(
    wordId: wordId ?? this.wordId,
    state: state ?? this.state,
    easeFactor: easeFactor ?? this.easeFactor,
    intervalDays: intervalDays ?? this.intervalDays,
    repetitions: repetitions ?? this.repetitions,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    lapses: lapses ?? this.lapses,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReviewCardRow copyWithCompanion(ReviewCardsCompanion data) {
    return ReviewCardRow(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      state: data.state.present ? data.state.value : this.state,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewCardRow(')
          ..write('wordId: $wordId, ')
          ..write('state: $state, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('dueAt: $dueAt, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    wordId,
    state,
    easeFactor,
    intervalDays,
    repetitions,
    dueAt,
    lapses,
    lastReviewedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewCardRow &&
          other.wordId == this.wordId &&
          other.state == this.state &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.repetitions == this.repetitions &&
          other.dueAt == this.dueAt &&
          other.lapses == this.lapses &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.updatedAt == this.updatedAt);
}

class ReviewCardsCompanion extends UpdateCompanion<ReviewCardRow> {
  final Value<int> wordId;
  final Value<String> state;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<int> repetitions;
  final Value<DateTime?> dueAt;
  final Value<int> lapses;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime> updatedAt;
  const ReviewCardsCompanion({
    this.wordId = const Value.absent(),
    this.state = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReviewCardsCompanion.insert({
    this.wordId = const Value.absent(),
    this.state = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<ReviewCardRow> custom({
    Expression<int>? wordId,
    Expression<String>? state,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<int>? repetitions,
    Expression<DateTime>? dueAt,
    Expression<int>? lapses,
    Expression<DateTime>? lastReviewedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (state != null) 'state': state,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (repetitions != null) 'repetitions': repetitions,
      if (dueAt != null) 'due_at': dueAt,
      if (lapses != null) 'lapses': lapses,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReviewCardsCompanion copyWith({
    Value<int>? wordId,
    Value<String>? state,
    Value<double>? easeFactor,
    Value<int>? intervalDays,
    Value<int>? repetitions,
    Value<DateTime?>? dueAt,
    Value<int>? lapses,
    Value<DateTime?>? lastReviewedAt,
    Value<DateTime>? updatedAt,
  }) {
    return ReviewCardsCompanion(
      wordId: wordId ?? this.wordId,
      state: state ?? this.state,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      dueAt: dueAt ?? this.dueAt,
      lapses: lapses ?? this.lapses,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewCardsCompanion(')
          ..write('wordId: $wordId, ')
          ..write('state: $state, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('dueAt: $dueAt, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseMsMeta = const VerificationMeta(
    'responseMs',
  );
  @override
  late final GeneratedColumn<int> responseMs = GeneratedColumn<int>(
    'response_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    exerciseType,
    quality,
    responseMs,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseTypeMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('response_ms')) {
      context.handle(
        _responseMsMeta,
        responseMs.isAcceptableOrUnknown(data['response_ms']!, _responseMsMeta),
      );
    } else if (isInserting) {
      context.missing(_responseMsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      )!,
      responseMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_ms'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLogRow extends DataClass implements Insertable<ReviewLogRow> {
  final int id;
  final int wordId;
  final String exerciseType;
  final int quality;
  final int responseMs;
  final DateTime createdAt;
  const ReviewLogRow({
    required this.id,
    required this.wordId,
    required this.exerciseType,
    required this.quality,
    required this.responseMs,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['exercise_type'] = Variable<String>(exerciseType);
    map['quality'] = Variable<int>(quality);
    map['response_ms'] = Variable<int>(responseMs);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      wordId: Value(wordId),
      exerciseType: Value(exerciseType),
      quality: Value(quality),
      responseMs: Value(responseMs),
      createdAt: Value(createdAt),
    );
  }

  factory ReviewLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLogRow(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
      quality: serializer.fromJson<int>(json['quality']),
      responseMs: serializer.fromJson<int>(json['responseMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'exerciseType': serializer.toJson<String>(exerciseType),
      'quality': serializer.toJson<int>(quality),
      'responseMs': serializer.toJson<int>(responseMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReviewLogRow copyWith({
    int? id,
    int? wordId,
    String? exerciseType,
    int? quality,
    int? responseMs,
    DateTime? createdAt,
  }) => ReviewLogRow(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    exerciseType: exerciseType ?? this.exerciseType,
    quality: quality ?? this.quality,
    responseMs: responseMs ?? this.responseMs,
    createdAt: createdAt ?? this.createdAt,
  );
  ReviewLogRow copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLogRow(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      quality: data.quality.present ? data.quality.value : this.quality,
      responseMs: data.responseMs.present
          ? data.responseMs.value
          : this.responseMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogRow(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('quality: $quality, ')
          ..write('responseMs: $responseMs, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, wordId, exerciseType, quality, responseMs, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLogRow &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.exerciseType == this.exerciseType &&
          other.quality == this.quality &&
          other.responseMs == this.responseMs &&
          other.createdAt == this.createdAt);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLogRow> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<String> exerciseType;
  final Value<int> quality;
  final Value<int> responseMs;
  final Value<DateTime> createdAt;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.quality = const Value.absent(),
    this.responseMs = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required String exerciseType,
    required int quality,
    required int responseMs,
    this.createdAt = const Value.absent(),
  }) : wordId = Value(wordId),
       exerciseType = Value(exerciseType),
       quality = Value(quality),
       responseMs = Value(responseMs);
  static Insertable<ReviewLogRow> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? exerciseType,
    Expression<int>? quality,
    Expression<int>? responseMs,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (quality != null) 'quality': quality,
      if (responseMs != null) 'response_ms': responseMs,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? wordId,
    Value<String>? exerciseType,
    Value<int>? quality,
    Value<int>? responseMs,
    Value<DateTime>? createdAt,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      exerciseType: exerciseType ?? this.exerciseType,
      quality: quality ?? this.quality,
      responseMs: responseMs ?? this.responseMs,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (responseMs.present) {
      map['response_ms'] = Variable<int>(responseMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('quality: $quality, ')
          ..write('responseMs: $responseMs, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UnitProgressTable extends UnitProgress
    with TableInfo<$UnitProgressTable, UnitProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('locked'),
  );
  static const VerificationMeta _bestScoreMeta = const VerificationMeta(
    'bestScore',
  );
  @override
  late final GeneratedColumn<int> bestScore = GeneratedColumn<int>(
    'best_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    unitId,
    status,
    bestScore,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('best_score')) {
      context.handle(
        _bestScoreMeta,
        bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {unitId};
  @override
  UnitProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitProgressRow(
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      bestScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_score'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $UnitProgressTable createAlias(String alias) {
    return $UnitProgressTable(attachedDatabase, alias);
  }
}

class UnitProgressRow extends DataClass implements Insertable<UnitProgressRow> {
  final int unitId;
  final String status;
  final int? bestScore;
  final DateTime? completedAt;
  const UnitProgressRow({
    required this.unitId,
    required this.status,
    this.bestScore,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unit_id'] = Variable<int>(unitId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || bestScore != null) {
      map['best_score'] = Variable<int>(bestScore);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  UnitProgressCompanion toCompanion(bool nullToAbsent) {
    return UnitProgressCompanion(
      unitId: Value(unitId),
      status: Value(status),
      bestScore: bestScore == null && nullToAbsent
          ? const Value.absent()
          : Value(bestScore),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory UnitProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitProgressRow(
      unitId: serializer.fromJson<int>(json['unitId']),
      status: serializer.fromJson<String>(json['status']),
      bestScore: serializer.fromJson<int?>(json['bestScore']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'unitId': serializer.toJson<int>(unitId),
      'status': serializer.toJson<String>(status),
      'bestScore': serializer.toJson<int?>(bestScore),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  UnitProgressRow copyWith({
    int? unitId,
    String? status,
    Value<int?> bestScore = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => UnitProgressRow(
    unitId: unitId ?? this.unitId,
    status: status ?? this.status,
    bestScore: bestScore.present ? bestScore.value : this.bestScore,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  UnitProgressRow copyWithCompanion(UnitProgressCompanion data) {
    return UnitProgressRow(
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      status: data.status.present ? data.status.value : this.status,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitProgressRow(')
          ..write('unitId: $unitId, ')
          ..write('status: $status, ')
          ..write('bestScore: $bestScore, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(unitId, status, bestScore, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitProgressRow &&
          other.unitId == this.unitId &&
          other.status == this.status &&
          other.bestScore == this.bestScore &&
          other.completedAt == this.completedAt);
}

class UnitProgressCompanion extends UpdateCompanion<UnitProgressRow> {
  final Value<int> unitId;
  final Value<String> status;
  final Value<int?> bestScore;
  final Value<DateTime?> completedAt;
  const UnitProgressCompanion({
    this.unitId = const Value.absent(),
    this.status = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  UnitProgressCompanion.insert({
    this.unitId = const Value.absent(),
    this.status = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  static Insertable<UnitProgressRow> custom({
    Expression<int>? unitId,
    Expression<String>? status,
    Expression<int>? bestScore,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (unitId != null) 'unit_id': unitId,
      if (status != null) 'status': status,
      if (bestScore != null) 'best_score': bestScore,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  UnitProgressCompanion copyWith({
    Value<int>? unitId,
    Value<String>? status,
    Value<int?>? bestScore,
    Value<DateTime?>? completedAt,
  }) {
    return UnitProgressCompanion(
      unitId: unitId ?? this.unitId,
      status: status ?? this.status,
      bestScore: bestScore ?? this.bestScore,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<int>(bestScore.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitProgressCompanion(')
          ..write('unitId: $unitId, ')
          ..write('status: $status, ')
          ..write('bestScore: $bestScore, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $LevelProgressTable extends LevelProgress
    with TableInfo<$LevelProgressTable, LevelProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<int> levelId = GeneratedColumn<int>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES levels (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('locked'),
  );
  static const VerificationMeta _examBestScoreMeta = const VerificationMeta(
    'examBestScore',
  );
  @override
  late final GeneratedColumn<int> examBestScore = GeneratedColumn<int>(
    'exam_best_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _examLastAttemptAtMeta = const VerificationMeta(
    'examLastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> examLastAttemptAt =
      GeneratedColumn<DateTime>(
        'exam_last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    levelId,
    status,
    examBestScore,
    examLastAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('exam_best_score')) {
      context.handle(
        _examBestScoreMeta,
        examBestScore.isAcceptableOrUnknown(
          data['exam_best_score']!,
          _examBestScoreMeta,
        ),
      );
    }
    if (data.containsKey('exam_last_attempt_at')) {
      context.handle(
        _examLastAttemptAtMeta,
        examLastAttemptAt.isAcceptableOrUnknown(
          data['exam_last_attempt_at']!,
          _examLastAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {levelId};
  @override
  LevelProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelProgressRow(
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      examBestScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exam_best_score'],
      ),
      examLastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exam_last_attempt_at'],
      ),
    );
  }

  @override
  $LevelProgressTable createAlias(String alias) {
    return $LevelProgressTable(attachedDatabase, alias);
  }
}

class LevelProgressRow extends DataClass
    implements Insertable<LevelProgressRow> {
  final int levelId;
  final String status;
  final int? examBestScore;
  final DateTime? examLastAttemptAt;
  const LevelProgressRow({
    required this.levelId,
    required this.status,
    this.examBestScore,
    this.examLastAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['level_id'] = Variable<int>(levelId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || examBestScore != null) {
      map['exam_best_score'] = Variable<int>(examBestScore);
    }
    if (!nullToAbsent || examLastAttemptAt != null) {
      map['exam_last_attempt_at'] = Variable<DateTime>(examLastAttemptAt);
    }
    return map;
  }

  LevelProgressCompanion toCompanion(bool nullToAbsent) {
    return LevelProgressCompanion(
      levelId: Value(levelId),
      status: Value(status),
      examBestScore: examBestScore == null && nullToAbsent
          ? const Value.absent()
          : Value(examBestScore),
      examLastAttemptAt: examLastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(examLastAttemptAt),
    );
  }

  factory LevelProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelProgressRow(
      levelId: serializer.fromJson<int>(json['levelId']),
      status: serializer.fromJson<String>(json['status']),
      examBestScore: serializer.fromJson<int?>(json['examBestScore']),
      examLastAttemptAt: serializer.fromJson<DateTime?>(
        json['examLastAttemptAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'levelId': serializer.toJson<int>(levelId),
      'status': serializer.toJson<String>(status),
      'examBestScore': serializer.toJson<int?>(examBestScore),
      'examLastAttemptAt': serializer.toJson<DateTime?>(examLastAttemptAt),
    };
  }

  LevelProgressRow copyWith({
    int? levelId,
    String? status,
    Value<int?> examBestScore = const Value.absent(),
    Value<DateTime?> examLastAttemptAt = const Value.absent(),
  }) => LevelProgressRow(
    levelId: levelId ?? this.levelId,
    status: status ?? this.status,
    examBestScore: examBestScore.present
        ? examBestScore.value
        : this.examBestScore,
    examLastAttemptAt: examLastAttemptAt.present
        ? examLastAttemptAt.value
        : this.examLastAttemptAt,
  );
  LevelProgressRow copyWithCompanion(LevelProgressCompanion data) {
    return LevelProgressRow(
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      status: data.status.present ? data.status.value : this.status,
      examBestScore: data.examBestScore.present
          ? data.examBestScore.value
          : this.examBestScore,
      examLastAttemptAt: data.examLastAttemptAt.present
          ? data.examLastAttemptAt.value
          : this.examLastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelProgressRow(')
          ..write('levelId: $levelId, ')
          ..write('status: $status, ')
          ..write('examBestScore: $examBestScore, ')
          ..write('examLastAttemptAt: $examLastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(levelId, status, examBestScore, examLastAttemptAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelProgressRow &&
          other.levelId == this.levelId &&
          other.status == this.status &&
          other.examBestScore == this.examBestScore &&
          other.examLastAttemptAt == this.examLastAttemptAt);
}

class LevelProgressCompanion extends UpdateCompanion<LevelProgressRow> {
  final Value<int> levelId;
  final Value<String> status;
  final Value<int?> examBestScore;
  final Value<DateTime?> examLastAttemptAt;
  const LevelProgressCompanion({
    this.levelId = const Value.absent(),
    this.status = const Value.absent(),
    this.examBestScore = const Value.absent(),
    this.examLastAttemptAt = const Value.absent(),
  });
  LevelProgressCompanion.insert({
    this.levelId = const Value.absent(),
    this.status = const Value.absent(),
    this.examBestScore = const Value.absent(),
    this.examLastAttemptAt = const Value.absent(),
  });
  static Insertable<LevelProgressRow> custom({
    Expression<int>? levelId,
    Expression<String>? status,
    Expression<int>? examBestScore,
    Expression<DateTime>? examLastAttemptAt,
  }) {
    return RawValuesInsertable({
      if (levelId != null) 'level_id': levelId,
      if (status != null) 'status': status,
      if (examBestScore != null) 'exam_best_score': examBestScore,
      if (examLastAttemptAt != null) 'exam_last_attempt_at': examLastAttemptAt,
    });
  }

  LevelProgressCompanion copyWith({
    Value<int>? levelId,
    Value<String>? status,
    Value<int?>? examBestScore,
    Value<DateTime?>? examLastAttemptAt,
  }) {
    return LevelProgressCompanion(
      levelId: levelId ?? this.levelId,
      status: status ?? this.status,
      examBestScore: examBestScore ?? this.examBestScore,
      examLastAttemptAt: examLastAttemptAt ?? this.examLastAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (levelId.present) {
      map['level_id'] = Variable<int>(levelId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (examBestScore.present) {
      map['exam_best_score'] = Variable<int>(examBestScore.value);
    }
    if (examLastAttemptAt.present) {
      map['exam_last_attempt_at'] = Variable<DateTime>(examLastAttemptAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelProgressCompanion(')
          ..write('levelId: $levelId, ')
          ..write('status: $status, ')
          ..write('examBestScore: $examBestScore, ')
          ..write('examLastAttemptAt: $examLastAttemptAt')
          ..write(')'))
        .toString();
  }
}

class $DailyStatsTable extends DailyStats
    with TableInfo<$DailyStatsTable, DailyStatRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newWordsMeta = const VerificationMeta(
    'newWords',
  );
  @override
  late final GeneratedColumn<int> newWords = GeneratedColumn<int>(
    'new_words',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewsMeta = const VerificationMeta(
    'reviews',
  );
  @override
  late final GeneratedColumn<int> reviews = GeneratedColumn<int>(
    'reviews',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _goalMetMeta = const VerificationMeta(
    'goalMet',
  );
  @override
  late final GeneratedColumn<bool> goalMet = GeneratedColumn<bool>(
    'goal_met',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("goal_met" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    newWords,
    reviews,
    correct,
    xp,
    minutes,
    goalMet,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStatRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('new_words')) {
      context.handle(
        _newWordsMeta,
        newWords.isAcceptableOrUnknown(data['new_words']!, _newWordsMeta),
      );
    }
    if (data.containsKey('reviews')) {
      context.handle(
        _reviewsMeta,
        reviews.isAcceptableOrUnknown(data['reviews']!, _reviewsMeta),
      );
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('goal_met')) {
      context.handle(
        _goalMetMeta,
        goalMet.isAcceptableOrUnknown(data['goal_met']!, _goalMetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DailyStatRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStatRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      newWords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_words'],
      )!,
      reviews: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reviews'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      goalMet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}goal_met'],
      )!,
    );
  }

  @override
  $DailyStatsTable createAlias(String alias) {
    return $DailyStatsTable(attachedDatabase, alias);
  }
}

class DailyStatRow extends DataClass implements Insertable<DailyStatRow> {
  final String day;
  final int newWords;
  final int reviews;
  final int correct;
  final int xp;
  final int minutes;
  final bool goalMet;
  const DailyStatRow({
    required this.day,
    required this.newWords,
    required this.reviews,
    required this.correct,
    required this.xp,
    required this.minutes,
    required this.goalMet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['new_words'] = Variable<int>(newWords);
    map['reviews'] = Variable<int>(reviews);
    map['correct'] = Variable<int>(correct);
    map['xp'] = Variable<int>(xp);
    map['minutes'] = Variable<int>(minutes);
    map['goal_met'] = Variable<bool>(goalMet);
    return map;
  }

  DailyStatsCompanion toCompanion(bool nullToAbsent) {
    return DailyStatsCompanion(
      day: Value(day),
      newWords: Value(newWords),
      reviews: Value(reviews),
      correct: Value(correct),
      xp: Value(xp),
      minutes: Value(minutes),
      goalMet: Value(goalMet),
    );
  }

  factory DailyStatRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStatRow(
      day: serializer.fromJson<String>(json['day']),
      newWords: serializer.fromJson<int>(json['newWords']),
      reviews: serializer.fromJson<int>(json['reviews']),
      correct: serializer.fromJson<int>(json['correct']),
      xp: serializer.fromJson<int>(json['xp']),
      minutes: serializer.fromJson<int>(json['minutes']),
      goalMet: serializer.fromJson<bool>(json['goalMet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'newWords': serializer.toJson<int>(newWords),
      'reviews': serializer.toJson<int>(reviews),
      'correct': serializer.toJson<int>(correct),
      'xp': serializer.toJson<int>(xp),
      'minutes': serializer.toJson<int>(minutes),
      'goalMet': serializer.toJson<bool>(goalMet),
    };
  }

  DailyStatRow copyWith({
    String? day,
    int? newWords,
    int? reviews,
    int? correct,
    int? xp,
    int? minutes,
    bool? goalMet,
  }) => DailyStatRow(
    day: day ?? this.day,
    newWords: newWords ?? this.newWords,
    reviews: reviews ?? this.reviews,
    correct: correct ?? this.correct,
    xp: xp ?? this.xp,
    minutes: minutes ?? this.minutes,
    goalMet: goalMet ?? this.goalMet,
  );
  DailyStatRow copyWithCompanion(DailyStatsCompanion data) {
    return DailyStatRow(
      day: data.day.present ? data.day.value : this.day,
      newWords: data.newWords.present ? data.newWords.value : this.newWords,
      reviews: data.reviews.present ? data.reviews.value : this.reviews,
      correct: data.correct.present ? data.correct.value : this.correct,
      xp: data.xp.present ? data.xp.value : this.xp,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      goalMet: data.goalMet.present ? data.goalMet.value : this.goalMet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatRow(')
          ..write('day: $day, ')
          ..write('newWords: $newWords, ')
          ..write('reviews: $reviews, ')
          ..write('correct: $correct, ')
          ..write('xp: $xp, ')
          ..write('minutes: $minutes, ')
          ..write('goalMet: $goalMet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(day, newWords, reviews, correct, xp, minutes, goalMet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStatRow &&
          other.day == this.day &&
          other.newWords == this.newWords &&
          other.reviews == this.reviews &&
          other.correct == this.correct &&
          other.xp == this.xp &&
          other.minutes == this.minutes &&
          other.goalMet == this.goalMet);
}

class DailyStatsCompanion extends UpdateCompanion<DailyStatRow> {
  final Value<String> day;
  final Value<int> newWords;
  final Value<int> reviews;
  final Value<int> correct;
  final Value<int> xp;
  final Value<int> minutes;
  final Value<bool> goalMet;
  final Value<int> rowid;
  const DailyStatsCompanion({
    this.day = const Value.absent(),
    this.newWords = const Value.absent(),
    this.reviews = const Value.absent(),
    this.correct = const Value.absent(),
    this.xp = const Value.absent(),
    this.minutes = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStatsCompanion.insert({
    required String day,
    this.newWords = const Value.absent(),
    this.reviews = const Value.absent(),
    this.correct = const Value.absent(),
    this.xp = const Value.absent(),
    this.minutes = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day);
  static Insertable<DailyStatRow> custom({
    Expression<String>? day,
    Expression<int>? newWords,
    Expression<int>? reviews,
    Expression<int>? correct,
    Expression<int>? xp,
    Expression<int>? minutes,
    Expression<bool>? goalMet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (newWords != null) 'new_words': newWords,
      if (reviews != null) 'reviews': reviews,
      if (correct != null) 'correct': correct,
      if (xp != null) 'xp': xp,
      if (minutes != null) 'minutes': minutes,
      if (goalMet != null) 'goal_met': goalMet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStatsCompanion copyWith({
    Value<String>? day,
    Value<int>? newWords,
    Value<int>? reviews,
    Value<int>? correct,
    Value<int>? xp,
    Value<int>? minutes,
    Value<bool>? goalMet,
    Value<int>? rowid,
  }) {
    return DailyStatsCompanion(
      day: day ?? this.day,
      newWords: newWords ?? this.newWords,
      reviews: reviews ?? this.reviews,
      correct: correct ?? this.correct,
      xp: xp ?? this.xp,
      minutes: minutes ?? this.minutes,
      goalMet: goalMet ?? this.goalMet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (newWords.present) {
      map['new_words'] = Variable<int>(newWords.value);
    }
    if (reviews.present) {
      map['reviews'] = Variable<int>(reviews.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (goalMet.present) {
      map['goal_met'] = Variable<bool>(goalMet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsCompanion(')
          ..write('day: $day, ')
          ..write('newWords: $newWords, ')
          ..write('reviews: $reviews, ')
          ..write('correct: $correct, ')
          ..write('xp: $xp, ')
          ..write('minutes: $minutes, ')
          ..write('goalMet: $goalMet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _dailyTargetMeta = const VerificationMeta(
    'dailyTarget',
  );
  @override
  late final GeneratedColumn<int> dailyTarget = GeneratedColumn<int>(
    'daily_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _notifyTimeMeta = const VerificationMeta(
    'notifyTime',
  );
  @override
  late final GeneratedColumn<String> notifyTime = GeneratedColumn<String>(
    'notify_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accentMeta = const VerificationMeta('accent');
  @override
  late final GeneratedColumn<String> accent = GeneratedColumn<String>(
    'accent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('us'),
  );
  static const VerificationMeta _currentLevelIdMeta = const VerificationMeta(
    'currentLevelId',
  );
  @override
  late final GeneratedColumn<int> currentLevelId = GeneratedColumn<int>(
    'current_level_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES levels (id)',
    ),
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalXpMeta = const VerificationMeta(
    'totalXp',
  );
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
    'total_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalType,
    dailyTarget,
    notifyTime,
    accent,
    currentLevelId,
    streak,
    longestStreak,
    totalXp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('daily_target')) {
      context.handle(
        _dailyTargetMeta,
        dailyTarget.isAcceptableOrUnknown(
          data['daily_target']!,
          _dailyTargetMeta,
        ),
      );
    }
    if (data.containsKey('notify_time')) {
      context.handle(
        _notifyTimeMeta,
        notifyTime.isAcceptableOrUnknown(data['notify_time']!, _notifyTimeMeta),
      );
    }
    if (data.containsKey('accent')) {
      context.handle(
        _accentMeta,
        accent.isAcceptableOrUnknown(data['accent']!, _accentMeta),
      );
    }
    if (data.containsKey('current_level_id')) {
      context.handle(
        _currentLevelIdMeta,
        currentLevelId.isAcceptableOrUnknown(
          data['current_level_id']!,
          _currentLevelIdMeta,
        ),
      );
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('total_xp')) {
      context.handle(
        _totalXpMeta,
        totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      dailyTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_target'],
      )!,
      notifyTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notify_time'],
      ),
      accent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent'],
      )!,
      currentLevelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_level_id'],
      ),
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      totalXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_xp'],
      )!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileRow extends DataClass implements Insertable<UserProfileRow> {
  final int id;
  final String goalType;
  final int dailyTarget;
  final String? notifyTime;
  final String accent;
  final int? currentLevelId;
  final int streak;
  final int longestStreak;
  final int totalXp;
  const UserProfileRow({
    required this.id,
    required this.goalType,
    required this.dailyTarget,
    this.notifyTime,
    required this.accent,
    this.currentLevelId,
    required this.streak,
    required this.longestStreak,
    required this.totalXp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_type'] = Variable<String>(goalType);
    map['daily_target'] = Variable<int>(dailyTarget);
    if (!nullToAbsent || notifyTime != null) {
      map['notify_time'] = Variable<String>(notifyTime);
    }
    map['accent'] = Variable<String>(accent);
    if (!nullToAbsent || currentLevelId != null) {
      map['current_level_id'] = Variable<int>(currentLevelId);
    }
    map['streak'] = Variable<int>(streak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['total_xp'] = Variable<int>(totalXp);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      goalType: Value(goalType),
      dailyTarget: Value(dailyTarget),
      notifyTime: notifyTime == null && nullToAbsent
          ? const Value.absent()
          : Value(notifyTime),
      accent: Value(accent),
      currentLevelId: currentLevelId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentLevelId),
      streak: Value(streak),
      longestStreak: Value(longestStreak),
      totalXp: Value(totalXp),
    );
  }

  factory UserProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileRow(
      id: serializer.fromJson<int>(json['id']),
      goalType: serializer.fromJson<String>(json['goalType']),
      dailyTarget: serializer.fromJson<int>(json['dailyTarget']),
      notifyTime: serializer.fromJson<String?>(json['notifyTime']),
      accent: serializer.fromJson<String>(json['accent']),
      currentLevelId: serializer.fromJson<int?>(json['currentLevelId']),
      streak: serializer.fromJson<int>(json['streak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalType': serializer.toJson<String>(goalType),
      'dailyTarget': serializer.toJson<int>(dailyTarget),
      'notifyTime': serializer.toJson<String?>(notifyTime),
      'accent': serializer.toJson<String>(accent),
      'currentLevelId': serializer.toJson<int?>(currentLevelId),
      'streak': serializer.toJson<int>(streak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'totalXp': serializer.toJson<int>(totalXp),
    };
  }

  UserProfileRow copyWith({
    int? id,
    String? goalType,
    int? dailyTarget,
    Value<String?> notifyTime = const Value.absent(),
    String? accent,
    Value<int?> currentLevelId = const Value.absent(),
    int? streak,
    int? longestStreak,
    int? totalXp,
  }) => UserProfileRow(
    id: id ?? this.id,
    goalType: goalType ?? this.goalType,
    dailyTarget: dailyTarget ?? this.dailyTarget,
    notifyTime: notifyTime.present ? notifyTime.value : this.notifyTime,
    accent: accent ?? this.accent,
    currentLevelId: currentLevelId.present
        ? currentLevelId.value
        : this.currentLevelId,
    streak: streak ?? this.streak,
    longestStreak: longestStreak ?? this.longestStreak,
    totalXp: totalXp ?? this.totalXp,
  );
  UserProfileRow copyWithCompanion(UserProfileCompanion data) {
    return UserProfileRow(
      id: data.id.present ? data.id.value : this.id,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      dailyTarget: data.dailyTarget.present
          ? data.dailyTarget.value
          : this.dailyTarget,
      notifyTime: data.notifyTime.present
          ? data.notifyTime.value
          : this.notifyTime,
      accent: data.accent.present ? data.accent.value : this.accent,
      currentLevelId: data.currentLevelId.present
          ? data.currentLevelId.value
          : this.currentLevelId,
      streak: data.streak.present ? data.streak.value : this.streak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileRow(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('dailyTarget: $dailyTarget, ')
          ..write('notifyTime: $notifyTime, ')
          ..write('accent: $accent, ')
          ..write('currentLevelId: $currentLevelId, ')
          ..write('streak: $streak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalXp: $totalXp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalType,
    dailyTarget,
    notifyTime,
    accent,
    currentLevelId,
    streak,
    longestStreak,
    totalXp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileRow &&
          other.id == this.id &&
          other.goalType == this.goalType &&
          other.dailyTarget == this.dailyTarget &&
          other.notifyTime == this.notifyTime &&
          other.accent == this.accent &&
          other.currentLevelId == this.currentLevelId &&
          other.streak == this.streak &&
          other.longestStreak == this.longestStreak &&
          other.totalXp == this.totalXp);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileRow> {
  final Value<int> id;
  final Value<String> goalType;
  final Value<int> dailyTarget;
  final Value<String?> notifyTime;
  final Value<String> accent;
  final Value<int?> currentLevelId;
  final Value<int> streak;
  final Value<int> longestStreak;
  final Value<int> totalXp;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.goalType = const Value.absent(),
    this.dailyTarget = const Value.absent(),
    this.notifyTime = const Value.absent(),
    this.accent = const Value.absent(),
    this.currentLevelId = const Value.absent(),
    this.streak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalXp = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    this.goalType = const Value.absent(),
    this.dailyTarget = const Value.absent(),
    this.notifyTime = const Value.absent(),
    this.accent = const Value.absent(),
    this.currentLevelId = const Value.absent(),
    this.streak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalXp = const Value.absent(),
  });
  static Insertable<UserProfileRow> custom({
    Expression<int>? id,
    Expression<String>? goalType,
    Expression<int>? dailyTarget,
    Expression<String>? notifyTime,
    Expression<String>? accent,
    Expression<int>? currentLevelId,
    Expression<int>? streak,
    Expression<int>? longestStreak,
    Expression<int>? totalXp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalType != null) 'goal_type': goalType,
      if (dailyTarget != null) 'daily_target': dailyTarget,
      if (notifyTime != null) 'notify_time': notifyTime,
      if (accent != null) 'accent': accent,
      if (currentLevelId != null) 'current_level_id': currentLevelId,
      if (streak != null) 'streak': streak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (totalXp != null) 'total_xp': totalXp,
    });
  }

  UserProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? goalType,
    Value<int>? dailyTarget,
    Value<String?>? notifyTime,
    Value<String>? accent,
    Value<int?>? currentLevelId,
    Value<int>? streak,
    Value<int>? longestStreak,
    Value<int>? totalXp,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      goalType: goalType ?? this.goalType,
      dailyTarget: dailyTarget ?? this.dailyTarget,
      notifyTime: notifyTime ?? this.notifyTime,
      accent: accent ?? this.accent,
      currentLevelId: currentLevelId ?? this.currentLevelId,
      streak: streak ?? this.streak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalXp: totalXp ?? this.totalXp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (dailyTarget.present) {
      map['daily_target'] = Variable<int>(dailyTarget.value);
    }
    if (notifyTime.present) {
      map['notify_time'] = Variable<String>(notifyTime.value);
    }
    if (accent.present) {
      map['accent'] = Variable<String>(accent.value);
    }
    if (currentLevelId.present) {
      map['current_level_id'] = Variable<int>(currentLevelId.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('dailyTarget: $dailyTarget, ')
          ..write('notifyTime: $notifyTime, ')
          ..write('accent: $accent, ')
          ..write('currentLevelId: $currentLevelId, ')
          ..write('streak: $streak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalXp: $totalXp')
          ..write(')'))
        .toString();
  }
}

class $BadgesTable extends Badges with TableInfo<$BadgesTable, BadgeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<BadgeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BadgeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
    );
  }

  @override
  $BadgesTable createAlias(String alias) {
    return $BadgesTable(attachedDatabase, alias);
  }
}

class BadgeRow extends DataClass implements Insertable<BadgeRow> {
  final int id;
  final String code;
  final DateTime earnedAt;
  const BadgeRow({
    required this.id,
    required this.code,
    required this.earnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    return map;
  }

  BadgesCompanion toCompanion(bool nullToAbsent) {
    return BadgesCompanion(
      id: Value(id),
      code: Value(code),
      earnedAt: Value(earnedAt),
    );
  }

  factory BadgeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgeRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
    };
  }

  BadgeRow copyWith({int? id, String? code, DateTime? earnedAt}) => BadgeRow(
    id: id ?? this.id,
    code: code ?? this.code,
    earnedAt: earnedAt ?? this.earnedAt,
  );
  BadgeRow copyWithCompanion(BadgesCompanion data) {
    return BadgeRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgeRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgeRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.earnedAt == this.earnedAt);
}

class BadgesCompanion extends UpdateCompanion<BadgeRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<DateTime> earnedAt;
  const BadgesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.earnedAt = const Value.absent(),
  });
  BadgesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.earnedAt = const Value.absent(),
  }) : code = Value(code);
  static Insertable<BadgeRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<DateTime>? earnedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (earnedAt != null) 'earned_at': earnedAt,
    });
  }

  BadgesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<DateTime>? earnedAt,
  }) {
    return BadgesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, FavoriteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [wordId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  FavoriteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRow(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class FavoriteRow extends DataClass implements Insertable<FavoriteRow> {
  final int wordId;
  final DateTime createdAt;
  const FavoriteRow({required this.wordId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<int>(wordId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      wordId: Value(wordId),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRow(
      wordId: serializer.fromJson<int>(json['wordId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<int>(wordId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteRow copyWith({int? wordId, DateTime? createdAt}) => FavoriteRow(
    wordId: wordId ?? this.wordId,
    createdAt: createdAt ?? this.createdAt,
  );
  FavoriteRow copyWithCompanion(FavoritesCompanion data) {
    return FavoriteRow(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRow(')
          ..write('wordId: $wordId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRow &&
          other.wordId == this.wordId &&
          other.createdAt == this.createdAt);
}

class FavoritesCompanion extends UpdateCompanion<FavoriteRow> {
  final Value<int> wordId;
  final Value<DateTime> createdAt;
  const FavoritesCompanion({
    this.wordId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.wordId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<FavoriteRow> custom({
    Expression<int>? wordId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoritesCompanion copyWith({
    Value<int>? wordId,
    Value<DateTime>? createdAt,
  }) {
    return FavoritesCompanion(
      wordId: wordId ?? this.wordId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('wordId: $wordId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LevelsTable levels = $LevelsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $ExamplesTable examples = $ExamplesTable(this);
  late final $WordRelationsTable wordRelations = $WordRelationsTable(this);
  late final $ReviewCardsTable reviewCards = $ReviewCardsTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $UnitProgressTable unitProgress = $UnitProgressTable(this);
  late final $LevelProgressTable levelProgress = $LevelProgressTable(this);
  late final $DailyStatsTable dailyStats = $DailyStatsTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final $BadgesTable badges = $BadgesTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    levels,
    units,
    words,
    examples,
    wordRelations,
    reviewCards,
    reviewLogs,
    unitProgress,
    levelProgress,
    dailyStats,
    userProfile,
    badges,
    favorites,
  ];
}

typedef $$LevelsTableCreateCompanionBuilder = LevelsCompanion Function({
  Value<int> id,
  required String code,
  required int sortOrder,
  required String title,
});
typedef $$LevelsTableUpdateCompanionBuilder = LevelsCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<int> sortOrder,
  Value<String> title,
});

final class $$LevelsTableReferences
    extends BaseReferences<_$AppDatabase, $LevelsTable, LevelRow> {
  $$LevelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UnitsTable, List<UnitRow>> _unitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.units,
    aliasName: 'levels__id__units__level_id',
  );

  $$UnitsTableProcessedTableManager get unitsRefs {
    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.levelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LevelProgressTable, List<LevelProgressRow>>
  _levelProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.levelProgress,
    aliasName: 'levels__id__level_progress__level_id',
  );

  $$LevelProgressTableProcessedTableManager get levelProgressRefs {
    final manager = $$LevelProgressTableTableManager(
      $_db,
      $_db.levelProgress,
    ).filter((f) => f.levelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_levelProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserProfileTable, List<UserProfileRow>>
  _userProfileRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userProfile,
    aliasName: 'levels__id__user_profile__current_level_id',
  );

  $$UserProfileTableProcessedTableManager get userProfileRefs {
    final manager = $$UserProfileTableTableManager(
      $_db,
      $_db.userProfile,
    ).filter((f) => f.currentLevelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userProfileRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LevelsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unitsRefs(
    Expression<bool> Function($$UnitsTableFilterComposer f) f,
  ) {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> levelProgressRefs(
    Expression<bool> Function($$LevelProgressTableFilterComposer f) f,
  ) {
    final $$LevelProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levelProgress,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelProgressTableFilterComposer(
            $db: $db,
            $table: $db.levelProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userProfileRefs(
    Expression<bool> Function($$UserProfileTableFilterComposer f) f,
  ) {
    final $$UserProfileTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProfile,
      getReferencedColumn: (t) => t.currentLevelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfileTableFilterComposer(
            $db: $db,
            $table: $db.userProfile,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> unitsRefs<T extends Object>(
    Expression<T> Function($$UnitsTableAnnotationComposer a) f,
  ) {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> levelProgressRefs<T extends Object>(
    Expression<T> Function($$LevelProgressTableAnnotationComposer a) f,
  ) {
    final $$LevelProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levelProgress,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.levelProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userProfileRefs<T extends Object>(
    Expression<T> Function($$UserProfileTableAnnotationComposer a) f,
  ) {
    final $$UserProfileTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProfile,
      getReferencedColumn: (t) => t.currentLevelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfileTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfile,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelsTable,
          LevelRow,
          $$LevelsTableFilterComposer,
          $$LevelsTableOrderingComposer,
          $$LevelsTableAnnotationComposer,
          $$LevelsTableCreateCompanionBuilder,
          $$LevelsTableUpdateCompanionBuilder,
          (LevelRow, $$LevelsTableReferences),
          LevelRow,
          PrefetchHooks Function({
            bool unitsRefs,
            bool levelProgressRefs,
            bool userProfileRefs,
          })
        > {
  $$LevelsTableTableManager(_$AppDatabase db, $LevelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> title = const Value.absent(),
              }) => LevelsCompanion(
                id: id,
                code: code,
                sortOrder: sortOrder,
                title: title,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required int sortOrder,
                required String title,
              }) => LevelsCompanion.insert(
                id: id,
                code: code,
                sortOrder: sortOrder,
                title: title,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelsTable, LevelRow>(table),
                  $$LevelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                unitsRefs = false,
                levelProgressRefs = false,
                userProfileRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (unitsRefs) db.units,
                    if (levelProgressRefs) db.levelProgress,
                    if (userProfileRefs) db.userProfile,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (unitsRefs)
                        await $_getPrefetchedData<
                          LevelRow,
                          $LevelsTable,
                          UnitRow
                        >(
                          currentTable: table,
                          referencedTable: $$LevelsTableReferences
                              ._unitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LevelsTableReferences(db, table, p0).unitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.levelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (levelProgressRefs)
                        await $_getPrefetchedData<
                          LevelRow,
                          $LevelsTable,
                          LevelProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$LevelsTableReferences
                              ._levelProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LevelsTableReferences(
                                db,
                                table,
                                p0,
                              ).levelProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.levelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userProfileRefs)
                        await $_getPrefetchedData<
                          LevelRow,
                          $LevelsTable,
                          UserProfileRow
                        >(
                          currentTable: table,
                          referencedTable: $$LevelsTableReferences
                              ._userProfileRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LevelsTableReferences(
                                db,
                                table,
                                p0,
                              ).userProfileRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.currentLevelId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelsTable,
      LevelRow,
      $$LevelsTableFilterComposer,
      $$LevelsTableOrderingComposer,
      $$LevelsTableAnnotationComposer,
      $$LevelsTableCreateCompanionBuilder,
      $$LevelsTableUpdateCompanionBuilder,
      (LevelRow, $$LevelsTableReferences),
      LevelRow,
      PrefetchHooks Function({
        bool unitsRefs,
        bool levelProgressRefs,
        bool userProfileRefs,
      })
    >;
typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  required int levelId,
  required int sortOrder,
  required String titleTr,
  required String theme,
  Value<String?> icon,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  Value<int> levelId,
  Value<int> sortOrder,
  Value<String> titleTr,
  Value<String> theme,
  Value<String?> icon,
});

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, UnitRow> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LevelsTable _levelIdTable(_$AppDatabase db) =>
      db.levels.createAlias('units__level_id__levels__id');

  $$LevelsTableProcessedTableManager get levelId {
    final $_column = $_itemColumn<int>('level_id')!;

    final manager = $$LevelsTableTableManager(
      $_db,
      $_db.levels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_levelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WordsTable, List<WordRow>> _wordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.words,
    aliasName: 'units__id__words__unit_id',
  );

  $$WordsTableProcessedTableManager get wordsRefs {
    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UnitProgressTable, List<UnitProgressRow>>
  _unitProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.unitProgress,
    aliasName: 'units__id__unit_progress__unit_id',
  );

  $$UnitProgressTableProcessedTableManager get unitProgressRefs {
    final manager = $$UnitProgressTableTableManager(
      $_db,
      $_db.unitProgress,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleTr => $composableBuilder(
    column: $table.titleTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  $$LevelsTableFilterComposer get levelId {
    final $$LevelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableFilterComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> wordsRefs(
    Expression<bool> Function($$WordsTableFilterComposer f) f,
  ) {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> unitProgressRefs(
    Expression<bool> Function($$UnitProgressTableFilterComposer f) f,
  ) {
    final $$UnitProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitProgress,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitProgressTableFilterComposer(
            $db: $db,
            $table: $db.unitProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleTr => $composableBuilder(
    column: $table.titleTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  $$LevelsTableOrderingComposer get levelId {
    final $$LevelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableOrderingComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get titleTr =>
      $composableBuilder(column: $table.titleTr, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  $$LevelsTableAnnotationComposer get levelId {
    final $$LevelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableAnnotationComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> wordsRefs<T extends Object>(
    Expression<T> Function($$WordsTableAnnotationComposer a) f,
  ) {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> unitProgressRefs<T extends Object>(
    Expression<T> Function($$UnitProgressTableAnnotationComposer a) f,
  ) {
    final $$UnitProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitProgress,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.unitProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          UnitRow,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (UnitRow, $$UnitsTableReferences),
          UnitRow,
          PrefetchHooks Function({
            bool levelId,
            bool wordsRefs,
            bool unitProgressRefs,
          })
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> levelId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> titleTr = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String?> icon = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                levelId: levelId,
                sortOrder: sortOrder,
                titleTr: titleTr,
                theme: theme,
                icon: icon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int levelId,
                required int sortOrder,
                required String titleTr,
                required String theme,
                Value<String?> icon = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                levelId: levelId,
                sortOrder: sortOrder,
                titleTr: titleTr,
                theme: theme,
                icon: icon,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UnitsTable, UnitRow>(table),
                  $$UnitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({levelId = false, wordsRefs = false, unitProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (wordsRefs) db.words,
                    if (unitProgressRefs) db.unitProgress,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (levelId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.levelId,
                            referencedTable: $$UnitsTableReferences
                                ._levelIdTable(db),
                            referencedColumn: $$UnitsTableReferences
                                ._levelIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (wordsRefs)
                        await $_getPrefetchedData<
                          UnitRow,
                          $UnitsTable,
                          WordRow
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._wordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(db, table, p0).wordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (unitProgressRefs)
                        await $_getPrefetchedData<
                          UnitRow,
                          $UnitsTable,
                          UnitProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._unitProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).unitProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      UnitRow,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (UnitRow, $$UnitsTableReferences),
      UnitRow,
      PrefetchHooks Function({
        bool levelId,
        bool wordsRefs,
        bool unitProgressRefs,
      })
    >;
typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  required int unitId,
  required String lemma,
  Value<String?> ipa,
  required String pos,
  required String meaningTr,
  Value<int?> frequencyRank,
  Value<String?> imagePath,
  Value<String?> audioPath,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  Value<int> unitId,
  Value<String> lemma,
  Value<String?> ipa,
  Value<String> pos,
  Value<String> meaningTr,
  Value<int?> frequencyRank,
  Value<String?> imagePath,
  Value<String?> audioPath,
});

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, WordRow> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('words__unit_id__units__id');

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExamplesTable, List<ExampleRow>>
  _examplesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examples,
    aliasName: 'words__id__examples__word_id',
  );

  $$ExamplesTableProcessedTableManager get examplesRefs {
    final manager = $$ExamplesTableTableManager(
      $_db,
      $_db.examples,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examplesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WordRelationsTable, List<WordRelationRow>>
  _outgoingRelationsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wordRelations,
    aliasName: 'words__id__word_relations__word_id',
  );

  $$WordRelationsTableProcessedTableManager get outgoingRelations {
    final manager = $$WordRelationsTableTableManager(
      $_db,
      $_db.wordRelations,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_outgoingRelationsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WordRelationsTable, List<WordRelationRow>>
  _incomingRelationsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wordRelations,
    aliasName: 'words__id__word_relations__related_word_id',
  );

  $$WordRelationsTableProcessedTableManager get incomingRelations {
    final manager = $$WordRelationsTableTableManager(
      $_db,
      $_db.wordRelations,
    ).filter((f) => f.relatedWordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomingRelationsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewCardsTable, List<ReviewCardRow>>
  _reviewCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewCards,
    aliasName: 'words__id__review_cards__word_id',
  );

  $$ReviewCardsTableProcessedTableManager get reviewCardsRefs {
    final manager = $$ReviewCardsTableTableManager(
      $_db,
      $_db.reviewCards,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewLogsTable, List<ReviewLogRow>>
  _reviewLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLogs,
    aliasName: 'words__id__review_logs__word_id',
  );

  $$ReviewLogsTableProcessedTableManager get reviewLogsRefs {
    final manager = $$ReviewLogsTableTableManager(
      $_db,
      $_db.reviewLogs,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoritesTable, List<FavoriteRow>>
  _favoritesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favorites,
    aliasName: 'words__id__favorites__word_id',
  );

  $$FavoritesTableProcessedTableManager get favoritesRefs {
    final manager = $$FavoritesTableTableManager(
      $_db,
      $_db.favorites,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoritesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ipa => $composableBuilder(
    column: $table.ipa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningTr => $composableBuilder(
    column: $table.meaningTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> examplesRefs(
    Expression<bool> Function($$ExamplesTableFilterComposer f) f,
  ) {
    final $$ExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableFilterComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> outgoingRelations(
    Expression<bool> Function($$WordRelationsTableFilterComposer f) f,
  ) {
    final $$WordRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordRelations,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordRelationsTableFilterComposer(
            $db: $db,
            $table: $db.wordRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingRelations(
    Expression<bool> Function($$WordRelationsTableFilterComposer f) f,
  ) {
    final $$WordRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordRelations,
      getReferencedColumn: (t) => t.relatedWordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordRelationsTableFilterComposer(
            $db: $db,
            $table: $db.wordRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewCardsRefs(
    Expression<bool> Function($$ReviewCardsTableFilterComposer f) f,
  ) {
    final $$ReviewCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewCards,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewCardsTableFilterComposer(
            $db: $db,
            $table: $db.reviewCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewLogsRefs(
    Expression<bool> Function($$ReviewLogsTableFilterComposer f) f,
  ) {
    final $$ReviewLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableFilterComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoritesRefs(
    Expression<bool> Function($$FavoritesTableFilterComposer f) f,
  ) {
    final $$FavoritesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableFilterComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ipa => $composableBuilder(
    column: $table.ipa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningTr => $composableBuilder(
    column: $table.meaningTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get ipa =>
      $composableBuilder(column: $table.ipa, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<String> get meaningTr =>
      $composableBuilder(column: $table.meaningTr, builder: (column) => column);

  GeneratedColumn<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> examplesRefs<T extends Object>(
    Expression<T> Function($$ExamplesTableAnnotationComposer a) f,
  ) {
    final $$ExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> outgoingRelations<T extends Object>(
    Expression<T> Function($$WordRelationsTableAnnotationComposer a) f,
  ) {
    final $$WordRelationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordRelations,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordRelationsTableAnnotationComposer(
            $db: $db,
            $table: $db.wordRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomingRelations<T extends Object>(
    Expression<T> Function($$WordRelationsTableAnnotationComposer a) f,
  ) {
    final $$WordRelationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordRelations,
      getReferencedColumn: (t) => t.relatedWordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordRelationsTableAnnotationComposer(
            $db: $db,
            $table: $db.wordRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewCardsRefs<T extends Object>(
    Expression<T> Function($$ReviewCardsTableAnnotationComposer a) f,
  ) {
    final $$ReviewCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewCards,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewLogsRefs<T extends Object>(
    Expression<T> Function($$ReviewLogsTableAnnotationComposer a) f,
  ) {
    final $$ReviewLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoritesRefs<T extends Object>(
    Expression<T> Function($$FavoritesTableAnnotationComposer a) f,
  ) {
    final $$FavoritesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableAnnotationComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          WordRow,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (WordRow, $$WordsTableReferences),
          WordRow,
          PrefetchHooks Function({
            bool unitId,
            bool examplesRefs,
            bool outgoingRelations,
            bool incomingRelations,
            bool reviewCardsRefs,
            bool reviewLogsRefs,
            bool favoritesRefs,
          })
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<String> lemma = const Value.absent(),
                Value<String?> ipa = const Value.absent(),
                Value<String> pos = const Value.absent(),
                Value<String> meaningTr = const Value.absent(),
                Value<int?> frequencyRank = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                unitId: unitId,
                lemma: lemma,
                ipa: ipa,
                pos: pos,
                meaningTr: meaningTr,
                frequencyRank: frequencyRank,
                imagePath: imagePath,
                audioPath: audioPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int unitId,
                required String lemma,
                Value<String?> ipa = const Value.absent(),
                required String pos,
                required String meaningTr,
                Value<int?> frequencyRank = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                unitId: unitId,
                lemma: lemma,
                ipa: ipa,
                pos: pos,
                meaningTr: meaningTr,
                frequencyRank: frequencyRank,
                imagePath: imagePath,
                audioPath: audioPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordsTable, WordRow>(table),
                  $$WordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                unitId = false,
                examplesRefs = false,
                outgoingRelations = false,
                incomingRelations = false,
                reviewCardsRefs = false,
                reviewLogsRefs = false,
                favoritesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (examplesRefs) db.examples,
                    if (outgoingRelations) db.wordRelations,
                    if (incomingRelations) db.wordRelations,
                    if (reviewCardsRefs) db.reviewCards,
                    if (reviewLogsRefs) db.reviewLogs,
                    if (favoritesRefs) db.favorites,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (unitId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.unitId,
                            referencedTable: $$WordsTableReferences
                                ._unitIdTable(db),
                            referencedColumn: $$WordsTableReferences
                                ._unitIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (examplesRefs)
                        await $_getPrefetchedData<
                          WordRow,
                          $WordsTable,
                          ExampleRow
                        >(
                          currentTable: table,
                          referencedTable: $$WordsTableReferences
                              ._examplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).examplesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (outgoingRelations)
                        await $_getPrefetchedData<
                          WordRow,
                          $WordsTable,
                          WordRelationRow
                        >(
                          currentTable: table,
                          referencedTable: $$WordsTableReferences
                              ._outgoingRelationsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingRelations,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomingRelations)
                        await $_getPrefetchedData<
                          WordRow,
                          $WordsTable,
                          WordRelationRow
                        >(
                          currentTable: table,
                          referencedTable: $$WordsTableReferences
                              ._incomingRelationsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingRelations,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedWordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewCardsRefs)
                        await $_getPrefetchedData<
                          WordRow,
                          $WordsTable,
                          ReviewCardRow
                        >(
                          currentTable: table,
                          referencedTable: $$WordsTableReferences
                              ._reviewCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewLogsRefs)
                        await $_getPrefetchedData<
                          WordRow,
                          $WordsTable,
                          ReviewLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$WordsTableReferences
                              ._reviewLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoritesRefs)
                        await $_getPrefetchedData<
                          WordRow,
                          $WordsTable,
                          FavoriteRow
                        >(
                          currentTable: table,
                          referencedTable: $$WordsTableReferences
                              ._favoritesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).favoritesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      WordRow,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (WordRow, $$WordsTableReferences),
      WordRow,
      PrefetchHooks Function({
        bool unitId,
        bool examplesRefs,
        bool outgoingRelations,
        bool incomingRelations,
        bool reviewCardsRefs,
        bool reviewLogsRefs,
        bool favoritesRefs,
      })
    >;
typedef $$ExamplesTableCreateCompanionBuilder = ExamplesCompanion Function({
  Value<int> id,
  required int wordId,
  required String sentenceEn,
  required String sentenceTr,
});
typedef $$ExamplesTableUpdateCompanionBuilder = ExamplesCompanion Function({
  Value<int> id,
  Value<int> wordId,
  Value<String> sentenceEn,
  Value<String> sentenceTr,
});

final class $$ExamplesTableReferences
    extends BaseReferences<_$AppDatabase, $ExamplesTable, ExampleRow> {
  $$ExamplesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) =>
      db.words.createAlias('examples__word_id__words__id');

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentenceEn => $composableBuilder(
    column: $table.sentenceEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentenceTr => $composableBuilder(
    column: $table.sentenceTr,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentenceEn => $composableBuilder(
    column: $table.sentenceEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentenceTr => $composableBuilder(
    column: $table.sentenceTr,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sentenceEn => $composableBuilder(
    column: $table.sentenceEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sentenceTr => $composableBuilder(
    column: $table.sentenceTr,
    builder: (column) => column,
  );

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamplesTable,
          ExampleRow,
          $$ExamplesTableFilterComposer,
          $$ExamplesTableOrderingComposer,
          $$ExamplesTableAnnotationComposer,
          $$ExamplesTableCreateCompanionBuilder,
          $$ExamplesTableUpdateCompanionBuilder,
          (ExampleRow, $$ExamplesTableReferences),
          ExampleRow,
          PrefetchHooks Function({bool wordId})
        > {
  $$ExamplesTableTableManager(_$AppDatabase db, $ExamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> sentenceEn = const Value.absent(),
                Value<String> sentenceTr = const Value.absent(),
              }) => ExamplesCompanion(
                id: id,
                wordId: wordId,
                sentenceEn: sentenceEn,
                sentenceTr: sentenceTr,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wordId,
                required String sentenceEn,
                required String sentenceTr,
              }) => ExamplesCompanion.insert(
                id: id,
                wordId: wordId,
                sentenceEn: sentenceEn,
                sentenceTr: sentenceTr,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExamplesTable, ExampleRow>(table),
                  $$ExamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$ExamplesTableReferences._wordIdTable(
                          db,
                        ),
                        referencedColumn: $$ExamplesTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamplesTable,
      ExampleRow,
      $$ExamplesTableFilterComposer,
      $$ExamplesTableOrderingComposer,
      $$ExamplesTableAnnotationComposer,
      $$ExamplesTableCreateCompanionBuilder,
      $$ExamplesTableUpdateCompanionBuilder,
      (ExampleRow, $$ExamplesTableReferences),
      ExampleRow,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$WordRelationsTableCreateCompanionBuilder =
    WordRelationsCompanion Function({
      required int wordId,
      required int relatedWordId,
      required String type,
      Value<int> rowid,
    });
typedef $$WordRelationsTableUpdateCompanionBuilder =
    WordRelationsCompanion Function({
      Value<int> wordId,
      Value<int> relatedWordId,
      Value<String> type,
      Value<int> rowid,
    });

final class $$WordRelationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WordRelationsTable, WordRelationRow> {
  $$WordRelationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WordsTable _wordIdTable(_$AppDatabase db) =>
      db.words.createAlias('word_relations__word_id__words__id');

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WordsTable _relatedWordIdTable(_$AppDatabase db) =>
      db.words.createAlias('word_relations__related_word_id__words__id');

  $$WordsTableProcessedTableManager get relatedWordId {
    final $_column = $_itemColumn<int>('related_word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relatedWordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WordRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $WordRelationsTable> {
  $$WordRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableFilterComposer get relatedWordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordRelationsTable> {
  $$WordRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableOrderingComposer get relatedWordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordRelationsTable> {
  $$WordRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableAnnotationComposer get relatedWordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordRelationsTable,
          WordRelationRow,
          $$WordRelationsTableFilterComposer,
          $$WordRelationsTableOrderingComposer,
          $$WordRelationsTableAnnotationComposer,
          $$WordRelationsTableCreateCompanionBuilder,
          $$WordRelationsTableUpdateCompanionBuilder,
          (WordRelationRow, $$WordRelationsTableReferences),
          WordRelationRow,
          PrefetchHooks Function({bool wordId, bool relatedWordId})
        > {
  $$WordRelationsTableTableManager(_$AppDatabase db, $WordRelationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordRelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> wordId = const Value.absent(),
                Value<int> relatedWordId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordRelationsCompanion(
                wordId: wordId,
                relatedWordId: relatedWordId,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int wordId,
                required int relatedWordId,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => WordRelationsCompanion.insert(
                wordId: wordId,
                relatedWordId: relatedWordId,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordRelationsTable, WordRelationRow>(table),
                  $$WordRelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false, relatedWordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$WordRelationsTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$WordRelationsTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (relatedWordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.relatedWordId,
                        referencedTable: $$WordRelationsTableReferences
                            ._relatedWordIdTable(db),
                        referencedColumn: $$WordRelationsTableReferences
                            ._relatedWordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WordRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordRelationsTable,
      WordRelationRow,
      $$WordRelationsTableFilterComposer,
      $$WordRelationsTableOrderingComposer,
      $$WordRelationsTableAnnotationComposer,
      $$WordRelationsTableCreateCompanionBuilder,
      $$WordRelationsTableUpdateCompanionBuilder,
      (WordRelationRow, $$WordRelationsTableReferences),
      WordRelationRow,
      PrefetchHooks Function({bool wordId, bool relatedWordId})
    >;
typedef $$ReviewCardsTableCreateCompanionBuilder =
    ReviewCardsCompanion Function({
      Value<int> wordId,
      Value<String> state,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<DateTime?> dueAt,
      Value<int> lapses,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime> updatedAt,
    });
typedef $$ReviewCardsTableUpdateCompanionBuilder =
    ReviewCardsCompanion Function({
      Value<int> wordId,
      Value<String> state,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<DateTime?> dueAt,
      Value<int> lapses,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime> updatedAt,
    });

final class $$ReviewCardsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewCardsTable, ReviewCardRow> {
  $$ReviewCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) =>
      db.words.createAlias('review_cards__word_id__words__id');

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewCardsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewCardsTable,
          ReviewCardRow,
          $$ReviewCardsTableFilterComposer,
          $$ReviewCardsTableOrderingComposer,
          $$ReviewCardsTableAnnotationComposer,
          $$ReviewCardsTableCreateCompanionBuilder,
          $$ReviewCardsTableUpdateCompanionBuilder,
          (ReviewCardRow, $$ReviewCardsTableReferences),
          ReviewCardRow,
          PrefetchHooks Function({bool wordId})
        > {
  $$ReviewCardsTableTableManager(_$AppDatabase db, $ReviewCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> wordId = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReviewCardsCompanion(
                wordId: wordId,
                state: state,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                repetitions: repetitions,
                dueAt: dueAt,
                lapses: lapses,
                lastReviewedAt: lastReviewedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> wordId = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReviewCardsCompanion.insert(
                wordId: wordId,
                state: state,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                repetitions: repetitions,
                dueAt: dueAt,
                lapses: lapses,
                lastReviewedAt: lastReviewedAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewCardsTable, ReviewCardRow>(table),
                  $$ReviewCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$ReviewCardsTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$ReviewCardsTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewCardsTable,
      ReviewCardRow,
      $$ReviewCardsTableFilterComposer,
      $$ReviewCardsTableOrderingComposer,
      $$ReviewCardsTableAnnotationComposer,
      $$ReviewCardsTableCreateCompanionBuilder,
      $$ReviewCardsTableUpdateCompanionBuilder,
      (ReviewCardRow, $$ReviewCardsTableReferences),
      ReviewCardRow,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$ReviewLogsTableCreateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  required int wordId,
  required String exerciseType,
  required int quality,
  required int responseMs,
  Value<DateTime> createdAt,
});
typedef $$ReviewLogsTableUpdateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  Value<int> wordId,
  Value<String> exerciseType,
  Value<int> quality,
  Value<int> responseMs,
  Value<DateTime> createdAt,
});

final class $$ReviewLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLogRow> {
  $$ReviewLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) =>
      db.words.createAlias('review_logs__word_id__words__id');

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogsTable,
          ReviewLogRow,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (ReviewLogRow, $$ReviewLogsTableReferences),
          ReviewLogRow,
          PrefetchHooks Function({bool wordId})
        > {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<int> quality = const Value.absent(),
                Value<int> responseMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReviewLogsCompanion(
                id: id,
                wordId: wordId,
                exerciseType: exerciseType,
                quality: quality,
                responseMs: responseMs,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wordId,
                required String exerciseType,
                required int quality,
                required int responseMs,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReviewLogsCompanion.insert(
                id: id,
                wordId: wordId,
                exerciseType: exerciseType,
                quality: quality,
                responseMs: responseMs,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewLogsTable, ReviewLogRow>(table),
                  $$ReviewLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$ReviewLogsTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$ReviewLogsTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogsTable,
      ReviewLogRow,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (ReviewLogRow, $$ReviewLogsTableReferences),
      ReviewLogRow,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$UnitProgressTableCreateCompanionBuilder =
    UnitProgressCompanion Function({
      Value<int> unitId,
      Value<String> status,
      Value<int?> bestScore,
      Value<DateTime?> completedAt,
    });
typedef $$UnitProgressTableUpdateCompanionBuilder =
    UnitProgressCompanion Function({
      Value<int> unitId,
      Value<String> status,
      Value<int?> bestScore,
      Value<DateTime?> completedAt,
    });

final class $$UnitProgressTableReferences
    extends BaseReferences<_$AppDatabase, $UnitProgressTable, UnitProgressRow> {
  $$UnitProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('unit_progress__unit_id__units__id');

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UnitProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UnitProgressTable> {
  $$UnitProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitProgressTable> {
  $$UnitProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitProgressTable> {
  $$UnitProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitProgressTable,
          UnitProgressRow,
          $$UnitProgressTableFilterComposer,
          $$UnitProgressTableOrderingComposer,
          $$UnitProgressTableAnnotationComposer,
          $$UnitProgressTableCreateCompanionBuilder,
          $$UnitProgressTableUpdateCompanionBuilder,
          (UnitProgressRow, $$UnitProgressTableReferences),
          UnitProgressRow,
          PrefetchHooks Function({bool unitId})
        > {
  $$UnitProgressTableTableManager(_$AppDatabase db, $UnitProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> unitId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> bestScore = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => UnitProgressCompanion(
                unitId: unitId,
                status: status,
                bestScore: bestScore,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> unitId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> bestScore = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => UnitProgressCompanion.insert(
                unitId: unitId,
                status: status,
                bestScore: bestScore,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UnitProgressTable, UnitProgressRow>(table),
                  $$UnitProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (unitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.unitId,
                        referencedTable: $$UnitProgressTableReferences
                            ._unitIdTable(db),
                        referencedColumn: $$UnitProgressTableReferences
                            ._unitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UnitProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitProgressTable,
      UnitProgressRow,
      $$UnitProgressTableFilterComposer,
      $$UnitProgressTableOrderingComposer,
      $$UnitProgressTableAnnotationComposer,
      $$UnitProgressTableCreateCompanionBuilder,
      $$UnitProgressTableUpdateCompanionBuilder,
      (UnitProgressRow, $$UnitProgressTableReferences),
      UnitProgressRow,
      PrefetchHooks Function({bool unitId})
    >;
typedef $$LevelProgressTableCreateCompanionBuilder =
    LevelProgressCompanion Function({
      Value<int> levelId,
      Value<String> status,
      Value<int?> examBestScore,
      Value<DateTime?> examLastAttemptAt,
    });
typedef $$LevelProgressTableUpdateCompanionBuilder =
    LevelProgressCompanion Function({
      Value<int> levelId,
      Value<String> status,
      Value<int?> examBestScore,
      Value<DateTime?> examLastAttemptAt,
    });

final class $$LevelProgressTableReferences
    extends
        BaseReferences<_$AppDatabase, $LevelProgressTable, LevelProgressRow> {
  $$LevelProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LevelsTable _levelIdTable(_$AppDatabase db) =>
      db.levels.createAlias('level_progress__level_id__levels__id');

  $$LevelsTableProcessedTableManager get levelId {
    final $_column = $_itemColumn<int>('level_id')!;

    final manager = $$LevelsTableTableManager(
      $_db,
      $_db.levels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_levelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LevelProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LevelProgressTable> {
  $$LevelProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get examBestScore => $composableBuilder(
    column: $table.examBestScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get examLastAttemptAt => $composableBuilder(
    column: $table.examLastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LevelsTableFilterComposer get levelId {
    final $$LevelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableFilterComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelProgressTable> {
  $$LevelProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get examBestScore => $composableBuilder(
    column: $table.examBestScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get examLastAttemptAt => $composableBuilder(
    column: $table.examLastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LevelsTableOrderingComposer get levelId {
    final $$LevelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableOrderingComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelProgressTable> {
  $$LevelProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get examBestScore => $composableBuilder(
    column: $table.examBestScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get examLastAttemptAt => $composableBuilder(
    column: $table.examLastAttemptAt,
    builder: (column) => column,
  );

  $$LevelsTableAnnotationComposer get levelId {
    final $$LevelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableAnnotationComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevelProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelProgressTable,
          LevelProgressRow,
          $$LevelProgressTableFilterComposer,
          $$LevelProgressTableOrderingComposer,
          $$LevelProgressTableAnnotationComposer,
          $$LevelProgressTableCreateCompanionBuilder,
          $$LevelProgressTableUpdateCompanionBuilder,
          (LevelProgressRow, $$LevelProgressTableReferences),
          LevelProgressRow,
          PrefetchHooks Function({bool levelId})
        > {
  $$LevelProgressTableTableManager(_$AppDatabase db, $LevelProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> levelId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> examBestScore = const Value.absent(),
                Value<DateTime?> examLastAttemptAt = const Value.absent(),
              }) => LevelProgressCompanion(
                levelId: levelId,
                status: status,
                examBestScore: examBestScore,
                examLastAttemptAt: examLastAttemptAt,
              ),
          createCompanionCallback:
              ({
                Value<int> levelId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> examBestScore = const Value.absent(),
                Value<DateTime?> examLastAttemptAt = const Value.absent(),
              }) => LevelProgressCompanion.insert(
                levelId: levelId,
                status: status,
                examBestScore: examBestScore,
                examLastAttemptAt: examLastAttemptAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelProgressTable, LevelProgressRow>(table),
                  $$LevelProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({levelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (levelId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.levelId,
                        referencedTable: $$LevelProgressTableReferences
                            ._levelIdTable(db),
                        referencedColumn: $$LevelProgressTableReferences
                            ._levelIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LevelProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelProgressTable,
      LevelProgressRow,
      $$LevelProgressTableFilterComposer,
      $$LevelProgressTableOrderingComposer,
      $$LevelProgressTableAnnotationComposer,
      $$LevelProgressTableCreateCompanionBuilder,
      $$LevelProgressTableUpdateCompanionBuilder,
      (LevelProgressRow, $$LevelProgressTableReferences),
      LevelProgressRow,
      PrefetchHooks Function({bool levelId})
    >;
typedef $$DailyStatsTableCreateCompanionBuilder = DailyStatsCompanion Function({
  required String day,
  Value<int> newWords,
  Value<int> reviews,
  Value<int> correct,
  Value<int> xp,
  Value<int> minutes,
  Value<bool> goalMet,
  Value<int> rowid,
});
typedef $$DailyStatsTableUpdateCompanionBuilder = DailyStatsCompanion Function({
  Value<String> day,
  Value<int> newWords,
  Value<int> reviews,
  Value<int> correct,
  Value<int> xp,
  Value<int> minutes,
  Value<bool> goalMet,
  Value<int> rowid,
});

class $$DailyStatsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newWords => $composableBuilder(
    column: $table.newWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviews => $composableBuilder(
    column: $table.reviews,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newWords => $composableBuilder(
    column: $table.newWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviews => $composableBuilder(
    column: $table.reviews,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get newWords =>
      $composableBuilder(column: $table.newWords, builder: (column) => column);

  GeneratedColumn<int> get reviews =>
      $composableBuilder(column: $table.reviews, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<bool> get goalMet =>
      $composableBuilder(column: $table.goalMet, builder: (column) => column);
}

class $$DailyStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyStatsTable,
          DailyStatRow,
          $$DailyStatsTableFilterComposer,
          $$DailyStatsTableOrderingComposer,
          $$DailyStatsTableAnnotationComposer,
          $$DailyStatsTableCreateCompanionBuilder,
          $$DailyStatsTableUpdateCompanionBuilder,
          (
            DailyStatRow,
            BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStatRow>,
          ),
          DailyStatRow,
          PrefetchHooks Function()
        > {
  $$DailyStatsTableTableManager(_$AppDatabase db, $DailyStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<int> newWords = const Value.absent(),
                Value<int> reviews = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<bool> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion(
                day: day,
                newWords: newWords,
                reviews: reviews,
                correct: correct,
                xp: xp,
                minutes: minutes,
                goalMet: goalMet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                Value<int> newWords = const Value.absent(),
                Value<int> reviews = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<bool> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion.insert(
                day: day,
                newWords: newWords,
                reviews: reviews,
                correct: correct,
                xp: xp,
                minutes: minutes,
                goalMet: goalMet,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyStatsTable, DailyStatRow>(table),
                  BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStatRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyStatsTable,
      DailyStatRow,
      $$DailyStatsTableFilterComposer,
      $$DailyStatsTableOrderingComposer,
      $$DailyStatsTableAnnotationComposer,
      $$DailyStatsTableCreateCompanionBuilder,
      $$DailyStatsTableUpdateCompanionBuilder,
      (
        DailyStatRow,
        BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStatRow>,
      ),
      DailyStatRow,
      PrefetchHooks Function()
    >;
typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<String> goalType,
      Value<int> dailyTarget,
      Value<String?> notifyTime,
      Value<String> accent,
      Value<int?> currentLevelId,
      Value<int> streak,
      Value<int> longestStreak,
      Value<int> totalXp,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<String> goalType,
      Value<int> dailyTarget,
      Value<String?> notifyTime,
      Value<String> accent,
      Value<int?> currentLevelId,
      Value<int> streak,
      Value<int> longestStreak,
      Value<int> totalXp,
    });

final class $$UserProfileTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileRow> {
  $$UserProfileTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LevelsTable _currentLevelIdTable(_$AppDatabase db) =>
      db.levels.createAlias('user_profile__current_level_id__levels__id');

  $$LevelsTableProcessedTableManager? get currentLevelId {
    final $_column = $_itemColumn<int>('current_level_id');
    if ($_column == null) return null;
    final manager = $$LevelsTableTableManager(
      $_db,
      $_db.levels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currentLevelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyTarget => $composableBuilder(
    column: $table.dailyTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notifyTime => $composableBuilder(
    column: $table.notifyTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnFilters(column),
  );

  $$LevelsTableFilterComposer get currentLevelId {
    final $$LevelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currentLevelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableFilterComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyTarget => $composableBuilder(
    column: $table.dailyTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notifyTime => $composableBuilder(
    column: $table.notifyTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnOrderings(column),
  );

  $$LevelsTableOrderingComposer get currentLevelId {
    final $$LevelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currentLevelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableOrderingComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get dailyTarget => $composableBuilder(
    column: $table.dailyTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notifyTime => $composableBuilder(
    column: $table.notifyTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  $$LevelsTableAnnotationComposer get currentLevelId {
    final $$LevelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currentLevelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableAnnotationComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileRow,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (UserProfileRow, $$UserProfileTableReferences),
          UserProfileRow,
          PrefetchHooks Function({bool currentLevelId})
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> dailyTarget = const Value.absent(),
                Value<String?> notifyTime = const Value.absent(),
                Value<String> accent = const Value.absent(),
                Value<int?> currentLevelId = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                goalType: goalType,
                dailyTarget: dailyTarget,
                notifyTime: notifyTime,
                accent: accent,
                currentLevelId: currentLevelId,
                streak: streak,
                longestStreak: longestStreak,
                totalXp: totalXp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> dailyTarget = const Value.absent(),
                Value<String?> notifyTime = const Value.absent(),
                Value<String> accent = const Value.absent(),
                Value<int?> currentLevelId = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
              }) => UserProfileCompanion.insert(
                id: id,
                goalType: goalType,
                dailyTarget: dailyTarget,
                notifyTime: notifyTime,
                accent: accent,
                currentLevelId: currentLevelId,
                streak: streak,
                longestStreak: longestStreak,
                totalXp: totalXp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfileTable, UserProfileRow>(table),
                  $$UserProfileTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({currentLevelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (currentLevelId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.currentLevelId,
                        referencedTable: $$UserProfileTableReferences
                            ._currentLevelIdTable(db),
                        referencedColumn: $$UserProfileTableReferences
                            ._currentLevelIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileRow,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (UserProfileRow, $$UserProfileTableReferences),
      UserProfileRow,
      PrefetchHooks Function({bool currentLevelId})
    >;
typedef $$BadgesTableCreateCompanionBuilder = BadgesCompanion Function({
  Value<int> id,
  required String code,
  Value<DateTime> earnedAt,
});
typedef $$BadgesTableUpdateCompanionBuilder = BadgesCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<DateTime> earnedAt,
});

class $$BadgesTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);
}

class $$BadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTable,
          BadgeRow,
          $$BadgesTableFilterComposer,
          $$BadgesTableOrderingComposer,
          $$BadgesTableAnnotationComposer,
          $$BadgesTableCreateCompanionBuilder,
          $$BadgesTableUpdateCompanionBuilder,
          (BadgeRow, BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow>),
          BadgeRow,
          PrefetchHooks Function()
        > {
  $$BadgesTableTableManager(_$AppDatabase db, $BadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<DateTime> earnedAt = const Value.absent(),
          }) => BadgesCompanion(id: id, code: code, earnedAt: earnedAt),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            Value<DateTime> earnedAt = const Value.absent(),
          }) => BadgesCompanion.insert(id: id, code: code, earnedAt: earnedAt),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BadgesTable, BadgeRow>(table),
                  BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTable,
      BadgeRow,
      $$BadgesTableFilterComposer,
      $$BadgesTableOrderingComposer,
      $$BadgesTableAnnotationComposer,
      $$BadgesTableCreateCompanionBuilder,
      $$BadgesTableUpdateCompanionBuilder,
      (BadgeRow, BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow>),
      BadgeRow,
      PrefetchHooks Function()
    >;
typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  Value<int> wordId,
  Value<DateTime> createdAt,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<int> wordId,
  Value<DateTime> createdAt,
});

final class $$FavoritesTableReferences
    extends BaseReferences<_$AppDatabase, $FavoritesTable, FavoriteRow> {
  $$FavoritesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) =>
      db.words.createAlias('favorites__word_id__words__id');

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          FavoriteRow,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (FavoriteRow, $$FavoritesTableReferences),
          FavoriteRow,
          PrefetchHooks Function({bool wordId})
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> wordId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) => FavoritesCompanion(wordId: wordId, createdAt: createdAt),
          createCompanionCallback: ({
            Value<int> wordId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) => FavoritesCompanion.insert(wordId: wordId, createdAt: createdAt),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoritesTable, FavoriteRow>(table),
                  $$FavoritesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$FavoritesTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$FavoritesTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      FavoriteRow,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (FavoriteRow, $$FavoritesTableReferences),
      FavoriteRow,
      PrefetchHooks Function({bool wordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LevelsTableTableManager get levels =>
      $$LevelsTableTableManager(_db, _db.levels);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$ExamplesTableTableManager get examples =>
      $$ExamplesTableTableManager(_db, _db.examples);
  $$WordRelationsTableTableManager get wordRelations =>
      $$WordRelationsTableTableManager(_db, _db.wordRelations);
  $$ReviewCardsTableTableManager get reviewCards =>
      $$ReviewCardsTableTableManager(_db, _db.reviewCards);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$UnitProgressTableTableManager get unitProgress =>
      $$UnitProgressTableTableManager(_db, _db.unitProgress);
  $$LevelProgressTableTableManager get levelProgress =>
      $$LevelProgressTableTableManager(_db, _db.levelProgress);
  $$DailyStatsTableTableManager get dailyStats =>
      $$DailyStatsTableTableManager(_db, _db.dailyStats);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$BadgesTableTableManager get badges =>
      $$BadgesTableTableManager(_db, _db.badges);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
}
