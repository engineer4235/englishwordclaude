import 'package:drift/native.dart';
import 'package:english_word_learning/data/content/content_seeder.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// NFR-01: Açılış süresi. Açılışta yapılan içerik eşitlemesi ilk kurulumda
/// toplu yazılır, sonraki açılışlarda ise JSON hiç çözülmeden atlanır.
void main() {
  test('ilk kurulum içerik yüklemesi bütçe içinde', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final sw = Stopwatch()..start();
    expect(await ContentSeeder(db).sync(appContentJson), isTrue);
    sw.stop();
    // ignore: avoid_print
    print('İlk kurulum içerik yüklemesi: ${sw.elapsedMilliseconds} ms');
    // CI makineleri yavaş olabilir; cömert bir üst sınır.
    expect(sw.elapsedMilliseconds, lessThan(5000));
  });

  test('sonraki açılışta içerik eşitlemesi neredeyse anında', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await ContentSeeder(db).sync(appContentJson);
    final sw = Stopwatch()..start();
    expect(await ContentSeeder(db).sync(appContentJson), isFalse);
    sw.stop();
    // ignore: avoid_print
    print('Sonraki açılış içerik eşitlemesi: ${sw.elapsedMilliseconds} ms');
    expect(sw.elapsedMilliseconds, lessThan(200));
  });
}
