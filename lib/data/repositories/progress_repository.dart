import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../../domain/models/level.dart';
import '../../domain/models/progress.dart';
import '../db/app_database.dart';
import 'review_repository.dart';

/// Seviye ve ünite ilerlemesi, kilit açma kuralları (FR-22..FR-25).
class ProgressRepository {
  ProgressRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Bir sonraki üniteyi açmak için gereken mini sınav puanı (FR-22).
  static const unitPassScore = 70;

  /// Seviye atlama sınavı geçme puanı (FR-23).
  static const levelPassScore = 80;

  /// Başarısız seviye sınavından sonra bekleme süresi (FR-24).
  static const examRetryDelay = Duration(hours: 24);

  /// Tüm seviyeler, üniteleri ve ilerleme durumları.
  Future<List<LevelOverview>> overview() async {
    final levels = await (_db.select(
      _db.levels,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final units = await (_db.select(
      _db.units,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final unitProgress = {
      for (final r in await _db.select(_db.unitProgress).get()) r.unitId: r,
    };
    final levelProgress = {
      for (final r in await _db.select(_db.levelProgress).get()) r.levelId: r,
    };
    final learned = {
      for (final r in await (_db.select(
        _db.reviewCards,
      )..where((t) => t.state.isIn(['review', 'mastered']))).get())
        r.wordId,
    };
    final wordCount = <int, int>{};
    final learnedCount = <int, int>{};
    for (final w in await _db.select(_db.words).get()) {
      wordCount[w.unitId] = (wordCount[w.unitId] ?? 0) + 1;
      if (learned.contains(w.id)) {
        learnedCount[w.unitId] = (learnedCount[w.unitId] ?? 0) + 1;
      }
    }

    return [
      for (final l in levels)
        LevelOverview(
          level: Level(
            id: l.id,
            code: l.code,
            sortOrder: l.sortOrder,
            title: l.title,
          ),
          status: ProgressStatus.fromDb(levelProgress[l.id]?.status),
          examBestScore: levelProgress[l.id]?.examBestScore,
          units: [
            for (final u in units.where((u) => u.levelId == l.id))
              UnitOverview(
                id: u.id,
                levelId: u.levelId,
                sortOrder: u.sortOrder,
                title: u.titleTr,
                status: ProgressStatus.fromDb(unitProgress[u.id]?.status),
                bestScore: unitProgress[u.id]?.bestScore,
                wordCount: wordCount[u.id] ?? 0,
                learnedCount: learnedCount[u.id] ?? 0,
              ),
          ],
        ),
    ];
  }

  /// Ünite mini sınavı sonucunu kaydeder. %70 ve üzeri ünite tamamlanır ve
  /// sıradaki ünite açılır (FR-22). Geçtiyse `true` döner.
  Future<bool> recordUnitExam(int unitId, int scorePercent) {
    return _db.transaction(() async {
      final unit = await (_db.select(
        _db.units,
      )..where((t) => t.id.equals(unitId))).getSingle();
      final current = await (_db.select(
        _db.unitProgress,
      )..where((t) => t.unitId.equals(unitId))).getSingleOrNull();
      final passed = scorePercent >= unitPassScore;
      final wasCompleted = current?.status == ProgressStatus.completed.dbValue;
      final status = passed || wasCompleted
          ? ProgressStatus.completed
          : ProgressStatus.open;

      await _db
          .into(_db.unitProgress)
          .insertOnConflictUpdate(
            UnitProgressCompanion.insert(
              unitId: Value(unitId),
              status: Value(status.dbValue),
              bestScore: Value(math.max(current?.bestScore ?? 0, scorePercent)),
              completedAt: Value(
                passed && !wasCompleted ? _clock() : current?.completedAt,
              ),
            ),
          );

      if (passed) {
        final next =
            await (_db.select(_db.units)
                  ..where(
                    (t) =>
                        t.levelId.equals(unit.levelId) &
                        t.sortOrder.isBiggerThanValue(unit.sortOrder),
                  )
                  ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
                  ..limit(1))
                .getSingleOrNull();
        if (next != null) await _openUnit(next.id);
      }
      return passed;
    });
  }

  /// Seviye atlama sınavına girme koşulları (FR-23, FR-24).
  Future<LevelExamEligibility> levelExamEligibility(int levelId) async {
    final level = (await overview()).firstWhere((l) => l.level.id == levelId);
    final progress = await (_db.select(
      _db.levelProgress,
    )..where((t) => t.levelId.equals(levelId))).getSingleOrNull();

    DateTime? retryAt;
    final lastAttempt = progress?.examLastAttemptAt;
    if (lastAttempt != null &&
        (progress?.examBestScore ?? 0) < levelPassScore) {
      final at = lastAttempt.add(examRetryDelay);
      if (at.isAfter(_clock())) retryAt = at;
    }

    return LevelExamEligibility(
      allUnitsCompleted: level.allUnitsCompleted,
      learnedRatio: level.progress,
      retryAvailableAt: retryAt,
    );
  }

  /// Seviye atlama sınavı sonucunu kaydeder. %80 ve üzeri seviyeyi tamamlar,
  /// sonraki seviyeyi ve ilk ünitesini açar (FR-23). Geçtiyse `true` döner.
  Future<bool> recordLevelExam(int levelId, int scorePercent) {
    return _db.transaction(() async {
      final current = await (_db.select(
        _db.levelProgress,
      )..where((t) => t.levelId.equals(levelId))).getSingleOrNull();
      final passed = scorePercent >= levelPassScore;
      final wasCompleted = current?.status == ProgressStatus.completed.dbValue;

      await _db
          .into(_db.levelProgress)
          .insertOnConflictUpdate(
            LevelProgressCompanion.insert(
              levelId: Value(levelId),
              status: Value(
                (passed || wasCompleted
                        ? ProgressStatus.completed
                        : ProgressStatus.open)
                    .dbValue,
              ),
              examBestScore: Value(
                math.max(current?.examBestScore ?? 0, scorePercent),
              ),
              examLastAttemptAt: Value(_clock()),
            ),
          );

      if (passed) {
        final level = await (_db.select(
          _db.levels,
        )..where((t) => t.id.equals(levelId))).getSingle();
        final next =
            await (_db.select(_db.levels)
                  ..where((t) => t.sortOrder.isBiggerThanValue(level.sortOrder))
                  ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
                  ..limit(1))
                .getSingleOrNull();
        if (next != null) {
          final nextProgress = await (_db.select(
            _db.levelProgress,
          )..where((t) => t.levelId.equals(next.id))).getSingleOrNull();
          if (nextProgress == null) {
            await _db
                .into(_db.levelProgress)
                .insert(
                  LevelProgressCompanion.insert(
                    levelId: Value(next.id),
                    status: Value(ProgressStatus.open.dbValue),
                  ),
                );
          }
          final firstUnit =
              await (_db.select(_db.units)
                    ..where((t) => t.levelId.equals(next.id))
                    ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
                    ..limit(1))
                  .getSingleOrNull();
          if (firstUnit != null) await _openUnit(firstUnit.id);
        }
      }
      return passed;
    });
  }

  /// Seviye tespit sonucunu uygular (FR-12, FR-13): alt seviyeler ve
  /// üniteleri tamamlanmış sayılır, kelimeleri "biliniyor" olarak ara sıra
  /// kontrol tekrarına alınır. Seçilen seviye ve ilk ünitesi açılır.
  Future<void> applyPlacement(int levelId) {
    return _db.transaction(() async {
      final target = await (_db.select(
        _db.levels,
      )..where((t) => t.id.equals(levelId))).getSingle();
      final lower = await (_db.select(
        _db.levels,
      )..where((t) => t.sortOrder.isSmallerThanValue(target.sortOrder))).get();
      final reviews = ReviewRepository(_db, clock: _clock);
      final known = {
        for (final r in await _db.select(_db.reviewCards).get()) r.wordId,
      };

      for (final level in lower) {
        await _db
            .into(_db.levelProgress)
            .insertOnConflictUpdate(
              LevelProgressCompanion.insert(
                levelId: Value(level.id),
                status: Value(ProgressStatus.completed.dbValue),
              ),
            );
        final units = await (_db.select(
          _db.units,
        )..where((t) => t.levelId.equals(level.id))).get();
        for (final unit in units) {
          await _db
              .into(_db.unitProgress)
              .insertOnConflictUpdate(
                UnitProgressCompanion.insert(
                  unitId: Value(unit.id),
                  status: Value(ProgressStatus.completed.dbValue),
                  completedAt: Value(_clock()),
                ),
              );
          final words = await (_db.select(
            _db.words,
          )..where((t) => t.unitId.equals(unit.id))).get();
          for (final word in words) {
            if (!known.contains(word.id)) await reviews.markKnown(word.id);
          }
        }
      }

      final targetProgress = await (_db.select(
        _db.levelProgress,
      )..where((t) => t.levelId.equals(levelId))).getSingleOrNull();
      if (targetProgress == null ||
          targetProgress.status == ProgressStatus.locked.dbValue) {
        await _db
            .into(_db.levelProgress)
            .insertOnConflictUpdate(
              LevelProgressCompanion.insert(
                levelId: Value(levelId),
                status: Value(ProgressStatus.open.dbValue),
              ),
            );
      }
      final firstUnit =
          await (_db.select(_db.units)
                ..where((t) => t.levelId.equals(levelId))
                ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      if (firstUnit != null) await _openUnit(firstUnit.id);

      await _db.ensureProfile();
      await _db
          .update(_db.userProfile)
          .write(UserProfileCompanion(currentLevelId: Value(levelId)));
    });
  }

  /// Tüm öğrenme ilerlemesini siler (FR-123). Ayarlar, tanıtım durumu ve
  /// favoriler korunur; ilk seviye ve ilk ünitesi yeniden açılır.
  Future<void> resetProgress() {
    return _db.transaction(() async {
      await _db.delete(_db.reviewLogs).go();
      await _db.delete(_db.reviewCards).go();
      await _db.delete(_db.unitProgress).go();
      await _db.delete(_db.levelProgress).go();
      await _db.delete(_db.dailyStats).go();
      await _db.delete(_db.badges).go();

      final first =
          await (_db.select(_db.levels)
                ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
                ..limit(1))
              .getSingleOrNull();
      if (first != null) {
        await _db
            .into(_db.levelProgress)
            .insert(
              LevelProgressCompanion.insert(
                levelId: Value(first.id),
                status: Value(ProgressStatus.open.dbValue),
              ),
            );
        final firstUnit =
            await (_db.select(_db.units)
                  ..where((t) => t.levelId.equals(first.id))
                  ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
                  ..limit(1))
                .getSingleOrNull();
        if (firstUnit != null) await _openUnit(firstUnit.id);
      }

      await _db.ensureProfile();
      await _db
          .update(_db.userProfile)
          .write(
            const UserProfileCompanion(
              streak: Value(0),
              longestStreak: Value(0),
              totalXp: Value(0),
              currentLevelId: Value(null),
            ),
          );
    });
  }

  Future<void> _openUnit(int unitId) async {
    final existing = await (_db.select(
      _db.unitProgress,
    )..where((t) => t.unitId.equals(unitId))).getSingleOrNull();
    if (existing == null) {
      await _db
          .into(_db.unitProgress)
          .insert(
            UnitProgressCompanion.insert(
              unitId: Value(unitId),
              status: Value(ProgressStatus.open.dbValue),
            ),
          );
    } else if (existing.status == ProgressStatus.locked.dbValue) {
      await (_db.update(
        _db.unitProgress,
      )..where((t) => t.unitId.equals(unitId))).write(
        UnitProgressCompanion(status: Value(ProgressStatus.open.dbValue)),
      );
    }
  }
}
