import 'items/legendLayoutItem.dart';

class DynamicLayout {
  final List<double> splits;
  final List<LegendLayoutItem> items;
  int lastIndex = -1;

  DynamicLayout({
    required this.splits,
    required this.items,
  }) {
    assert(splits.length == items.length);
  }

  LegendLayoutItem getItem(double width) {
    double lsplit = 0;
    for (var i = 0; i < splits.length; i++) {
      if (width < splits[i] && width >= lsplit) {
        lastIndex = i;
        return items[i];
      }
      if (i == splits.length - 1) {
        lastIndex = i;
        return items[i];
      }

      lsplit = splits[i];
    }
    lastIndex = 0;
    return items[0];
  }
}
