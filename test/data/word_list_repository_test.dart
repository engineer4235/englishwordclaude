import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/word_list_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late WordListRepository repo;
  late List<int> wordIds;

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
    wordIds = [for (final w in await db.select(db.words).get()) w.id];
    repo = WordListRepository(db);
  });

  tearDown(() => db.close());

  test('liste oluşturulur, kelime eklenir ve sayılır (FR-91)', () async {
    final travel = await repo.create('  Seyahat  ');
    final exam = await repo.create('Sınav');
    await repo.addWord(travel, wordIds[2]);
    await repo.addWord(travel, wordIds[0]);
    await repo.addWord(travel, wordIds[2]); // tekrar eklenmez

    final lists = await repo.lists();
    expect([for (final l in lists) l.name], ['Seyahat', 'Sınav']);
    expect(lists.first.wordCount, 2);
    expect(lists.last.wordCount, 0);
    expect(await repo.wordIds(travel), [wordIds[2], wordIds[0]]);
    expect(await repo.listsOf(wordIds[2]), {travel});

    await repo.addWord(exam, wordIds[2]);
    expect(await repo.listsOf(wordIds[2]), {travel, exam});
    await repo.removeWord(travel, wordIds[2]);
    expect(await repo.wordIds(travel), [wordIds[0]]);
  });

  test('yeniden adlandırma ve silme; kelimeler etkilenmez', () async {
    final id = await repo.create('Eski');
    await repo.addWord(id, wordIds[0]);
    await repo.rename(id, 'Yeni ad');
    expect(await repo.name(id), 'Yeni ad');
    await repo.rename(id, '   ');
    expect(await repo.name(id), 'Yeni ad', reason: 'boş ad yok sayılır');

    await repo.remove(id);
    expect(await repo.lists(), isEmpty);
    expect(await db.select(db.wordListItems).get(), isEmpty);
    expect(await db.select(db.words).get(), hasLength(wordIds.length));
  });

  test('boş ad kabul edilmez, uzun ad kısaltılır', () async {
    expect(() => repo.create('  '), throwsArgumentError);
    final id = await repo.create('a' * 60);
    expect(await repo.name(id), hasLength(WordListRepository.maxNameLength));
  });
}
