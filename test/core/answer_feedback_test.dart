import 'package:drift/drift.dart' show Value;
import 'package:english_word_learning/core/feedback/answer_feedback.dart';
import 'package:english_word_learning/data/db/app_database.dart';
import 'package:english_word_learning/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// Ses ve titreşim için platform kanalına giden çağrıları kaydeder.
List<String> recordPlatformCalls(WidgetTester tester) {
  final calls = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'HapticFeedback.vibrate' ||
          call.method == 'SystemSound.play') {
        calls.add('${call.method}:${call.arguments}');
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return calls;
}

void main() {
  testWidgets('doğru ve yanlış cevap farklı geri bildirim verir (FR-122)', (
    tester,
  ) async {
    final calls = recordPlatformCalls(tester);
    const feedback = SystemAnswerFeedback(sound: true, haptics: true);

    await feedback.play(correct: true);
    expect(calls, [
      'HapticFeedback.vibrate:HapticFeedbackType.lightImpact',
      'SystemSound.play:SystemSoundType.click',
    ]);

    calls.clear();
    await feedback.play(correct: false);
    expect(calls, [
      'HapticFeedback.vibrate:HapticFeedbackType.heavyImpact',
      'SystemSound.play:SystemSoundType.alert',
    ]);
  });

  testWidgets('kapatılan kanal kullanılmaz', (tester) async {
    final calls = recordPlatformCalls(tester);

    await const SystemAnswerFeedback(
      sound: false,
      haptics: true,
    ).play(correct: true);
    expect(calls, ['HapticFeedback.vibrate:HapticFeedbackType.lightImpact']);

    calls.clear();
    await const SystemAnswerFeedback(
      sound: true,
      haptics: false,
    ).play(correct: true);
    expect(calls, ['SystemSound.play:SystemSoundType.click']);

    calls.clear();
    await const SystemAnswerFeedback(
      sound: false,
      haptics: false,
    ).play(correct: false);
    expect(calls, isEmpty);
  });

  // iOS'ta dokunuşlar kendi tık sesini çıkarmaz; böylece yalnız cevap geri
  // bildirimi sayılır.
  for (final enabled in [true, false]) {
    testWidgets(
      'alıştırmada ayarlara uyulur (açık: $enabled)',
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final calls = recordPlatformCalls(tester);
        final db = memoryDatabase();
        addTearDown(db.close);
        await db.ensureProfile();
        await ProfileRepository(db).update(
          UserProfileCompanion(
            soundEffects: Value(enabled),
            haptics: Value(enabled),
          ),
        );

        await tester.pumpWidget(testApp(db));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Harita'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Aile'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Ünite sınavı'));
        await tester.pumpAndSettle();

        final option = find.byType(OutlinedButton).first;
        await tester.ensureVisible(option);
        await tester.tap(option);
        await tester.pumpAndSettle();

        if (enabled) {
          expect(calls, hasLength(2));
          expect(calls.first, startsWith('HapticFeedback.vibrate:'));
          expect(calls.last, startsWith('SystemSound.play:'));
        } else {
          expect(calls, isEmpty);
        }
      },
    );
  }
}
