import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/util/csv.dart';
import '../../domain/srs/card_state.dart';
import '../db/app_database.dart';
import 'custom_word_repository.dart';

/// Kullanıcının verilerini dışa aktarır (FR-124).
///
/// JSON tam yedektir: profil, seviye ve ünite ilerlemesi, kelimeler, listeler,
/// günlük istatistikler ve rozetler. CSV yalnızca kelime tablosudur ve
/// Excel ya da Google E-Tablolar'da açılabilir.
class ExportRepository {
  ExportRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// JSON dosyasının biçim adı ve sürümü.
  static const format = 'english-word-learning-export';
  static const version = 1;

  Future<UserDataExport> collect() async {
    final levels = {
      for (final l in await _db.select(_db.levels).get()) l.id: l,
    };
    final units = {for (final u in await _db.select(_db.units).get()) u.id: u};
    final cards = {
      for (final c in await _db.select(_db.reviewCards).get()) c.wordId: c,
    };
    final favorites = {
      for (final f in await _db.select(_db.favorites).get()) f.wordId,
    };
    final notes = {
      for (final n in await _db.select(_db.wordNotes).get()) n.wordId: n.note,
    };
    final lists = await (_db.select(
      _db.wordLists,
    )..orderBy([(t) => OrderingTerm(expression: t.id)])).get();
    final listNames = {for (final l in lists) l.id: l.name};
    final listsOfWord = <int, List<String>>{};
    final wordsOfList = <int, List<int>>{};
    for (final item in await _db.select(_db.wordListItems).get()) {
      listsOfWord
          .putIfAbsent(item.wordId, () => [])
          .add(listNames[item.listId] ?? '');
      wordsOfList.putIfAbsent(item.listId, () => []).add(item.wordId);
    }
    final customUnitId = await CustomWordRepository(_db).unitId();

    final allWords = await (_db.select(
      _db.words,
    )..orderBy([(t) => OrderingTerm(expression: t.id)])).get();
    final lemmas = {for (final w in allWords) w.id: w.lemma};
    final words = <ExportedWord>[];
    for (final w in allWords) {
      final custom = w.unitId == customUnitId;
      final card = cards[w.id];
      if (card == null &&
          !favorites.contains(w.id) &&
          !notes.containsKey(w.id) &&
          !listsOfWord.containsKey(w.id) &&
          !custom) {
        continue;
      }
      final unit = units[w.unitId];
      words.add(
        ExportedWord(
          lemma: w.lemma,
          meaningTr: w.meaningTr,
          levelCode: custom ? '' : levels[unit?.levelId]?.code ?? '',
          unitTitle: custom ? '' : unit?.titleTr ?? '',
          state: CardState.fromDb(card?.state ?? CardState.newCard.dbValue),
          intervalDays: card?.intervalDays ?? 0,
          dueAt: card?.dueAt,
          lastReviewedAt: card?.lastReviewedAt,
          lapses: card?.lapses ?? 0,
          favorite: favorites.contains(w.id),
          note: notes[w.id],
          lists: listsOfWord[w.id] ?? const [],
          custom: custom,
        ),
      );
    }

    final profile = await _db.ensureProfile();
    final unitProgress = await _db.select(_db.unitProgress).get();
    final levelProgress = await _db.select(_db.levelProgress).get();
    final daily = await (_db.select(
      _db.dailyStats,
    )..orderBy([(t) => OrderingTerm(expression: t.day)])).get();
    final badges = await (_db.select(
      _db.badges,
    )..orderBy([(t) => OrderingTerm(expression: t.earnedAt)])).get();

    return UserDataExport(
      exportedAt: _clock(),
      words: words,
      data: {
        'profile': {
          'goalType': profile.goalType,
          'dailyTarget': profile.dailyTarget,
          'accent': profile.accent,
          'currentLevel': levels[profile.currentLevelId]?.code,
          'streak': profile.streak,
          'longestStreak': profile.longestStreak,
          'totalXp': profile.totalXp,
          'streakFreezes': profile.streakFreezes,
          'themeMode': profile.themeMode,
        },
        'levels': [
          for (final p in levelProgress)
            if (levels[p.levelId] != null)
              {
                'code': levels[p.levelId]!.code,
                'status': p.status,
                'examBestScore': p.examBestScore,
                'examLastAttemptAt': p.examLastAttemptAt?.toIso8601String(),
              },
        ],
        'units': [
          for (final p in unitProgress)
            if (units[p.unitId] case final unit? when unit.id != customUnitId)
              {
                'level': levels[unit.levelId]?.code,
                'title': unit.titleTr,
                'status': p.status,
                'bestScore': p.bestScore,
                'completedAt': p.completedAt?.toIso8601String(),
              },
        ],
        'lists': [
          for (final l in lists)
            {
              'name': l.name,
              'words': [
                for (final id in wordsOfList[l.id] ?? const <int>[]) lemmas[id],
              ],
            },
        ],
        'dailyStats': [
          for (final d in daily)
            {
              'day': d.day,
              'newWords': d.newWords,
              'reviews': d.reviews,
              'correct': d.correct,
              'xp': d.xp,
              'minutes': d.minutes,
              'goalMet': d.goalMet,
              'frozen': d.frozen,
            },
        ],
        'badges': [
          for (final b in badges)
            {'code': b.code, 'earnedAt': b.earnedAt.toIso8601String()},
        ],
      },
    );
  }
}

/// Dışa aktarılan bir kelime: öğrenme durumu ve kullanıcının eklediği bilgiler.
class ExportedWord {
  const ExportedWord({
    required this.lemma,
    required this.meaningTr,
    required this.levelCode,
    required this.unitTitle,
    required this.state,
    required this.intervalDays,
    required this.dueAt,
    required this.lastReviewedAt,
    required this.lapses,
    required this.favorite,
    required this.note,
    required this.lists,
    required this.custom,
  });

  final String lemma;
  final String meaningTr;
  final String levelCode;
  final String unitTitle;
  final CardState state;
  final int intervalDays;
  final DateTime? dueAt;
  final DateTime? lastReviewedAt;
  final int lapses;
  final bool favorite;
  final String? note;
  final List<String> lists;

  /// Kullanıcının kendi eklediği kelime (FR-92).
  final bool custom;

  Map<String, Object?> toJson() => {
    'lemma': lemma,
    'meaningTr': meaningTr,
    'level': levelCode,
    'unit': unitTitle,
    'state': state.dbValue,
    'intervalDays': intervalDays,
    'dueAt': dueAt?.toIso8601String(),
    'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    'lapses': lapses,
    'favorite': favorite,
    'note': note,
    'lists': lists,
    'custom': custom,
  };
}

/// Toplanan veriler; JSON ya da CSV metnine dönüştürülür.
class UserDataExport {
  const UserDataExport({
    required this.exportedAt,
    required this.words,
    required this.data,
  });

  final DateTime exportedAt;
  final List<ExportedWord> words;

  /// Kelimeler dışındaki bölümler.
  final Map<String, Object?> data;

  /// Okunabilir girintili JSON tam yedek.
  String toJson() => const JsonEncoder.withIndent('  ').convert({
    'format': ExportRepository.format,
    'version': ExportRepository.version,
    'exportedAt': exportedAt.toIso8601String(),
    ...data,
    'words': [for (final w in words) w.toJson()],
  });

  /// Kelime tablosu; her satır bir kelimedir.
  String toCsv() => csvDocument([
    csvHeader,
    for (final w in words)
      [
        w.lemma,
        w.meaningTr,
        w.levelCode,
        w.unitTitle,
        _stateLabel(w.state),
        '${w.intervalDays}',
        _date(w.dueAt),
        _date(w.lastReviewedAt),
        '${w.lapses}',
        w.favorite ? 'Evet' : '',
        w.note ?? '',
        w.lists.join('; '),
      ],
  ]);

  /// CSV başlık satırı.
  static const csvHeader = [
    'Kelime',
    'Anlam',
    'Seviye',
    'Ünite',
    'Durum',
    'Aralık (gün)',
    'Sonraki tekrar',
    'Son çalışma',
    'Unutma sayısı',
    'Favori',
    'Not',
    'Listeler',
  ];

  static String _stateLabel(CardState state) => switch (state) {
    CardState.newCard => 'Yeni',
    CardState.learning => 'Öğreniliyor',
    CardState.review => 'Tekrarda',
    CardState.mastered => 'Ustalaşıldı',
  };

  static String _date(DateTime? d) {
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
