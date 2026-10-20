// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Learn English at Home';

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
  String get exScramble => 'Harfleri doğru sıraya diz';

  @override
  String get clearLetters => 'Temizle';

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

  @override
  String streakFreezes(int count) {
    return '$count seri koruması';
  }

  @override
  String get streakFreezeHint =>
      'Her 7 günlük seride bir koruma kazanırsın (en fazla 2). Bir günü kaçırırsan koruma serini kurtarır.';

  @override
  String get noteTitle => 'Notum';

  @override
  String get synonyms => 'Eş anlamlı';

  @override
  String get antonyms => 'Zıt anlamlı';

  @override
  String get wordFamily => 'Kelime ailesi';

  @override
  String get noteHint => 'Bu kelimeyle ilgili kendi notun';

  @override
  String get addNote => 'Not ekle';

  @override
  String get editNote => 'Notu düzenle';

  @override
  String get saveNote => 'Kaydet';

  @override
  String streakDays(int count) {
    return '$count gün seri';
  }

  @override
  String xpTotal(int xp) {
    return '$xp XP';
  }

  @override
  String get dailyGoal => 'Günlük hedef';

  @override
  String dailyGoalProgress(int done, int target) {
    return '$done/$target yeni kelime';
  }

  @override
  String get goalDone => 'Bugünkü hedef tamamlandı!';

  @override
  String dueToday(int count) {
    return 'Bugün tekrar edilecek $count kelime';
  }

  @override
  String get startReview => 'Tekrarlara başla';

  @override
  String get noReviews => 'Şu an tekrar edilecek kelime yok.';

  @override
  String nextUnit(String title) {
    return 'Sıradaki ünite: $title';
  }

  @override
  String get learnNewWords => 'Yeni kelimeler';

  @override
  String get reviewOverload =>
      'Çok fazla tekrar birikti. Bugün yeni kelime sayısı azaltıldı; önce tekrarları bitir.';

  @override
  String newWordQuota(int count) {
    return 'Bugün $count yeni kelime daha öğrenebilirsin.';
  }

  @override
  String get reviewsFirst => 'Önce tekrarlarını bitirmeni öneririz.';

  @override
  String get reviewTitle => 'Tekrar';

  @override
  String get resultReview => 'Tekrar tamamlandı';

  @override
  String xpGained(int xp) {
    return '+$xp XP';
  }

  @override
  String get allUnitsDone =>
      'Açık tüm üniteleri tamamladın. Haritadan seviye sınavına girebilirsin.';

  @override
  String get backToHome => 'Ana sayfaya dön';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get intro1Title => 'Seviye seviye ilerle';

  @override
  String get intro1Body =>
      'A1\'den B2\'ye kadar 1.280 kelimeyi ünite ünite öğren. Her seviyenin sonunda bir sınavla bir üst seviyenin kilidini aç.';

  @override
  String get intro2Title => 'Unutmadan öğren';

  @override
  String get intro2Body =>
      'Aralıklı tekrar sistemi, her kelimeyi tam unutmak üzereyken karşına çıkarır.';

  @override
  String get intro3Title => 'Her gün biraz';

  @override
  String get intro3Body => 'Günlük hedefini tamamla, serini koru ve XP kazan.';

  @override
  String get goalQuestion => 'İngilizceyi ne için öğreniyorsun?';

  @override
  String get goalGeneral => 'Genel';

  @override
  String get goalTravel => 'Seyahat';

  @override
  String get goalWork => 'İş';

  @override
  String get goalExam => 'Sınav';

  @override
  String get targetQuestion => 'Günde kaç yeni kelime öğrenmek istersin?';

  @override
  String targetOption(int count) {
    return 'Günde $count kelime';
  }

  @override
  String get notifyQuestion => 'Sana ne zaman hatırlatalım?';

  @override
  String get notifyNone => 'Hatırlatma istemiyorum';

  @override
  String get notifyPick => 'Başka bir saat seç';

  @override
  String get startQuestion => 'Nereden başlamak istersin?';

  @override
  String get startPlacement => 'Seviye tespit sınavına gir';

  @override
  String get startPlacementHint => 'En fazla 30 soru, yaklaşık 5 dakika.';

  @override
  String get startFromA1 => 'A1\'den başla';

  @override
  String get placementTitle => 'Seviye tespit sınavı';

  @override
  String get placementIntro =>
      'Sana İngilizce kelimeler göstereceğiz, Türkçe anlamını seç. Doğru bildikçe sorular zorlaşır, yanlışta kolaylaşır. Bilmediğin soruda tahmin yapmak yerine \"Bilmiyorum\"u seçebilirsin.';

  @override
  String get placementStart => 'Sınava başla';

  @override
  String get placementDontKnow => 'Bilmiyorum';

  @override
  String placementQuestion(int current) {
    return 'Soru $current';
  }

  @override
  String placementResultTitle(String level) {
    return 'Önerilen seviye: $level';
  }

  @override
  String placementResultBody(int correct, int total) {
    return '$correct/$total soruyu doğru cevapladın. Bu seviyeden başlayabilir ya da daha düşük bir seviye seçebilirsin.';
  }

  @override
  String placementAccept(String level) {
    return '$level seviyesinden başla';
  }

  @override
  String get placementLower => 'Daha düşük bir seviye seç';

  @override
  String placementNotReady(String level, String start) {
    return '$level seviyesinin üniteleri henüz hazır değil. Şimdilik $start seviyesinden başlayabilirsin; sonraki seviyeler sırayla açılır.';
  }

  @override
  String get placementNoContent =>
      'Seviye tespiti için henüz yeterli kelime yok.';

  @override
  String get retakePlacement => 'Seviye tespit sınavını yeniden yap';

  @override
  String get retakePlacementHint =>
      'Atladığın seviyelerin kelimeleri bilinen olarak işaretlenir.';

  @override
  String get sectionLearning => 'Öğrenme';

  @override
  String get sectionNotifications => 'Bildirimler';

  @override
  String get sectionSoundTheme => 'Ses ve görünüm';

  @override
  String get sectionData => 'Veri';

  @override
  String get sectionLegal => 'Gizlilik ve yasal';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get privacyPolicyHint => 'Verilerin yalnızca bu cihazda saklanır.';

  @override
  String get kvkkNotice => 'KVKK aydınlatma metni';

  @override
  String get shareApp => 'Uygulamayı paylaş';

  @override
  String get shareAppHint => 'Arkadaşlarına Learn English at Home\'u öner';

  @override
  String shareAppText(String link) {
    return 'İngilizce kelimeleri reklamsız ve internetsiz öğrendiğim uygulama: Learn English at Home\n$link';
  }

  @override
  String get shareWord => 'Paylaş';

  @override
  String shareWordText(String lemma, String meaning, String link) {
    return 'Günün kelimesi: $lemma = $meaning\nLearn English at Home ile her gün yeni kelimeler öğreniyorum: $link';
  }

  @override
  String get openSourceLicenses => 'Açık kaynak lisansları';

  @override
  String get openSourceLicensesHint => 'Kullanılan yazı tipi ve kütüphaneler';

  @override
  String get settingDailyTarget => 'Günlük yeni kelime hedefi';

  @override
  String get settingReminder => 'Günlük hatırlatma';

  @override
  String get settingReminderTime => 'Hatırlatma saati';

  @override
  String get settingStreakWarning => 'Akşam seri uyarısı';

  @override
  String get settingAccent => 'Aksan';

  @override
  String get accentUs => 'Amerikan';

  @override
  String get accentUk => 'İngiliz';

  @override
  String get settingSpeechRate => 'Konuşma hızı';

  @override
  String get settingTheme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get settingSound => 'Ses efektleri';

  @override
  String get settingHaptics => 'Titreşim';

  @override
  String get resetProgress => 'İlerlemeyi sıfırla';

  @override
  String get resetProgressHint =>
      'Öğrenme geçmişi, XP ve seri silinir. Ayarlar ve favoriler korunur.';

  @override
  String get resetConfirmTitle => 'İlerleme sıfırlansın mı?';

  @override
  String get resetConfirmBody => 'Bu işlem geri alınamaz.';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get resetAction => 'Sıfırla';

  @override
  String get resetDone => 'İlerleme sıfırlandı.';

  @override
  String get statsLearned => 'Öğrenilen kelime';

  @override
  String statsStudied(int count) {
    return '$count kelime çalışıldı';
  }

  @override
  String get stateNew => 'Yeni';

  @override
  String get stateLearning => 'Öğreniliyor';

  @override
  String get stateReview => 'Tekrarda';

  @override
  String get stateMastered => 'Ustalaşıldı';

  @override
  String get statsActivity => 'Günlük aktivite';

  @override
  String get stats7Days => '7 gün';

  @override
  String get stats30Days => '30 gün';

  @override
  String get statsNewWords => 'Yeni';

  @override
  String get statsReviews => 'Tekrar';

  @override
  String statsMinutes(int count) {
    return '$count dk';
  }

  @override
  String statsActivitySummary(int newWords, int reviews, int minutes) {
    return '$newWords yeni kelime, $reviews tekrar, $minutes dakika';
  }

  @override
  String get statsLevels => 'Seviye ilerlemesi';

  @override
  String get statsNoActivity => 'Bu dönemde çalışma yok.';

  @override
  String get statsHeatmap => 'Çalışma takvimi';

  @override
  String statsHeatmapSummary(int count) {
    return 'Son 12 haftada $count gün çalıştın';
  }

  @override
  String get wordOfDay => 'Günün kelimesi';

  @override
  String get statsAccuracy => 'Doğruluk oranı';

  @override
  String statsAccuracyOverall(int percent, int count) {
    return 'Son 30 günde %$percent doğru ($count cevap)';
  }

  @override
  String get statsNoAnswers => 'Son 30 günde cevap yok.';

  @override
  String get statsForecast => 'Gelecek tekrarlar';

  @override
  String statsForecastSummary(int count) {
    return 'Önümüzdeki 7 günde $count tekrar planlandı';
  }

  @override
  String get statsForecastToday => 'Bugün';

  @override
  String get exLabelMcEnTr => 'İngilizce → Türkçe';

  @override
  String get exLabelMcTrEn => 'Türkçe → İngilizce';

  @override
  String get exLabelListen => 'Dinleme';

  @override
  String get exLabelTyping => 'Yazma';

  @override
  String get exLabelFillBlank => 'Boşluk doldurma';

  @override
  String get exLabelMatching => 'Eşleştirme';

  @override
  String get exLabelScramble => 'Harf karıştırma';

  @override
  String get filterDifficult => 'Zorlandıklarım';

  @override
  String get practiceFavorites => 'Favorileri çalış';

  @override
  String get practiceDifficult => 'Zorlandıklarımı çalış';

  @override
  String get myLists => 'Listelerim';

  @override
  String get newList => 'Yeni liste';

  @override
  String get renameList => 'Yeniden adlandır';

  @override
  String get deleteList => 'Listeyi sil';

  @override
  String get practiceList => 'Listeyle çalış';

  @override
  String get addToList => 'Listeye ekle';

  @override
  String get listNameHint => 'Liste adı';

  @override
  String get noLists =>
      'Kelimeleri kendi listelerinde toplamak için yeni bir liste oluştur.';

  @override
  String get searchHint => 'İngilizce ya da Türkçe ara';

  @override
  String get clearSearch => 'Aramayı temizle';

  @override
  String get filterFavorites => 'Favoriler';

  @override
  String get filterAllLevels => 'Tüm seviyeler';

  @override
  String get filterAllStates => 'Tüm durumlar';

  @override
  String resultCount(int count) {
    return '$count kelime';
  }

  @override
  String get noResults => 'Sonuç bulunamadı.';

  @override
  String get noResultsHint => 'Aramanı ya da filtreleri değiştirmeyi dene.';

  @override
  String get clearFilters => 'Filtreleri temizle';

  @override
  String get noListsTitle => 'Henüz listen yok';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get notifReminderTitle => 'Kelime zamanı!';

  @override
  String get notifReminderBody =>
      'Bugünkü kelimelerin ve tekrarların seni bekliyor.';

  @override
  String get notifStreakTitle => 'Serin tehlikede!';

  @override
  String get notifStreakBody =>
      'Bugünkü hedefini henüz tamamlamadın. Birkaç dakika ayır, serini koru.';

  @override
  String get settingQuietHours => 'Sessiz saatler';

  @override
  String get settingQuietHoursHint => 'Bu saatlerde bildirim gönderilmez.';

  @override
  String get settingQuietStart => 'Başlangıç';

  @override
  String get settingQuietEnd => 'Bitiş';

  @override
  String get notifPermissionDenied =>
      'Bildirim izni verilmedi. Hatırlatmalar için izni cihaz ayarlarından açabilirsin.';

  @override
  String get badgesTitle => 'Rozetler';

  @override
  String get badgeFirstWord => 'İlk kelime';

  @override
  String badgeWords(int count) {
    return '$count kelime';
  }

  @override
  String badgeStreak(int count) {
    return '$count günlük seri';
  }

  @override
  String badgeLevel(String level) {
    return '$level tamamlandı';
  }

  @override
  String newBadge(String name) {
    return 'Yeni rozet: $name';
  }

  @override
  String get badgeEarned => 'Kazanıldı';

  @override
  String get badgeLocked => 'Henüz kazanılmadı';

  @override
  String badgesEarnedCount(int earned, int total) {
    return '$earned/$total rozet';
  }

  @override
  String longestStreak(int count) {
    return 'En uzun seri: $count gün';
  }

  @override
  String matchTimeLeft(int seconds) {
    return '$seconds sn';
  }

  @override
  String get matchTimeUp => 'Süre doldu!';

  @override
  String get save => 'Kaydet';

  @override
  String get addWord => 'Kelime ekle';

  @override
  String get wordEnLabel => 'İngilizce kelime';

  @override
  String get wordTrLabel => 'Türkçe anlamı';

  @override
  String get exampleEnLabel => 'Örnek cümle (isteğe bağlı)';

  @override
  String get exampleTrLabel => 'Cümlenin çevirisi (isteğe bağlı)';

  @override
  String get duplicateWord => 'Bu kelime zaten var.';

  @override
  String wordAdded(String lemma) {
    return '\"$lemma\" eklendi';
  }

  @override
  String get deleteWord => 'Kelimeyi sil';

  @override
  String deleteWordConfirm(String lemma) {
    return '\"$lemma\" ve çalışma geçmişi silinsin mi?';
  }

  @override
  String get delete => 'Sil';

  @override
  String get posOther => 'kendi kelimem';

  @override
  String get quickPassExam => 'Hızlı geçiş sınavı';

  @override
  String quickPassInfo(String unit, int score) {
    return '\"$unit\" ünitesi henüz kilitli. Kelimelerini zaten biliyorsan hızlı geçiş sınavına girebilirsin: %$score ve üzeri alırsan ünite tamamlanır ve sonraki ünite açılır.';
  }

  @override
  String get startExam => 'Sınava başla';

  @override
  String get resultQuickPassPassed =>
      'Harika! Ünite tamamlandı, sonraki ünite açıldı.';

  @override
  String resultQuickPassFailed(int score) {
    return 'Ünitenin açılması için %$score gerekiyordu. Üniteye sırası gelince adım adım çalışabilirsin.';
  }

  @override
  String get backToWords => 'Kelimelerime dön';

  @override
  String get posInterjection => 'ünlem';

  @override
  String unitsCompleted(int done, int total) {
    return '$done/$total ünite tamamlandı';
  }

  @override
  String get showUnits => 'Üniteleri göster';

  @override
  String get hideUnits => 'Üniteleri gizle';

  @override
  String get nextUnitBadge => 'Sıradaki';

  @override
  String get exportData => 'Verilerimi dışa aktar';

  @override
  String get exportDataHint =>
      'Kelime ilerlemen, notların ve listelerin panoya kopyalanır.';

  @override
  String get exportJson => 'JSON (tam yedek)';

  @override
  String get exportJsonHint =>
      'Tüm verilerin; saklamak ya da başka bir yere taşımak için';

  @override
  String get exportCsv => 'CSV (kelime tablosu)';

  @override
  String get exportCsvHint => 'Excel veya Google E-Tablolar\'da açmak için';

  @override
  String exportCopied(int count) {
    return '$count kelimenin verisi panoya kopyalandı';
  }
}
