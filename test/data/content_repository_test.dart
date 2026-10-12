import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/content_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ContentRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftContentRepository(db);
  });

  tearDown(() => db.close());

  test('seviyeler sıralarına göre döner', () async {
    await db
        .into(db.levels)
        .insert(
          LevelsCompanion.insert(code: 'A2', sortOrder: 2, title: 'Temel'),
        );
    await db
        .into(db.levels)
        .insert(
          LevelsCompanion.insert(code: 'A1', sortOrder: 1, title: 'Başlangıç'),
        );

    final levels = await repo.getLevels();

    expect(levels.map((l) => l.code), ['A1', 'A2']);
  });

  test('bir ünitenin kelimeleri döner', () async {
    final levelId = await db
        .into(db.levels)
        .insert(
          LevelsCompanion.insert(code: 'A1', sortOrder: 1, title: 'Başlangıç'),
        );
    final unitId = await db
        .into(db.units)
        .insert(
          UnitsCompanion.insert(
            levelId: levelId,
            sortOrder: 1,
            titleTr: 'Aile',
            theme: 'family',
          ),
        );
    await db
        .into(db.words)
        .insert(
          WordsCompanion.insert(
            unitId: unitId,
            lemma: 'mother',
            pos: 'noun',
            meaningTr: 'anne',
          ),
        );

    final units = await repo.getUnits(levelId);
    final words = await repo.getWords(unitId);

    expect(units.single.title, 'Aile');
    expect(words.single.lemma, 'mother');
    expect(words.single.meaningTr, 'anne');
  });

  test('yeni kelime kartı varsayılan SM-2 değerleriyle oluşur', () async {
    final levelId = await db
        .into(db.levels)
        .insert(
          LevelsCompanion.insert(code: 'A1', sortOrder: 1, title: 'Başlangıç'),
        );
    final unitId = await db
        .into(db.units)
        .insert(
          UnitsCompanion.insert(
            levelId: levelId,
            sortOrder: 1,
            titleTr: 'Aile',
            theme: 'family',
          ),
        );
    final wordId = await db
        .into(db.words)
        .insert(
          WordsCompanion.insert(
            unitId: unitId,
            lemma: 'father',
            pos: 'noun',
            meaningTr: 'baba',
          ),
        );
    await db
        .into(db.reviewCards)
        .insert(ReviewCardsCompanion.insert(wordId: Value(wordId)));

    final card = await db.select(db.reviewCards).getSingle();

    expect(card.state, 'new');
    expect(card.easeFactor, 2.5);
    expect(card.repetitions, 0);
  });
}
