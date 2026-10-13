import '../models/word.dart';
import '../srs/card_state.dart';

/// Kelimelerim ekranındaki bir satır.
class WordEntry {
  const WordEntry({
    required this.word,
    required this.levelCode,
    this.state = CardState.newCard,
    this.favorite = false,
  });

  final Word word;
  final String levelCode;
  final CardState state;
  final bool favorite;
}

/// Arama filtreleri (FR-90).
class WordFilter {
  const WordFilter({
    this.query = '',
    this.levelCode,
    this.state,
    this.favoritesOnly = false,
  });

  final String query;

  /// `null` ise tüm seviyeler.
  final String? levelCode;

  /// `null` ise tüm durumlar.
  final CardState? state;
  final bool favoritesOnly;

  WordFilter copyWith({
    String? query,
    String? Function()? levelCode,
    CardState? Function()? state,
    bool? favoritesOnly,
  }) => WordFilter(
    query: query ?? this.query,
    levelCode: levelCode != null ? levelCode() : this.levelCode,
    state: state != null ? state() : this.state,
    favoritesOnly: favoritesOnly ?? this.favoritesOnly,
  );
}

const _fold = {
  'ı': 'i',
  'İ': 'i',
  'I': 'i',
  'ş': 's',
  'Ş': 's',
  'ğ': 'g',
  'Ğ': 'g',
  'ü': 'u',
  'Ü': 'u',
  'ö': 'o',
  'Ö': 'o',
  'ç': 'c',
  'Ç': 'c',
};

/// Büyük/küçük harf ve Türkçe karakter farkını yok sayar
/// ("kirmizi" ile "kırmızı" eşleşir).
String foldText(String text) {
  final buffer = StringBuffer();
  for (final rune in text.trim().runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_fold[char] ?? char.toLowerCase());
  }
  return buffer.toString();
}

/// İngilizce ve Türkçe arama, seviye, durum ve favori filtresi (FR-90).
/// Tam ve baştan eşleşmeler önce, sonra alfabetik sıralanır.
List<WordEntry> searchWords(List<WordEntry> entries, WordFilter filter) {
  final q = foldText(filter.query);
  int rank(WordEntry e) {
    if (q.isEmpty) return 0;
    final en = foldText(e.word.lemma);
    final tr = foldText(e.word.meaningTr);
    if (en == q || tr == q) return 0;
    if (en.startsWith(q) || tr.startsWith(q)) return 1;
    if (en.contains(q) || tr.contains(q)) return 2;
    return -1;
  }

  final matches = <(int, WordEntry)>[];
  for (final e in entries) {
    if (filter.levelCode != null && e.levelCode != filter.levelCode) continue;
    if (filter.state != null && e.state != filter.state) continue;
    if (filter.favoritesOnly && !e.favorite) continue;
    final r = rank(e);
    if (r >= 0) matches.add((r, e));
  }
  matches.sort((a, b) {
    final byRank = a.$1.compareTo(b.$1);
    if (byRank != 0) return byRank;
    return a.$2.word.lemma.toLowerCase().compareTo(
      b.$2.word.lemma.toLowerCase(),
    );
  });
  return [for (final m in matches) m.$2];
}
