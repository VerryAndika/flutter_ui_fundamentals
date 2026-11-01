// Breakpoint praktikum: compact < 600, medium 600-839, expanded >= 840.
enum WindowSize { compact, medium, expanded }

WindowSize windowSizeFor(double width) {
  if (width < 600) return WindowSize.compact;
  if (width < 840) return WindowSize.medium;
  return WindowSize.expanded;
}

// Jumlah kolom grid untuk setiap kategori lebar.
int columnsFor(double width) {
  if (width < 600) return 1;
  if (width < 840) return 2;
  return 3;
}
