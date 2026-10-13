import 'package:drift/drift.dart';

// SRS 5.3 veri modeli. İçerik tabloları: levels, units, words, examples,
// word_relations. Diğerleri kullanıcı ilerleme tablolarıdır.

@DataClassName('LevelRow')
class Levels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 2, max: 2).unique()();
  IntColumn get sortOrder => integer()();
  TextColumn get title => text()();
}

@DataClassName('UnitRow')
class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get levelId => integer().references(Levels, #id)();
  IntColumn get sortOrder => integer()();
  TextColumn get titleTr => text()();
  TextColumn get theme => text()();
  TextColumn get icon => text().nullable()();
}

@DataClassName('WordRow')
class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId => integer().references(Units, #id)();
  TextColumn get lemma => text()();
  TextColumn get ipa => text().nullable()();
  TextColumn get pos => text()();
  TextColumn get meaningTr => text()();
  IntColumn get frequencyRank => integer().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get audioPath => text().nullable()();
}

@DataClassName('ExampleRow')
class Examples extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId => integer().references(Words, #id)();
  TextColumn get sentenceEn => text()();
  TextColumn get sentenceTr => text()();
}

/// type: synonym, antonym veya family.
@DataClassName('WordRelationRow')
class WordRelations extends Table {
  @ReferenceName('outgoingRelations')
  IntColumn get wordId => integer().references(Words, #id)();
  @ReferenceName('incomingRelations')
  IntColumn get relatedWordId => integer().references(Words, #id)();
  TextColumn get type => text()();

  @override
  Set<Column<Object>> get primaryKey => {wordId, relatedWordId, type};
}

/// state: new, learning, review, mastered (FR-63).
@DataClassName('ReviewCardRow')
class ReviewCards extends Table {
  IntColumn get wordId => integer().references(Words, #id)();
  TextColumn get state => text().withDefault(const Constant('new'))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime().nullable()();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {wordId};
}

@DataClassName('ReviewLogRow')
class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId => integer().references(Words, #id)();
  TextColumn get exerciseType => text()();
  IntColumn get quality => integer()();
  IntColumn get responseMs => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// status: locked, open, completed.
@DataClassName('UnitProgressRow')
class UnitProgress extends Table {
  IntColumn get unitId => integer().references(Units, #id)();
  TextColumn get status => text().withDefault(const Constant('locked'))();
  IntColumn get bestScore => integer().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {unitId};
}

@DataClassName('LevelProgressRow')
class LevelProgress extends Table {
  IntColumn get levelId => integer().references(Levels, #id)();
  TextColumn get status => text().withDefault(const Constant('locked'))();
  IntColumn get examBestScore => integer().nullable()();
  DateTimeColumn get examLastAttemptAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {levelId};
}

/// day: yyyy-MM-dd biçiminde yerel tarih.
@DataClassName('DailyStatRow')
class DailyStats extends Table {
  TextColumn get day => text()();
  IntColumn get newWords => integer().withDefault(const Constant(0))();
  IntColumn get reviews => integer().withDefault(const Constant(0))();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  BoolColumn get goalMet => boolean().withDefault(const Constant(false))();

  /// Şema 5: gün seri koruması harcanarak kurtarıldı (FR-72).
  BoolColumn get frozen => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {day};
}

/// Tek satırlık kullanıcı profili (id her zaman 1).
@DataClassName('UserProfileRow')
class UserProfile extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get goalType => text().withDefault(const Constant('general'))();
  IntColumn get dailyTarget => integer().withDefault(const Constant(10))();
  TextColumn get notifyTime => text().nullable()();
  TextColumn get accent => text().withDefault(const Constant('us'))();
  IntColumn get currentLevelId =>
      integer().nullable().references(Levels, #id)();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();

  // Şema 3: tanıtım ve ayarlar (FR-01..05, FR-120..122).
  BoolColumn get onboardingDone =>
      boolean().withDefault(const Constant(false))();

  /// system, light veya dark.
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  RealColumn get speechRate => real().withDefault(const Constant(0.5))();
  BoolColumn get soundEffects => boolean().withDefault(const Constant(true))();
  BoolColumn get haptics => boolean().withDefault(const Constant(true))();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get streakWarningEnabled =>
      boolean().withDefault(const Constant(true))();

  // Şema 4: sessiz saatler (FR-102).
  BoolColumn get quietHoursEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get quietStart => text().withDefault(const Constant('22:00'))();
  TextColumn get quietEnd => text().withDefault(const Constant('08:00'))();

  // Şema 5: seri koruması (FR-72).
  IntColumn get streakFreezes => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('BadgeRow')
class Badges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  DateTimeColumn get earnedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Favori kelimeler (FR-35).
@DataClassName('FavoriteRow')
class Favorites extends Table {
  IntColumn get wordId => integer().references(Words, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {wordId};
}

/// Kullanıcının kelimeye eklediği kişisel not (FR-36). Şema 5.
@DataClassName('WordNoteRow')
class WordNotes extends Table {
  IntColumn get wordId => integer().references(Words, #id)();
  TextColumn get note => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {wordId};
}

/// Kullanıcının oluşturduğu kelime listesi (FR-91). Şema 6.
@DataClassName('WordListRow')
class WordLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Listedeki kelimeler (FR-91). Şema 6.
@DataClassName('WordListItemRow')
class WordListItems extends Table {
  IntColumn get listId =>
      integer().references(WordLists, #id, onDelete: KeyAction.cascade)();
  IntColumn get wordId => integer().references(Words, #id)();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {listId, wordId};
}
