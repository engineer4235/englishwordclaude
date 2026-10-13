import 'dart:convert';

import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/repositories/custom_word_repository.dart';
import 'package:english_word_learning/data/repositories/export_repository.dart';
import 'package:english_word_learning/data/repositories/favorites_repository.dart';
import 'package:english_word_learning/data/repositories/notes_repository.dart';
import 'package:english_word_learning/data/repositories/review_repository.dart';
import 'package:english_word_learning/data/repositories/word_list_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  test(
    'yalnız kullanıcı verisi olan kelimeler dışa aktarılır (FR-124)',
    () async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await ContentSeeder(db).seedIfEmpty(seedJson);
      final ids = {
        for (final w in await db.select(db.words).get()) w.lemma: w.id,
      };

      await ReviewRepository(db).markKnown(ids['mother']!);
      await FavoritesRepository(db).toggle(ids['red']!);
      await NotesRepository(db).save(ids['red']!, 'kırmızı, "al"');
      final lists = WordListRepository(db);
      final listId = await lists.create('Seyahat');
      await lists.addWord(listId, ids['one']!);
      await CustomWordRepository(db).add(lemma: 'kite', meaningTr: 'uçurtma');

      final export = await ExportRepository(
        db,
        clock: () => DateTime(2026, 10, 13, 9),
      ).collect();

      expect(export.words.map((w) => w.lemma), [
        'mother',
        'red',
        'one',
        'kite',
      ]);

      final json = jsonDecode(export.toJson()) as Map<String, dynamic>;
      expect(json['format'], ExportRepository.format);
      expect(json['version'], ExportRepository.version);
      expect(json['exportedAt'], '2026-10-13T09:00:00.000');
      expect((json['profile'] as Map)['dailyTarget'], 10);
      final words = (json['words'] as List).cast<Map<String, dynamic>>();
      expect(words.first, containsPair('state', 'mastered'));
      expect(words.first, containsPair('level', 'A1'));
      expect(words.first, containsPair('unit', 'Aile'));
      expect(words.first, containsPair('intervalDays', 21));
      expect(words[1], containsPair('favorite', true));
      expect(words[1], containsPair('note', 'kırmızı, "al"'));
      expect(words.last, containsPair('custom', true));
      expect(words.last, containsPair('level', ''));
      final listsJson = (json['lists'] as List).cast<Map<String, dynamic>>();
      expect(listsJson.firstWhere((l) => l['name'] == 'Seyahat')['words'], [
        'one',
      ]);
      expect(
        listsJson.firstWhere(
          (l) => l['name'] == CustomWordRepository.defaultListName,
        )['words'],
        ['kite'],
      );

      final csv = export.toCsv();
      expect(csv.startsWith('﻿'), isTrue);
      final lines = csv.substring(1).trimRight().split('\r\n');
      expect(lines, hasLength(5));
      expect(lines.first, startsWith('Kelime,Anlam,Seviye,Ünite,Durum'));
      expect(lines[1], startsWith('mother,anne,A1,Aile,Ustalaşıldı,21,'));
      expect(lines[2], contains(',Evet,"kırmızı, ""al""",'));
      expect(lines[3], endsWith(',Seyahat'));
    },
  );

  test('hiç veri yoksa boş ama geçerli dışa aktarım üretilir', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await ContentSeeder(db).seedIfEmpty(seedJson);

    final export = await ExportRepository(db).collect();
    expect(export.words, isEmpty);
    final json = jsonDecode(export.toJson()) as Map<String, dynamic>;
    expect(json['words'], isEmpty);
    expect(json['badges'], isEmpty);
    expect(export.toCsv().substring(1).trimRight().split('\r\n'), hasLength(1));
  });
}
