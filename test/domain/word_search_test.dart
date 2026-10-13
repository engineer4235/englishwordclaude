import 'package:english_word_learning/domain/search/word_search.dart';
import 'package:english_word_learning/domain/srs/card_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  final entries = [
    for (final w in seedWords())
      WordEntry(
        word: w,
        levelCode: w.unitId == 3 ? 'A2' : 'A1',
        state: w.lemma == 'red' ? CardState.learning : CardState.newCard,
        favorite: w.lemma == 'blue' || w.lemma == 'mother',
        difficult: w.lemma == 'red',
      ),
  ];

  List<String> lemmas(WordFilter f) => [
    for (final e in searchWords(entries, f)) e.word.lemma,
  ];

  test('boş aramada tüm kelimeler alfabetik gelir', () {
    final all = lemmas(const WordFilter());
    expect(all, hasLength(24));
    expect(all.first, 'baby');
  });

  test('İngilizce ve Türkçe arar, Türkçe karakterleri yok sayar (FR-90)', () {
    expect(lemmas(const WordFilter(query: 'kirmizi')), ['red']);
    expect(lemmas(const WordFilter(query: 'KIRMIZI')), ['red']);
    expect(lemmas(const WordFilter(query: 'Mother')), ['mother']);
    expect(lemmas(const WordFilter(query: 'xyz')), isEmpty);
  });

  test('tam eşleşme önce, sonra baştan eşleşme', () {
    final r = lemmas(const WordFilter(query: 'on'));
    expect(r.first, 'ten', reason: '"on" Türkçede tam eşleşme');
    expect(r[1], 'one');
  });

  test('seviye, durum ve favori filtreleri', () {
    expect(lemmas(const WordFilter(levelCode: 'A2')), hasLength(8));
    expect(lemmas(const WordFilter(state: CardState.learning)), ['red']);
    expect(lemmas(const WordFilter(favoritesOnly: true)), ['blue', 'mother']);
    const f = WordFilter(levelCode: 'A1', favoritesOnly: true);
    expect(lemmas(f.copyWith(levelCode: () => null)), ['blue', 'mother']);
  });

  test('zorlanılan kelime filtresi (FR-66)', () {
    expect(lemmas(const WordFilter(difficultOnly: true)), ['red']);
    const f = WordFilter(difficultOnly: true);
    expect(lemmas(f.copyWith(difficultOnly: false)), hasLength(24));
  });

  test('foldText büyük harf ve Türkçe harfleri sadeleştirir', () {
    expect(foldText(' İĞÜŞÖÇı '), 'igusoci');
  });
}
