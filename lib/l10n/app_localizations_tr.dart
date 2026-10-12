// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'İngilizce Kelime';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navMap => 'Harita';

  @override
  String get navWords => 'Kelimelerim';

  @override
  String get navStats => 'İstatistik';

  @override
  String get navProfile => 'Profil';

  @override
  String get comingSoon => 'Bu bölüm yakında hazır olacak.';

  @override
  String get loadError => 'İçerik yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String levelProgress(int percent) {
    return '%$percent öğrenildi';
  }

  @override
  String get levelLocked =>
      'Bu seviye, önceki seviyenin sınavı geçilince açılır.';

  @override
  String unitWords(int learned, int total) {
    return '$learned/$total kelime öğrenildi';
  }

  @override
  String get statusLocked => 'Kilitli';

  @override
  String get statusOpen => 'Açık';

  @override
  String get statusCompleted => 'Tamamlandı';

  @override
  String bestScore(int score) {
    return 'En iyi: %$score';
  }

  @override
  String get listen => 'Dinle';

  @override
  String get addFavorite => 'Favorilere ekle';

  @override
  String get removeFavorite => 'Favorilerden çıkar';

  @override
  String get examples => 'Örnek cümleler';

  @override
  String get iKnowThis => 'Bunu zaten biliyorum';

  @override
  String markedKnown(String word) {
    return '\"$word\" uzun aralıklı tekrara alındı.';
  }

  @override
  String get previous => 'Önceki';

  @override
  String get next => 'Sonraki';

  @override
  String get backToMap => 'Haritaya dön';

  @override
  String get noWords => 'Bu ünitede henüz kelime yok.';

  @override
  String wordPosition(int current, int total) {
    return '$current / $total';
  }

  @override
  String get posNoun => 'isim';

  @override
  String get posVerb => 'fiil';

  @override
  String get posAdjective => 'sıfat';

  @override
  String get posAdverb => 'zarf';

  @override
  String get posNumber => 'sayı';

  @override
  String get startPractice => 'Alıştırmaya başla';

  @override
  String get unitExam => 'Ünite sınavı';

  @override
  String get levelExam => 'Seviye sınavına gir';

  @override
  String get exChooseMeaning => 'Doğru anlamı seç';

  @override
  String get exChooseWord => 'İngilizcesini seç';

  @override
  String get exListen => 'Dinle ve doğru yazımı seç';

  @override
  String get exFillBlank => 'Boşluğa uygun kelimeyi seç';

  @override
  String get exType => 'İngilizcesini yaz';

  @override
  String get exMatch => 'Kelimeleri anlamlarıyla eşleştir';

  @override
  String get check => 'Kontrol et';

  @override
  String get continueLabel => 'Devam';

  @override
  String get correctFeedback => 'Doğru!';

  @override
  String wrongFeedback(String answer) {
    return 'Yanlış. Doğru cevap: $answer';
  }

  @override
  String almostFeedback(String answer) {
    return 'Neredeyse doğru! Doğrusu: $answer';
  }

  @override
  String get typingHint => 'Cevabını yaz';

  @override
  String get replay => 'Tekrar dinle';

  @override
  String questionPosition(int current, int total) {
    return 'Soru $current/$total';
  }

  @override
  String get resultLesson => 'Alıştırma tamamlandı';

  @override
  String get resultUnitPassed => 'Ünite tamamlandı! Sıradaki ünite açıldı.';

  @override
  String get resultUnitFailed =>
      'Sıradaki üniteyi açmak için en az %70 gerekiyor. Tekrar dene!';

  @override
  String resultLevelPassed(String level) {
    return 'Tebrikler! $level seviyesini tamamladın.';
  }

  @override
  String get resultLevelFailed =>
      'Seviye sınavını 24 saat sonra tekrar deneyebilirsin. Yanlış kelimeler tekrar listene eklendi.';

  @override
  String scorePercent(int score) {
    return '%$score';
  }

  @override
  String correctCount(int correct, int total) {
    return '$correct/$total doğru';
  }

  @override
  String get wrongWordsTitle => 'Tekrar etmen gereken kelimeler';

  @override
  String examNeedLearned(int percent) {
    return 'Seviye sınavı için kelimelerin en az %80\'ini öğrenmelisin (şu an %$percent).';
  }

  @override
  String examRetryAt(String time) {
    return 'Seviye sınavını $time sonrasında tekrar deneyebilirsin.';
  }

  @override
  String levelBadge(String level) {
    return '$level rozeti kazanıldı';
  }
}
