import 'package:english_word_learning/domain/srs/answer_quality.dart';
import 'package:english_word_learning/domain/text/answer_matching.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cevap kalitesi (FR-61)', () {
    test('doğru ve hızlı = 5', () {
      expect(
        answerQuality(correct: true, responseTime: const Duration(seconds: 2)),
        5,
      );
    });
    test('doğru ve yavaş = 4', () {
      expect(
        answerQuality(correct: true, responseTime: const Duration(seconds: 9)),
        4,
      );
    });
    test('neredeyse doğru = 3', () {
      expect(
        answerQuality(
          correct: false,
          almostCorrect: true,
          responseTime: const Duration(seconds: 3),
        ),
        3,
      );
    });
    test('yanlış = 1', () {
      expect(
        answerQuality(correct: false, responseTime: const Duration(seconds: 3)),
        1,
      );
    });
  });

  group('yazılı cevap eşleştirme (FR-43)', () {
    test('büyük/küçük harf ve boşluklar önemsenmez', () {
      expect(matchAnswer('  Mother ', 'mother'), AnswerMatch.correct);
    });
    test('tek harf hatası neredeyse doğrudur', () {
      expect(matchAnswer('mothr', 'mother'), AnswerMatch.almostCorrect);
      expect(matchAnswer('mither', 'mother'), AnswerMatch.almostCorrect);
    });
    test('iki harf hatası yanlıştır', () {
      expect(matchAnswer('mathr', 'mother'), AnswerMatch.wrong);
    });
    test('kısa kelimelerde tolerans yoktur', () {
      expect(matchAnswer('tw', 'two'), AnswerMatch.wrong);
      expect(matchAnswer('on', 'one'), AnswerMatch.wrong);
    });
    test('boş cevap yanlıştır', () {
      expect(matchAnswer('', 'red'), AnswerMatch.wrong);
    });
  });
}
