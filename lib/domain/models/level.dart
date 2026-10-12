/// Bir CEFR seviyesi (A1 … C2).
class Level {
  const Level({
    required this.id,
    required this.code,
    required this.sortOrder,
    required this.title,
  });

  final int id;
  final String code;
  final int sortOrder;
  final String title;
}
