/// Oturumda biriken çalışma süresinden şimdi kaydedilecek kısmı ayırır
/// (FR-81, NFR-05).
///
/// Oturum sürerken yalnız tam dakikalar kaydedilir, artan saniyeler bir sonraki
/// cevaba aktarılır. Böylece uygulama oturum ortasında kapansa da geçen
/// sürenin en fazla bir dakikası kaybolur ve dakikalar yukarı yuvarlanarak
/// şişmez. Oturum bitince ([finished]) kalanın tamamı kaydedilir.
({Duration save, Duration keep}) splitStudyTime(
  Duration unsaved, {
  required bool finished,
}) {
  if (unsaved <= Duration.zero) {
    return (save: Duration.zero, keep: Duration.zero);
  }
  if (finished) return (save: unsaved, keep: Duration.zero);
  final whole = Duration(minutes: unsaved.inMinutes);
  return (save: whole, keep: unsaved - whole);
}
