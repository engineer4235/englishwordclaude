import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/favorites_repository.dart';
import 'package:english_word_learning/data/repositories/notes_repository.dart';
import 'package:english_word_learning/data/repositories/profile_repository.dart';
import 'package:english_word_learning/data/repositories/progress_repository.dart';
import 'package:english_word_learning/data/repositories/study_repository.dart';
import 'package:english_word_learning/domain/models/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// NFR-05: Uygulama beklenmedik şekilde kapanırsa ilerleme kaybolmaz; her
/// cevap anında yerel veritabanına yazılır.
void main() {
  test('kapatılıp yeniden açılan veritabanında ilerleme durur', () async {
    final dir = Directory.systemTemp.createTempSync('ewl_nfr05_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/app.sqlite');

    var db = AppDatabase(NativeDatabase(file));
    await ContentSeeder(db).seedIfEmpty(seedJson);
    final words = await db.select(db.words).get();
    final study = StudyRepository(db);
    final xp = await study.recordAnswer(
      wordId: words[0].id,
      quality: 5,
      correct: true,
      exerciseType: 'mc_en_tr',
      responseMs: 1200,
    );
    await study.addStudyTime(const Duration(minutes: 3));
    await FavoritesRepository(db).toggle(words[1].id);
    await NotesRepository(db).save(words[1].id, 'not');
    final progress = ProgressRepository(db);
    final firstUnit = (await progress.overview()).first.units.first;
    await progress.recordUnitExam(firstUnit.id, 100);
    await ProfileRepository(db)
        .update(const UserProfileCompanion(dailyTarget: Value(20)));
    // Kapanış: bağlantı kesilir, bellekte hiçbir şey kalmaz.
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    final cards = await db.select(db.reviewCards).get();
    expect(cards.map((c) => c.wordId), [words[0].id]);
    expect(await db.select(db.reviewLogs).get(), hasLength(1));
    final today = await db.select(db.dailyStats).getSingle();
    expect(today.newWords, 1);
    expect(today.xp, xp);
    expect(today.minutes, 3);
    expect((await db.select(db.favorites).getSingle()).wordId, words[1].id);
    expect((await db.select(db.wordNotes).getSingle()).note, 'not');
    final units = (await ProgressRepository(db).overview()).first.units;
    expect(units.first.status, ProgressStatus.completed);
    expect(units[1].status, ProgressStatus.open);
    expect((await db.ensureProfile()).dailyTarget, 20);
  });

  testWidgets('oturum yarıda kalsa da verilen cevap kayıtlıdır', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    addTearDown(db.close);

    await tester.pumpWidget(testApp(db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Harita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ünite sınavı'));
    await tester.pumpAndSettle();

    expect(await db.select(db.reviewLogs).get(), isEmpty);
    final option = find.byType(OutlinedButton).first;
    await tester.ensureVisible(option);
    await tester.tap(option);
    await tester.pumpAndSettle();

    // Uygulama sınav bitmeden kapanır.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();

    expect(await db.select(db.reviewLogs).get(), hasLength(1));
    expect(await db.select(db.reviewCards).get(), hasLength(1));
    expect(await db.select(db.dailyStats).get(), hasLength(1));
  });
}
