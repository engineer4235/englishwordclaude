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
}
