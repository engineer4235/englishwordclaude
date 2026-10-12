import 'dart:io';

import 'package:drift/native.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/review_repository.dart';
import 'package:english_word_learning/domain/srs/card_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late ReviewRepository repo;
  late int wordId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await ContentSeeder(
      db,
    ).seedIfEmpty(File('assets/content/seed_content.json').readAsStringSync());
    wordId = (await db.select(db.words).get()).first.id;
    now = DateTime(2026, 10, 13, 9);
    repo = ReviewRepository(db, clock: () => now);
  });

  tearDown(() => db.close());

  test('yeni kelimenin durumu başlangıç durumudur', () async {
    final s = await repo.getState(wordId);
    expect(s.state, CardState.newCard);
    expect(s.repetitions, 0);
  });

  test('cevap kaydedilir ve günlüğe yazılır', () async {
    await repo.recordAnswer(
      wordId: wordId,
      quality: 5,
      exerciseType: 'mc_en_tr',
      responseMs: 1200,
    );
    final s = await repo.getState(wordId);
    expect(s.repetitions, 1);
    expect(s.state, CardState.learning);
    expect(await db.select(db.reviewLogs).get(), hasLength(1));
  });

  test(
    'doğru cevapta tarih ileri, yanlışta 1 gün sonraya alınır (kabul 4)',
    () async {
      await repo.recordAnswer(
        wordId: wordId,
        quality: 5,
        exerciseType: 'x',
        responseMs: 1,
      );
      await repo.recordAnswer(
        wordId: wordId,
        quality: 5,
        exerciseType: 'x',
        responseMs: 1,
      );
      var s = await repo.getState(wordId);
      expect(s.dueAt!.difference(now).inDays, 6);

      s = await repo.recordAnswer(
        wordId: wordId,
        quality: 1,
        exerciseType: 'x',
        responseMs: 1,
      );
      expect((await repo.getState(wordId)).dueAt!.difference(now).inDays, 1);
    },
  );

  test('"biliyorum" kelimeyi 21 gün sonraya alır (FR-34)', () async {
    await repo.markKnown(wordId);
    final s = await repo.getState(wordId);
    expect(s.state, CardState.mastered);
    expect(s.dueAt!.difference(now).inDays, 21);
  });

  test('zamanı gelen tekrarlar sayılır (FR-64)', () async {
    await repo.recordAnswer(
      wordId: wordId,
      quality: 5,
      exerciseType: 'x',
      responseMs: 1,
    );
    expect(await repo.countDue(), 0);

    now = now.add(const Duration(days: 2));
    expect(await repo.countDue(), 1);
    expect(await repo.dueWordIds(), [wordId]);
  });
}
