import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';

/// Cevaptan sonra ses ve titreşimle geri bildirim (FR-122).
abstract interface class AnswerFeedback {
  Future<void> play({required bool correct});
}

/// Sistem sesi ve titreşimi; ayarlarda kapatılan kanal kullanılmaz.
class SystemAnswerFeedback implements AnswerFeedback {
  const SystemAnswerFeedback({required this.sound, required this.haptics});

  final bool sound;
  final bool haptics;

  @override
  Future<void> play({required bool correct}) async {
    try {
      if (haptics) {
        await (correct
            ? HapticFeedback.lightImpact()
            : HapticFeedback.heavyImpact());
      }
      if (sound) {
        await SystemSound.play(
          correct ? SystemSoundType.click : SystemSoundType.alert,
        );
      }
    } catch (_) {
      // Cihaz desteklemiyorsa geri bildirim sessizce atlanır.
    }
  }
}

/// Ses efektleri ve titreşim ayarları profilden gelir (FR-122).
final answerFeedbackProvider = Provider<AnswerFeedback>((ref) {
  final profile = ref.watch(profileSettingsProvider).value;
  return SystemAnswerFeedback(
    sound: profile?.soundEffects ?? true,
    haptics: profile?.haptics ?? true,
  );
});
