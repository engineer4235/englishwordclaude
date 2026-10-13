import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Öğrenme amacı (FR-02).
enum LearningGoal {
  general('general'),
  travel('travel'),
  work('work'),
  exam('exam');

  const LearningGoal(this.dbValue);

  final String dbValue;

  static LearningGoal fromDb(String? value) => LearningGoal.values.firstWhere(
    (g) => g.dbValue == value,
    orElse: () => LearningGoal.general,
  );
}

/// Tek satırlık kullanıcı profili ve ayarları (FR-01..05, FR-120..123).
class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  /// Günlük yeni kelime hedefi seçenekleri (FR-03).
  static const dailyTargetOptions = [5, 10, 15, 20];

  Future<UserProfileRow> get() async {
    return _db.ensureProfile();
  }

  /// Verilen alanları günceller; profil yoksa önce oluşturur.
  Future<UserProfileRow> update(UserProfileCompanion changes) async {
    await get();
    await _db.update(_db.userProfile).write(changes);
    return get();
  }

  /// Tanıtımda yapılan seçimler (FR-02..04).
  Future<void> saveOnboardingChoices({
    required LearningGoal goal,
    required int dailyTarget,
    required String? notifyTime,
  }) {
    return update(
      UserProfileCompanion(
        goalType: Value(goal.dbValue),
        dailyTarget: Value(dailyTarget),
        notifyTime: Value(notifyTime),
        reminderEnabled: Value(notifyTime != null),
      ),
    );
  }

  Future<void> completeOnboarding() =>
      update(const UserProfileCompanion(onboardingDone: Value(true)));
}
