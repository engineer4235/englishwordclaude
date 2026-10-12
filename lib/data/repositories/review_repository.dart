import 'package:drift/drift.dart';

import '../../domain/srs/card_state.dart';
import '../../domain/srs/review_state.dart';
import '../../domain/srs/spaced_repetition_scheduler.dart';
import '../db/app_database.dart';

/// Kelime kartlarının tekrar durumunu okur ve günceller (FR-60..FR-64).
class ReviewRepository {
  ReviewRepository(
    this._db, {
    this.scheduler = const Sm2Scheduler(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final SpacedRepetitionScheduler scheduler;
  final DateTime Function() _clock;

  Future<ReviewState> getState(int wordId) async {
    final row = await (_db.select(
      _db.reviewCards,
    )..where((t) => t.wordId.equals(wordId))).getSingleOrNull();
    return row == null ? ReviewState.initial : _toState(row);
  }

  /// Cevabı kaydeder, yeni durumu hesaplar ve günlüğe yazar. Her cevap anında
  /// veritabanına yazılır (NFR-05).
  Future<ReviewState> recordAnswer({
    required int wordId,
    required int quality,
    required String exerciseType,
    required int responseMs,
  }) {
    return _db.transaction(() async {
      final now = _clock();
      final next = scheduler.schedule(await getState(wordId), quality, now);
      await _save(wordId, next, now);
      await _db
          .into(_db.reviewLogs)
          .insert(
            ReviewLogsCompanion.insert(
              wordId: wordId,
              exerciseType: exerciseType,
              quality: quality,
              responseMs: responseMs,
              createdAt: Value(now),
            ),
          );
      return next;
    });
  }

  /// "Bunu zaten biliyorum": kelimeyi doğrudan uzun aralıklı tekrara alır (FR-34).
  Future<ReviewState> markKnown(int wordId) async {
    final now = _clock();
    final current = await getState(wordId);
    final next = ReviewState(
      state: CardState.mastered,
      easeFactor: current.easeFactor,
      intervalDays: 21,
      repetitions: 3,
      lapses: current.lapses,
      dueAt: now.add(const Duration(days: 21)),
    );
    await _save(wordId, next, now);
    return next;
  }

  /// Bugün tekrar zamanı gelmiş kart sayısı (FR-64).
  Future<int> countDue() async {
    final count = _db.reviewCards.wordId.count();
    final query = _db.selectOnly(_db.reviewCards)
      ..addColumns([count])
      ..where(_db.reviewCards.dueAt.isSmallerOrEqualValue(_clock()));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  /// Tekrar zamanı gelmiş kelimeler, en eski önce.
  Future<List<int>> dueWordIds({int limit = 100}) async {
    final query = _db.select(_db.reviewCards)
      ..where((t) => t.dueAt.isSmallerOrEqualValue(_clock()))
      ..orderBy([(t) => OrderingTerm.asc(t.dueAt)])
      ..limit(limit);
    return [for (final r in await query.get()) r.wordId];
  }

  Future<void> _save(int wordId, ReviewState s, DateTime now) {
    return _db
        .into(_db.reviewCards)
        .insertOnConflictUpdate(
          ReviewCardsCompanion.insert(
            wordId: Value(wordId),
            state: Value(s.state.dbValue),
            easeFactor: Value(s.easeFactor),
            intervalDays: Value(s.intervalDays),
            repetitions: Value(s.repetitions),
            lapses: Value(s.lapses),
            dueAt: Value(s.dueAt),
            lastReviewedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  ReviewState _toState(ReviewCardRow r) => ReviewState(
    state: CardState.fromDb(r.state),
    easeFactor: r.easeFactor,
    intervalDays: r.intervalDays,
    repetitions: r.repetitions,
    lapses: r.lapses,
    dueAt: r.dueAt,
  );
}
