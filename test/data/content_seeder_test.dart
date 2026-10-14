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
    expect(units, hasLength(25), reason: 'A1 içeriği (CNT-2)');
    expect(units.take(3).map((u) => u.title), ['Aile', 'Renkler', 'Sayılar']);
    expect(await repo.getUnits(levels[1].id), hasLength(25));
    final b1 = await repo.getUnits(levels[2].id);
    expect(b1, hasLength(25), reason: 'B1 içeriği (CNT-4)');
    expect(b1.first.title, 'İş Hayatı');
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

    expect(await seeder.addMissingUnits(json), 72);
    expect(await seeder.addMissingUnits(json), 0);

    final units = await repo.getUnits(a1.id);
    expect(units, hasLength(25));
    expect(units[3].title, 'Yiyecek ve İçecek');
    final progress = {
      for (final p in await db.select(db.unitProgress).get()) p.unitId: p,
    };
    expect(progress[units[3].id]?.status, 'open');
    expect(progress[units[4].id], isNull, reason: 'sonraki yeni ünite kilitli');
    expect(await repo.getWords(units[3].id), hasLength(8));
  });

  test('açık ama ünitesiz seviyeye gelen ilk ünite açılır', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final seeder = ContentSeeder(db);
    // Yalnız A1-A2 içeren eski paket; B1 seviyesi var ama ünitesi yok.
    final data = jsonDecode(json) as Map<String, dynamic>;
    final old = {
      ...data,
      'units': [
        for (final u in data['units'] as List)
          if ((u as Map)['level'] != 'B1') u,
      ],
    };
    await seeder.seedIfEmpty(jsonEncode(old));
    final repo = DriftContentRepository(db);
    final b1 = (await repo.getLevels())[2];
    expect(await repo.getUnits(b1.id), isEmpty);

    // Kullanıcı A2'yi geçmiş, B1 açılmış.
    await db
        .into(db.levelProgress)
        .insertOnConflictUpdate(
          LevelProgressCompanion.insert(
            levelId: Value(b1.id),
            status: const Value('open'),
          ),
        );

    expect(await seeder.addMissingUnits(json), 25);
    final units = await repo.getUnits(b1.id);
    final progress = {
      for (final p in await db.select(db.unitProgress).get()) p.unitId: p,
    };
    expect(progress[units[0].id]?.status, 'open');
    expect(progress[units[1].id], isNull);
  });

  test('kilitli seviyeye gelen üniteler kilitli kalır', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final seeder = ContentSeeder(db);
    final data = jsonDecode(json) as Map<String, dynamic>;
    await seeder.seedIfEmpty(
      jsonEncode({
        ...data,
        'units': [
          for (final u in data['units'] as List)
            if ((u as Map)['level'] != 'B1') u,
        ],
      }),
    );
    expect(await seeder.addMissingUnits(json), 25);
    final b1 = (await DriftContentRepository(db).getLevels())[2];
    final unitIds = {
      for (final u in await DriftContentRepository(db).getUnits(b1.id)) u.id,
    };
    final progress = await db.select(db.unitProgress).get();
    expect(progress.where((p) => unitIds.contains(p.unitId)), isEmpty);
  });

  test(
    'kelime ilişkileri iki yönlü eklenir ve tekrar edilmez (FR-33)',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final seeder = ContentSeeder(db);
      await seeder.seedIfEmpty(json);

      final relations =
          (jsonDecode(json) as Map<String, dynamic>)['relations'] as List;
      expect(
        await seeder.syncRelations(json),
        relations.length,
        reason: 'tüm ilişkiler içerikteki kelimeleri gösterir',
      );
      final rows = await db.select(db.wordRelations).get();
      expect(rows, hasLength(relations.length * 2));

      await seeder.syncRelations(json);
      expect(await db.select(db.wordRelations).get(), hasLength(rows.length));

      final repo = DriftContentRepository(db);
      final words = await repo.getAllWords();
      final big = words.firstWhere((w) => w.lemma == 'big');
      final set = await repo.getRelations(big.id);
      expect([for (final w in set.antonyms) w.lemma], ['small']);
      expect(set.synonyms, isEmpty);
      final small = words.firstWhere((w) => w.lemma == 'small');
      expect(
        [for (final w in (await repo.getRelations(small.id)).antonyms) w.lemma],
        ['big'],
      );
      final hot = words.firstWhere((w) => w.lemma == 'hot');
      final hotSet = await repo.getRelations(hot.id);
      expect([for (final w in hotSet.antonyms) w.lemma], ['cold']);
      expect([for (final w in hotSet.synonyms) w.lemma], ['warm']);
    },
  );

  test('ilişkisi olmayan kelimede boş küme döner', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await ContentSeeder(db).seedIfEmpty(json);
    final repo = DriftContentRepository(db);
    final word = (await repo.getAllWords()).firstWhere((w) => w.lemma == 'red');
    expect((await repo.getRelations(word.id)).isEmpty, isTrue);
  });
}
