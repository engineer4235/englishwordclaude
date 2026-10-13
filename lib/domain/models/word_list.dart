/// Kullanıcının kelime listesi (FR-91).
class WordList {
  const WordList({required this.id, required this.name, this.wordCount = 0});

  final int id;
  final String name;
  final int wordCount;
}
