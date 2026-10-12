import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Metinden sese (FR-31).
abstract interface class TtsService {
  Future<void> speak(String text);
}

class FlutterTtsService implements TtsService {
  FlutterTtsService({this.language = 'en-US', this.rate = 0.45});

  /// en-US (Amerikan) veya en-GB (İngiliz) aksanı.
  final String language;
  final double rate;

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  @override
  Future<void> speak(String text) async {
    try {
      if (!_ready) {
        await _tts.setLanguage(language);
        await _tts.setSpeechRate(rate);
        _ready = true;
      }
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // Cihazda TTS motoru yoksa sessizce geçilir (SRS 2.4).
    }
  }
}

final ttsServiceProvider = Provider<TtsService>((ref) => FlutterTtsService());
