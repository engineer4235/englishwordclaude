import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
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
    expect(units, hasLength(13), reason: 'A1 içeriği (CNT-2)');
    expect(units.take(3).map((u) => u.title), ['Aile', 'Renkler', 'Sayılar']);
    expect(await repo.getUnits(levels[1].id), hasLength(4));
    expect(await repo.getWords(units.first.id), hasLength(8));

    final openUnits = await db.select(db.unitProgress).get();
    expect(openUnits.single.unitId, units.first.id);
    expect(openUnits.single.status, 'open');
  });

  test('içerik paketinde kelimeler tekrar etmez', () {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final lemmas = [
      for (final unit in data['units'] as List)
        for (final word in unit['words'] as List) word['lemma'] as String,
    ];
    expect(lemmas.toSet(), hasLength(lemmas.length));
  });

  test('güncellemeyle gelen yeni üniteler eklenir (CNT-5)', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final old = File('test/fixtures/seed_content.json').readAsStringSync();
    final seeder = ContentSeeder(db);
    await seeder.seedIfEmpty(old);

    // Eski kurulumda A1'in son ünitesi tamamlanmış olsun.
    final repo = DriftContentRepository(db);
    final a1 = (await repo.getLevels()).first;
    final oldUnits = await repo.getUnits(a1.id);
    await db
        .into(db.unitProgress)
        .insertOnConflictUpdate(
          UnitProgressCompanion.insert(
            unitId: Value(oldUnits.last.id),
            status: const Value('completed'),
          ),
        );

    expect(await seeder.addMissingUnits(json), 14);
    expect(await seeder.addMissingUnits(json), 0);

    final units = await repo.getUnits(a1.id);
    expect(units, hasLength(13));
    expect(units[3].title, 'Yiyecek ve İçecek');
    final progress = {
      for (final p in await db.select(db.unitProgress).get()) p.unitId: p,
    };
    expect(progress[units[3].id]?.status, 'open');
    expect(progress[units[4].id], isNull, reason: 'sonraki yeni ünite kilitli');
    expect(await repo.getWords(units[3].id), hasLength(8));
  });
}
