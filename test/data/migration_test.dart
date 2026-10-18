import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

/// EWL-121: Eski şema sürümünden güncel şemaya geçiş. Kullanıcı uygulamayı
/// güncellediğinde verisi korunmalı, yeni tablo ve sütunlar eklenmelidir.
void main() {
  late Directory dir;
  late File file;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    dir = Directory.systemTemp.createTempSync('ewl_migration');
    file = File('${dir.path}/app.sqlite');
  });
  tearDown(() => dir.deleteSync(recursive: true));

  /// Güncel şemayla bir veritabanı kurar, sonra onu şema 1'e geri indirir:
  /// sonradan eklenen tablo ve sütunlar kaldırılır.
  Future<void> createVersion1() async {
    final db = AppDatabase(NativeDatabase(file));
    await db.ensureProfile();
    await db.customStatement(
      'UPDATE user_profile SET streak = 5, total_xp = 120, daily_target = 15',
    );
    await db.customStatement(
      "INSERT INTO daily_stats (day, new_words) VALUES ('2026-10-01', 7)",
    );
    for (final table in [
      'word_list_items',
      'word_lists',
      'word_notes',
      'favorites',
    ]) {
      await db.customStatement('DROP TABLE $table');
    }
    for (final column in [
      'onboarding_done',
      'theme_mode',
      'speech_rate',
      'sound_effects',
      'haptics',
      'reminder_enabled',
      'streak_warning_enabled',
      'quiet_hours_enabled',
      'quiet_start',
      'quiet_end',
      'streak_freezes',
    ]) {
      await db.customStatement('ALTER TABLE user_profile DROP COLUMN $column');
    }
    await db.customStatement('ALTER TABLE daily_stats DROP COLUMN frozen');
    await db.customStatement('PRAGMA user_version = 1');
    await db.close();
  }

  test(
    'şema 1 → güncel: veri korunur, yeni alanlar varsayılanla gelir',
    () async {
      await createVersion1();

      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      final profile = await db.ensureProfile();

      // Eski veri yerinde.
      expect(profile.streak, 5);
      expect(profile.totalXp, 120);
      expect(profile.dailyTarget, 15);
      final day = await (db.select(
        db.dailyStats,
      )..where((t) => t.day.equals('2026-10-01'))).getSingle();
      expect(day.newWords, 7);

      // Şema 3–5 sütunları varsayılan değerleriyle eklendi.
      expect(profile.onboardingDone, isFalse);
      expect(profile.themeMode, 'system');
      expect(profile.quietStart, '22:00');
      expect(profile.streakFreezes, 0);
      expect(day.frozen, isFalse);

      // Şema 2, 5 ve 6 tabloları kullanılabilir.
      final listId = await db
          .into(db.wordLists)
          .insert(WordListsCompanion.insert(name: 'Seyahat'));
      expect(listId, greaterThan(0));
      expect(await db.select(db.favorites).get(), isEmpty);
      expect(await db.select(db.wordNotes).get(), isEmpty);
      expect(await db.select(db.wordListItems).get(), isEmpty);

      // Sürüm güncellendi; bir sonraki açılışta geçiş tekrar çalışmaz.
      final version = await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.data.values.single, db.schemaVersion);
    },
  );

  test('güncel şemada yeniden açmak veriyi değiştirmez', () async {
    var db = AppDatabase(NativeDatabase(file));
    await db.ensureProfile();
    await db.customStatement('UPDATE user_profile SET streak = 3');
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    expect((await db.ensureProfile()).streak, 3);
  });
}
