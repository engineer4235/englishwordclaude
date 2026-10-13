import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/content_repository.dart';
import 'package:english_word_learning/data/repositories/custom_word_repository.dart';
import 'package:english_word_learning/data/repositories/favorites_repository.dart';
import 'package:english_word_learning/data/repositories/notes_repository.dart';
import 'package:english_word_learning/data/repositories/progress_repository.dart';
import 'package:english_word_learning/data/repositories/review_repository.dart';
import 'package:english_word_learning/data/repositories/word_list_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late CustomWordRepository repo;

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
    repo = CustomWordRepository(db);
  });

  tearDown(() => db.close());

  test('kelime eklenir ve varsayılan listeye konur (FR-92)', () async {
    expect(await repo.unitId(), isNull);
    final id = await repo.add(
      lemma: '  serendipity ',
      meaningTr: 'mutlu tesadüf',
      exampleEn: 'It was pure serendipity.',
      exampleTr: 'Tamamen mutlu bir tesadüftü.',
    );
    final unitId = await repo.unitId();
    expect(unitId, isNotNull);

    final word = (await DriftContentRepository(db).getWordsByIds([id])).single;
    expect(word.lemma, 'serendipity');
    expect(word.meaningTr, 'mutlu tesadüf');
    expect(word.unitId, unitId);
    expect(word.examples.single.en, 'It was pure serendipity.');

    final lists = WordListRepository(db);
    final all = await lists.lists();
    expect(all.single.name, CustomWordRepository.defaultListName);
    expect(await lists.wordIds(all.single.id), [id]);

    // İkinci kelime aynı listeye ve aynı üniteye gider.
    final second = await repo.add(lemma: 'quaint', meaningTr: 'şirin');
    expect((await lists.lists()).single.wordCount, 2);
    expect(
      (await DriftContentRepository(db).getWordsByIds([second])).single.unitId,
      unitId,
    );
  });

  test('aynı kelime ikinci kez eklenemez', () async {
    final existing = (await db.select(db.words).get()).first.lemma;
    await expectLater(
      repo.add(lemma: existing.toUpperCase(), meaningTr: 'x'),
      throwsA(isA<DuplicateWordException>()),
    );
    await repo.add(lemma: 'zephyr', meaningTr: 'meltem');
    await expectLater(
      repo.add(lemma: 'Zephyr', meaningTr: 'meltem'),
      throwsA(isA<DuplicateWordException>()),
    );
    expect(() => repo.add(lemma: ' ', meaningTr: 'x'), throwsArgumentError);
  });

  test('gizli seviye haritada ve seviye listesinde görünmez', () async {
    final before = await ProgressRepository(db).overview();
    await repo.add(lemma: 'zephyr', meaningTr: 'meltem');
    final after = await ProgressRepository(db).overview();
    expect(
      [for (final l in after) l.level.code],
      [for (final l in before) l.level.code],
    );
    final levels = await DriftContentRepository(db).getLevels();
    expect(
      levels.where((l) => l.code == CustomWordRepository.levelCode),
      isEmpty,
    );
  });

  test('silme yalnız kendi kelimelere uygulanır ve izleri temizler', () async {
    final id = await repo.add(
      lemma: 'zephyr',
      meaningTr: 'meltem',
      exampleEn: 'A zephyr blew.',
    );
    await ReviewRepository(db).markKnown(id);
    await FavoritesRepository(db).toggle(id);
    await NotesRepository(db).save(id, 'şiirsel');

    final contentWord = (await db.select(db.words).get()).first.id;
    expect(await repo.delete(contentWord), isFalse);

    expect(await repo.delete(id), isTrue);
    expect(
      await (db.select(db.words)..where((t) => t.id.equals(id))).get(),
      isEmpty,
    );
    expect(await db.select(db.reviewCards).get(), isEmpty);
    expect(await db.select(db.favorites).get(), isEmpty);
    expect(await db.select(db.wordNotes).get(), isEmpty);
    expect(await db.select(db.wordListItems).get(), isEmpty);
    expect(
      await (db.select(db.examples)..where((t) => t.wordId.equals(id))).get(),
      isEmpty,
    );
  });
}
