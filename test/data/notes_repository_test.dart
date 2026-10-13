import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/notes_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late NotesRepository notes;
  late int wordId;

  setUp(() async {
    db = memoryDatabase();
    await ContentSeeder(db).seedIfEmpty(seedJson);
    wordId = (await db.select(db.words).get()).first.id;
    notes = NotesRepository(db);
  });

  tearDown(() => db.close());

  test('not kaydedilir, güncellenir ve boş not silinir (FR-36)', () async {
    expect(await notes.get(wordId), isNull);

    await notes.save(wordId, '  annem gibi  ');
    expect(await notes.get(wordId), 'annem gibi');

    await notes.save(wordId, 'yeni not');
    expect(await notes.get(wordId), 'yeni not');
    expect(await db.select(db.wordNotes).get(), hasLength(1));

    await notes.save(wordId, '   ');
    expect(await notes.get(wordId), isNull);
  });

  test('uzun not en fazla uzunlukta kesilir', () async {
    await notes.save(wordId, 'a' * 500);
    expect(await notes.get(wordId), hasLength(NotesRepository.maxLength));
  });
}
