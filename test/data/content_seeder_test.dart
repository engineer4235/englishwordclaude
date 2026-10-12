import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/content_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = File('assets/content/seed_content.json').readAsStringSync();

  test(
    'içerik paketinde her kelimenin anlamı ve en az 2 örneği var (FR-30)',
    () {
      final data = jsonDecode(json) as Map<String, dynamic>;
      for (final unit in data['units'] as List) {
        for (final word in unit['words'] as List) {
          expect((word['tr'] as String).isNotEmpty, isTrue, reason: '$word');
          expect(
            (word['examples'] as List).length,
            greaterThanOrEqualTo(2),
            reason: word['lemma'] as String,
          );
        }
      }
    },
  );

  test('içerik yüklenir, ilk seviye ve ilk ünite açık başlar', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    expect(await ContentSeeder(db).seedIfEmpty(json), isTrue);
    expect(await ContentSeeder(db).seedIfEmpty(json), isFalse);

    final repo = DriftContentRepository(db);
    final levels = await repo.getLevels();
    expect(levels.map((l) => l.code), ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']);

    final units = await repo.getUnits(levels.first.id);
    expect(units.map((u) => u.title), ['Aile', 'Renkler', 'Sayılar']);
    expect(await repo.getWords(units.first.id), hasLength(8));

    final openUnits = await db.select(db.unitProgress).get();
    expect(openUnits.single.unitId, units.first.id);
    expect(openUnits.single.status, 'open');
  });
}
