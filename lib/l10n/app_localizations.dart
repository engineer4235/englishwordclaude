import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// Uygulama adı
  ///
  /// In tr, this message translates to:
  /// **'İngilizce Kelime'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get navMap;

  /// No description provided for @navWords.
  ///
  /// In tr, this message translates to:
  /// **'Kelimelerim'**
  String get navWords;

  /// No description provided for @navStats.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik'**
  String get navStats;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Henüz geliştirilmemiş ekranlarda gösterilen metin
  ///
  /// In tr, this message translates to:
  /// **'Bu bölüm yakında hazır olacak.'**
  String get comingSoon;

  /// No description provided for @loadError.
  ///
  /// In tr, this message translates to:
  /// **'İçerik yüklenemedi. Lütfen tekrar deneyin.'**
  String get loadError;

  /// No description provided for @levelProgress.
  ///
  /// In tr, this message translates to:
  /// **'%{percent} öğrenildi'**
  String levelProgress(int percent);

  /// No description provided for @levelLocked.
  ///
  /// In tr, this message translates to:
  /// **'Bu seviye, önceki seviyenin sınavı geçilince açılır.'**
  String get levelLocked;

  /// No description provided for @unitWords.
  ///
  /// In tr, this message translates to:
  /// **'{learned}/{total} kelime öğrenildi'**
  String unitWords(int learned, int total);

  /// No description provided for @statusLocked.
  ///
  /// In tr, this message translates to:
  /// **'Kilitli'**
  String get statusLocked;

  /// No description provided for @statusOpen.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get statusOpen;

  /// No description provided for @statusCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get statusCompleted;

  /// No description provided for @bestScore.
  ///
  /// In tr, this message translates to:
  /// **'En iyi: %{score}'**
  String bestScore(int score);

  /// No description provided for @listen.
  ///
  /// In tr, this message translates to:
  /// **'Dinle'**
  String get listen;

  /// No description provided for @addFavorite.
  ///
  /// In tr, this message translates to:
  /// **'Favorilere ekle'**
  String get addFavorite;

  /// No description provided for @removeFavorite.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerden çıkar'**
  String get removeFavorite;

  /// No description provided for @examples.
  ///
  /// In tr, this message translates to:
  /// **'Örnek cümleler'**
  String get examples;

  /// No description provided for @iKnowThis.
  ///
  /// In tr, this message translates to:
  /// **'Bunu zaten biliyorum'**
  String get iKnowThis;

  /// No description provided for @markedKnown.
  ///
  /// In tr, this message translates to:
  /// **'\"{word}\" uzun aralıklı tekrara alındı.'**
  String markedKnown(String word);

  /// No description provided for @previous.
  ///
  /// In tr, this message translates to:
  /// **'Önceki'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki'**
  String get next;

  /// No description provided for @backToMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritaya dön'**
  String get backToMap;

  /// No description provided for @noWords.
  ///
  /// In tr, this message translates to:
  /// **'Bu ünitede henüz kelime yok.'**
  String get noWords;

  /// No description provided for @wordPosition.
  ///
  /// In tr, this message translates to:
  /// **'{current} / {total}'**
  String wordPosition(int current, int total);

  /// No description provided for @posNoun.
  ///
  /// In tr, this message translates to:
  /// **'isim'**
  String get posNoun;

  /// No description provided for @posVerb.
  ///
  /// In tr, this message translates to:
  /// **'fiil'**
  String get posVerb;

  /// No description provided for @posAdjective.
  ///
  /// In tr, this message translates to:
  /// **'sıfat'**
  String get posAdjective;

  /// No description provided for @posAdverb.
  ///
  /// In tr, this message translates to:
  /// **'zarf'**
  String get posAdverb;

  /// No description provided for @posNumber.
  ///
  /// In tr, this message translates to:
  /// **'sayı'**
  String get posNumber;

  /// No description provided for @startPractice.
  ///
  /// In tr, this message translates to:
  /// **'Alıştırmaya başla'**
  String get startPractice;

  /// No description provided for @unitExam.
  ///
  /// In tr, this message translates to:
  /// **'Ünite sınavı'**
  String get unitExam;

  /// No description provided for @levelExam.
  ///
  /// In tr, this message translates to:
  /// **'Seviye sınavına gir'**
  String get levelExam;

  /// No description provided for @exChooseMeaning.
  ///
  /// In tr, this message translates to:
  /// **'Doğru anlamı seç'**
  String get exChooseMeaning;

  /// No description provided for @exChooseWord.
  ///
  /// In tr, this message translates to:
  /// **'İngilizcesini seç'**
  String get exChooseWord;

  /// No description provided for @exListen.
  ///
  /// In tr, this message translates to:
  /// **'Dinle ve doğru yazımı seç'**
  String get exListen;

  /// No description provided for @exFillBlank.
  ///
  /// In tr, this message translates to:
  /// **'Boşluğa uygun kelimeyi seç'**
  String get exFillBlank;

  /// No description provided for @exType.
  ///
  /// In tr, this message translates to:
  /// **'İngilizcesini yaz'**
  String get exType;

  /// No description provided for @exMatch.
  ///
  /// In tr, this message translates to:
  /// **'Kelimeleri anlamlarıyla eşleştir'**
  String get exMatch;

  /// No description provided for @check.
  ///
  /// In tr, this message translates to:
  /// **'Kontrol et'**
  String get check;

  /// No description provided for @continueLabel.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get continueLabel;

  /// No description provided for @correctFeedback.
  ///
  /// In tr, this message translates to:
  /// **'Doğru!'**
  String get correctFeedback;

  /// No description provided for @wrongFeedback.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış. Doğru cevap: {answer}'**
  String wrongFeedback(String answer);

  /// No description provided for @almostFeedback.
  ///
  /// In tr, this message translates to:
  /// **'Neredeyse doğru! Doğrusu: {answer}'**
  String almostFeedback(String answer);

  /// No description provided for @typingHint.
  ///
  /// In tr, this message translates to:
  /// **'Cevabını yaz'**
  String get typingHint;

  /// No description provided for @replay.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dinle'**
  String get replay;

  /// No description provided for @questionPosition.
  ///
  /// In tr, this message translates to:
  /// **'Soru {current}/{total}'**
  String questionPosition(int current, int total);

  /// No description provided for @resultLesson.
  ///
  /// In tr, this message translates to:
  /// **'Alıştırma tamamlandı'**
  String get resultLesson;

  /// No description provided for @resultUnitPassed.
  ///
  /// In tr, this message translates to:
  /// **'Ünite tamamlandı! Sıradaki ünite açıldı.'**
  String get resultUnitPassed;

  /// No description provided for @resultUnitFailed.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki üniteyi açmak için en az %70 gerekiyor. Tekrar dene!'**
  String get resultUnitFailed;

  /// No description provided for @resultLevelPassed.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! {level} seviyesini tamamladın.'**
  String resultLevelPassed(String level);

  /// No description provided for @resultLevelFailed.
  ///
  /// In tr, this message translates to:
  /// **'Seviye sınavını 24 saat sonra tekrar deneyebilirsin. Yanlış kelimeler tekrar listene eklendi.'**
  String get resultLevelFailed;

  /// No description provided for @scorePercent.
  ///
  /// In tr, this message translates to:
  /// **'%{score}'**
  String scorePercent(int score);

  /// No description provided for @correctCount.
  ///
  /// In tr, this message translates to:
  /// **'{correct}/{total} doğru'**
  String correctCount(int correct, int total);

  /// No description provided for @wrongWordsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar etmen gereken kelimeler'**
  String get wrongWordsTitle;

  /// No description provided for @examNeedLearned.
  ///
  /// In tr, this message translates to:
  /// **'Seviye sınavı için kelimelerin en az %80\'ini öğrenmelisin (şu an %{percent}).'**
  String examNeedLearned(int percent);

  /// No description provided for @examRetryAt.
  ///
  /// In tr, this message translates to:
  /// **'Seviye sınavını {time} sonrasında tekrar deneyebilirsin.'**
  String examRetryAt(String time);

  /// No description provided for @levelBadge.
  ///
  /// In tr, this message translates to:
  /// **'{level} rozeti kazanıldı'**
  String levelBadge(String level);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
