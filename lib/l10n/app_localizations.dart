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

  /// No description provided for @exScramble.
  ///
  /// In tr, this message translates to:
  /// **'Harfleri doğru sıraya diz'**
  String get exScramble;

  /// No description provided for @clearLetters.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clearLetters;

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

  /// No description provided for @streakFreezes.
  ///
  /// In tr, this message translates to:
  /// **'{count} seri koruması'**
  String streakFreezes(int count);

  /// No description provided for @streakFreezeHint.
  ///
  /// In tr, this message translates to:
  /// **'Her 7 günlük seride bir koruma kazanırsın (en fazla 2). Bir günü kaçırırsan koruma serini kurtarır.'**
  String get streakFreezeHint;

  /// No description provided for @noteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Notum'**
  String get noteTitle;

  /// No description provided for @synonyms.
  ///
  /// In tr, this message translates to:
  /// **'Eş anlamlı'**
  String get synonyms;

  /// No description provided for @antonyms.
  ///
  /// In tr, this message translates to:
  /// **'Zıt anlamlı'**
  String get antonyms;

  /// No description provided for @wordFamily.
  ///
  /// In tr, this message translates to:
  /// **'Kelime ailesi'**
  String get wordFamily;

  /// No description provided for @noteHint.
  ///
  /// In tr, this message translates to:
  /// **'Bu kelimeyle ilgili kendi notun'**
  String get noteHint;

  /// No description provided for @addNote.
  ///
  /// In tr, this message translates to:
  /// **'Not ekle'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In tr, this message translates to:
  /// **'Notu düzenle'**
  String get editNote;

  /// No description provided for @saveNote.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get saveNote;

  /// No description provided for @streakDays.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün seri'**
  String streakDays(int count);

  /// No description provided for @xpTotal.
  ///
  /// In tr, this message translates to:
  /// **'{xp} XP'**
  String xpTotal(int xp);

  /// No description provided for @dailyGoal.
  ///
  /// In tr, this message translates to:
  /// **'Günlük hedef'**
  String get dailyGoal;

  /// No description provided for @dailyGoalProgress.
  ///
  /// In tr, this message translates to:
  /// **'{done}/{target} yeni kelime'**
  String dailyGoalProgress(int done, int target);

  /// No description provided for @goalDone.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü hedef tamamlandı!'**
  String get goalDone;

  /// No description provided for @dueToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün tekrar edilecek {count} kelime'**
  String dueToday(int count);

  /// No description provided for @startReview.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlara başla'**
  String get startReview;

  /// No description provided for @noReviews.
  ///
  /// In tr, this message translates to:
  /// **'Şu an tekrar edilecek kelime yok.'**
  String get noReviews;

  /// No description provided for @nextUnit.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki ünite: {title}'**
  String nextUnit(String title);

  /// No description provided for @learnNewWords.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kelimeler'**
  String get learnNewWords;

  /// No description provided for @reviewOverload.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla tekrar birikti. Bugün yeni kelime sayısı azaltıldı; önce tekrarları bitir.'**
  String get reviewOverload;

  /// No description provided for @newWordQuota.
  ///
  /// In tr, this message translates to:
  /// **'Bugün {count} yeni kelime daha öğrenebilirsin.'**
  String newWordQuota(int count);

  /// No description provided for @reviewsFirst.
  ///
  /// In tr, this message translates to:
  /// **'Önce tekrarlarını bitirmeni öneririz.'**
  String get reviewsFirst;

  /// No description provided for @reviewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar'**
  String get reviewTitle;

  /// No description provided for @resultReview.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar tamamlandı'**
  String get resultReview;

  /// No description provided for @xpGained.
  ///
  /// In tr, this message translates to:
  /// **'+{xp} XP'**
  String xpGained(int xp);

  /// No description provided for @allUnitsDone.
  ///
  /// In tr, this message translates to:
  /// **'Açık tüm üniteleri tamamladın. Haritadan seviye sınavına girebilirsin.'**
  String get allUnitsDone;

  /// No description provided for @backToHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfaya dön'**
  String get backToHome;

  /// No description provided for @onboardingSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get onboardingNext;

  /// No description provided for @intro1Title.
  ///
  /// In tr, this message translates to:
  /// **'Seviye seviye ilerle'**
  String get intro1Title;

  /// No description provided for @intro1Body.
  ///
  /// In tr, this message translates to:
  /// **'A1\'den C2\'ye kadar kelimeleri ünite ünite öğren. Her seviyenin sonunda bir sınavla bir üst seviyenin kilidini aç.'**
  String get intro1Body;

  /// No description provided for @intro2Title.
  ///
  /// In tr, this message translates to:
  /// **'Unutmadan öğren'**
  String get intro2Title;

  /// No description provided for @intro2Body.
  ///
  /// In tr, this message translates to:
  /// **'Aralıklı tekrar sistemi, her kelimeyi tam unutmak üzereyken karşına çıkarır.'**
  String get intro2Body;

  /// No description provided for @intro3Title.
  ///
  /// In tr, this message translates to:
  /// **'Her gün biraz'**
  String get intro3Title;

  /// No description provided for @intro3Body.
  ///
  /// In tr, this message translates to:
  /// **'Günlük hedefini tamamla, serini koru ve XP kazan.'**
  String get intro3Body;

  /// No description provided for @goalQuestion.
  ///
  /// In tr, this message translates to:
  /// **'İngilizceyi ne için öğreniyorsun?'**
  String get goalQuestion;

  /// No description provided for @goalGeneral.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get goalGeneral;

  /// No description provided for @goalTravel.
  ///
  /// In tr, this message translates to:
  /// **'Seyahat'**
  String get goalTravel;

  /// No description provided for @goalWork.
  ///
  /// In tr, this message translates to:
  /// **'İş'**
  String get goalWork;

  /// No description provided for @goalExam.
  ///
  /// In tr, this message translates to:
  /// **'Sınav'**
  String get goalExam;

  /// No description provided for @targetQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Günde kaç yeni kelime öğrenmek istersin?'**
  String get targetQuestion;

  /// No description provided for @targetOption.
  ///
  /// In tr, this message translates to:
  /// **'Günde {count} kelime'**
  String targetOption(int count);

  /// No description provided for @notifyQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Sana ne zaman hatırlatalım?'**
  String get notifyQuestion;

  /// No description provided for @notifyNone.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma istemiyorum'**
  String get notifyNone;

  /// No description provided for @notifyPick.
  ///
  /// In tr, this message translates to:
  /// **'Başka bir saat seç'**
  String get notifyPick;

  /// No description provided for @startQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Nereden başlamak istersin?'**
  String get startQuestion;

  /// No description provided for @startPlacement.
  ///
  /// In tr, this message translates to:
  /// **'Seviye tespit sınavına gir'**
  String get startPlacement;

  /// No description provided for @startPlacementHint.
  ///
  /// In tr, this message translates to:
  /// **'En fazla 30 soru, yaklaşık 5 dakika.'**
  String get startPlacementHint;

  /// No description provided for @startFromA1.
  ///
  /// In tr, this message translates to:
  /// **'A1\'den başla'**
  String get startFromA1;

  /// No description provided for @placementTitle.
  ///
  /// In tr, this message translates to:
  /// **'Seviye tespit sınavı'**
  String get placementTitle;

  /// No description provided for @placementIntro.
  ///
  /// In tr, this message translates to:
  /// **'Sana İngilizce kelimeler göstereceğiz, Türkçe anlamını seç. Doğru bildikçe sorular zorlaşır, yanlışta kolaylaşır. Bilmediğin soruda tahmin yapmak yerine \"Bilmiyorum\"u seçebilirsin.'**
  String get placementIntro;

  /// No description provided for @placementStart.
  ///
  /// In tr, this message translates to:
  /// **'Sınava başla'**
  String get placementStart;

  /// No description provided for @placementDontKnow.
  ///
  /// In tr, this message translates to:
  /// **'Bilmiyorum'**
  String get placementDontKnow;

  /// No description provided for @placementQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Soru {current}'**
  String placementQuestion(int current);

  /// No description provided for @placementResultTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen seviye: {level}'**
  String placementResultTitle(String level);

  /// No description provided for @placementResultBody.
  ///
  /// In tr, this message translates to:
  /// **'{correct}/{total} soruyu doğru cevapladın. Bu seviyeden başlayabilir ya da daha düşük bir seviye seçebilirsin.'**
  String placementResultBody(int correct, int total);

  /// No description provided for @placementAccept.
  ///
  /// In tr, this message translates to:
  /// **'{level} seviyesinden başla'**
  String placementAccept(String level);

  /// No description provided for @placementLower.
  ///
  /// In tr, this message translates to:
  /// **'Daha düşük bir seviye seç'**
  String get placementLower;

  /// No description provided for @placementNoContent.
  ///
  /// In tr, this message translates to:
  /// **'Seviye tespiti için henüz yeterli kelime yok.'**
  String get placementNoContent;

  /// No description provided for @retakePlacement.
  ///
  /// In tr, this message translates to:
  /// **'Seviye tespit sınavını yeniden yap'**
  String get retakePlacement;

  /// No description provided for @retakePlacementHint.
  ///
  /// In tr, this message translates to:
  /// **'Atladığın seviyelerin kelimeleri bilinen olarak işaretlenir.'**
  String get retakePlacementHint;

  /// No description provided for @sectionLearning.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenme'**
  String get sectionLearning;

  /// No description provided for @sectionNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get sectionNotifications;

  /// No description provided for @sectionSoundTheme.
  ///
  /// In tr, this message translates to:
  /// **'Ses ve görünüm'**
  String get sectionSoundTheme;

  /// No description provided for @sectionData.
  ///
  /// In tr, this message translates to:
  /// **'Veri'**
  String get sectionData;

  /// No description provided for @settingDailyTarget.
  ///
  /// In tr, this message translates to:
  /// **'Günlük yeni kelime hedefi'**
  String get settingDailyTarget;

  /// No description provided for @settingReminder.
  ///
  /// In tr, this message translates to:
  /// **'Günlük hatırlatma'**
  String get settingReminder;

  /// No description provided for @settingReminderTime.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma saati'**
  String get settingReminderTime;

  /// No description provided for @settingStreakWarning.
  ///
  /// In tr, this message translates to:
  /// **'Akşam seri uyarısı'**
  String get settingStreakWarning;

  /// No description provided for @settingAccent.
  ///
  /// In tr, this message translates to:
  /// **'Aksan'**
  String get settingAccent;

  /// No description provided for @accentUs.
  ///
  /// In tr, this message translates to:
  /// **'Amerikan'**
  String get accentUs;

  /// No description provided for @accentUk.
  ///
  /// In tr, this message translates to:
  /// **'İngiliz'**
  String get accentUk;

  /// No description provided for @settingSpeechRate.
  ///
  /// In tr, this message translates to:
  /// **'Konuşma hızı'**
  String get settingSpeechRate;

  /// No description provided for @settingTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get settingTheme;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @settingSound.
  ///
  /// In tr, this message translates to:
  /// **'Ses efektleri'**
  String get settingSound;

  /// No description provided for @settingHaptics.
  ///
  /// In tr, this message translates to:
  /// **'Titreşim'**
  String get settingHaptics;

  /// No description provided for @resetProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerlemeyi sıfırla'**
  String get resetProgress;

  /// No description provided for @resetProgressHint.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenme geçmişi, XP ve seri silinir. Ayarlar ve favoriler korunur.'**
  String get resetProgressHint;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme sıfırlansın mı?'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz.'**
  String get resetConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @resetAction.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get resetAction;

  /// No description provided for @resetDone.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme sıfırlandı.'**
  String get resetDone;

  /// No description provided for @statsLearned.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenilen kelime'**
  String get statsLearned;

  /// No description provided for @statsStudied.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime çalışıldı'**
  String statsStudied(int count);

  /// No description provided for @stateNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni'**
  String get stateNew;

  /// No description provided for @stateLearning.
  ///
  /// In tr, this message translates to:
  /// **'Öğreniliyor'**
  String get stateLearning;

  /// No description provided for @stateReview.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarda'**
  String get stateReview;

  /// No description provided for @stateMastered.
  ///
  /// In tr, this message translates to:
  /// **'Ustalaşıldı'**
  String get stateMastered;

  /// No description provided for @statsActivity.
  ///
  /// In tr, this message translates to:
  /// **'Günlük aktivite'**
  String get statsActivity;

  /// No description provided for @stats7Days.
  ///
  /// In tr, this message translates to:
  /// **'7 gün'**
  String get stats7Days;

  /// No description provided for @stats30Days.
  ///
  /// In tr, this message translates to:
  /// **'30 gün'**
  String get stats30Days;

  /// No description provided for @statsNewWords.
  ///
  /// In tr, this message translates to:
  /// **'Yeni'**
  String get statsNewWords;

  /// No description provided for @statsReviews.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar'**
  String get statsReviews;

  /// No description provided for @statsMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{count} dk'**
  String statsMinutes(int count);

  /// No description provided for @statsActivitySummary.
  ///
  /// In tr, this message translates to:
  /// **'{newWords} yeni kelime, {reviews} tekrar, {minutes} dakika'**
  String statsActivitySummary(int newWords, int reviews, int minutes);

  /// No description provided for @statsLevels.
  ///
  /// In tr, this message translates to:
  /// **'Seviye ilerlemesi'**
  String get statsLevels;

  /// No description provided for @statsNoActivity.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönemde çalışma yok.'**
  String get statsNoActivity;

  /// No description provided for @statsHeatmap.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma takvimi'**
  String get statsHeatmap;

  /// No description provided for @statsHeatmapSummary.
  ///
  /// In tr, this message translates to:
  /// **'Son 12 haftada {count} gün çalıştın'**
  String statsHeatmapSummary(int count);

  /// No description provided for @wordOfDay.
  ///
  /// In tr, this message translates to:
  /// **'Günün kelimesi'**
  String get wordOfDay;

  /// No description provided for @statsAccuracy.
  ///
  /// In tr, this message translates to:
  /// **'Doğruluk oranı'**
  String get statsAccuracy;

  /// No description provided for @statsAccuracyOverall.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 günde %{percent} doğru ({count} cevap)'**
  String statsAccuracyOverall(int percent, int count);

  /// No description provided for @statsNoAnswers.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 günde cevap yok.'**
  String get statsNoAnswers;

  /// No description provided for @statsForecast.
  ///
  /// In tr, this message translates to:
  /// **'Gelecek tekrarlar'**
  String get statsForecast;

  /// No description provided for @statsForecastSummary.
  ///
  /// In tr, this message translates to:
  /// **'Önümüzdeki 7 günde {count} tekrar planlandı'**
  String statsForecastSummary(int count);

  /// No description provided for @statsForecastToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get statsForecastToday;

  /// No description provided for @exLabelMcEnTr.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce → Türkçe'**
  String get exLabelMcEnTr;

  /// No description provided for @exLabelMcTrEn.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe → İngilizce'**
  String get exLabelMcTrEn;

  /// No description provided for @exLabelListen.
  ///
  /// In tr, this message translates to:
  /// **'Dinleme'**
  String get exLabelListen;

  /// No description provided for @exLabelTyping.
  ///
  /// In tr, this message translates to:
  /// **'Yazma'**
  String get exLabelTyping;

  /// No description provided for @exLabelFillBlank.
  ///
  /// In tr, this message translates to:
  /// **'Boşluk doldurma'**
  String get exLabelFillBlank;

  /// No description provided for @exLabelMatching.
  ///
  /// In tr, this message translates to:
  /// **'Eşleştirme'**
  String get exLabelMatching;

  /// No description provided for @exLabelScramble.
  ///
  /// In tr, this message translates to:
  /// **'Harf karıştırma'**
  String get exLabelScramble;

  /// No description provided for @filterDifficult.
  ///
  /// In tr, this message translates to:
  /// **'Zorlandıklarım'**
  String get filterDifficult;

  /// No description provided for @practiceFavorites.
  ///
  /// In tr, this message translates to:
  /// **'Favorileri çalış'**
  String get practiceFavorites;

  /// No description provided for @practiceDifficult.
  ///
  /// In tr, this message translates to:
  /// **'Zorlandıklarımı çalış'**
  String get practiceDifficult;

  /// No description provided for @myLists.
  ///
  /// In tr, this message translates to:
  /// **'Listelerim'**
  String get myLists;

  /// No description provided for @newList.
  ///
  /// In tr, this message translates to:
  /// **'Yeni liste'**
  String get newList;

  /// No description provided for @renameList.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden adlandır'**
  String get renameList;

  /// No description provided for @deleteList.
  ///
  /// In tr, this message translates to:
  /// **'Listeyi sil'**
  String get deleteList;

  /// No description provided for @practiceList.
  ///
  /// In tr, this message translates to:
  /// **'Listeyle çalış'**
  String get practiceList;

  /// No description provided for @addToList.
  ///
  /// In tr, this message translates to:
  /// **'Listeye ekle'**
  String get addToList;

  /// No description provided for @listNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Liste adı'**
  String get listNameHint;

  /// No description provided for @noLists.
  ///
  /// In tr, this message translates to:
  /// **'Henüz listen yok. Kelimeleri kendi listelerinde toplamak için yeni bir liste oluştur.'**
  String get noLists;

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce ya da Türkçe ara'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In tr, this message translates to:
  /// **'Aramayı temizle'**
  String get clearSearch;

  /// No description provided for @filterFavorites.
  ///
  /// In tr, this message translates to:
  /// **'Favoriler'**
  String get filterFavorites;

  /// No description provided for @filterAllLevels.
  ///
  /// In tr, this message translates to:
  /// **'Tüm seviyeler'**
  String get filterAllLevels;

  /// No description provided for @filterAllStates.
  ///
  /// In tr, this message translates to:
  /// **'Tüm durumlar'**
  String get filterAllStates;

  /// No description provided for @resultCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime'**
  String resultCount(int count);

  /// No description provided for @noResults.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı.'**
  String get noResults;

  /// No description provided for @notifReminderTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kelime zamanı!'**
  String get notifReminderTitle;

  /// No description provided for @notifReminderBody.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü kelimelerin ve tekrarların seni bekliyor.'**
  String get notifReminderBody;

  /// No description provided for @notifStreakTitle.
  ///
  /// In tr, this message translates to:
  /// **'Serin tehlikede!'**
  String get notifStreakTitle;

  /// No description provided for @notifStreakBody.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü hedefini henüz tamamlamadın. Birkaç dakika ayır, serini koru.'**
  String get notifStreakBody;

  /// No description provided for @settingQuietHours.
  ///
  /// In tr, this message translates to:
  /// **'Sessiz saatler'**
  String get settingQuietHours;

  /// No description provided for @settingQuietHoursHint.
  ///
  /// In tr, this message translates to:
  /// **'Bu saatlerde bildirim gönderilmez.'**
  String get settingQuietHoursHint;

  /// No description provided for @settingQuietStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get settingQuietStart;

  /// No description provided for @settingQuietEnd.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get settingQuietEnd;

  /// No description provided for @notifPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni verilmedi. Hatırlatmalar için izni cihaz ayarlarından açabilirsin.'**
  String get notifPermissionDenied;

  /// No description provided for @badgesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rozetler'**
  String get badgesTitle;

  /// No description provided for @badgeFirstWord.
  ///
  /// In tr, this message translates to:
  /// **'İlk kelime'**
  String get badgeFirstWord;

  /// No description provided for @badgeWords.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime'**
  String badgeWords(int count);

  /// No description provided for @badgeStreak.
  ///
  /// In tr, this message translates to:
  /// **'{count} günlük seri'**
  String badgeStreak(int count);

  /// No description provided for @badgeLevel.
  ///
  /// In tr, this message translates to:
  /// **'{level} tamamlandı'**
  String badgeLevel(String level);

  /// No description provided for @newBadge.
  ///
  /// In tr, this message translates to:
  /// **'Yeni rozet: {name}'**
  String newBadge(String name);

  /// No description provided for @badgeEarned.
  ///
  /// In tr, this message translates to:
  /// **'Kazanıldı'**
  String get badgeEarned;

  /// No description provided for @badgeLocked.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kazanılmadı'**
  String get badgeLocked;

  /// No description provided for @matchTimeLeft.
  ///
  /// In tr, this message translates to:
  /// **'{seconds} sn'**
  String matchTimeLeft(int seconds);

  /// No description provided for @matchTimeUp.
  ///
  /// In tr, this message translates to:
  /// **'Süre doldu!'**
  String get matchTimeUp;
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
