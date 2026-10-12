extension ListExt on List {
  /// Memindahkan item dari index [from] ke index [to].
  ///
  /// Index tujuan akan disesuaikan jika item dipindahkan ke posisi setelahnya.
  void moveItem(int from, int to) {
    if (from == to) return;

    var targetIndex = to;
    final item = removeAt(from);

    // Sesuaikan index setelah item dihapus.
    if (from < targetIndex) targetIndex--;

    insert(targetIndex, item);
  }
}
