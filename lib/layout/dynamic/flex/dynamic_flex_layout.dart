import 'items/legendLayoutItem.dart';

class DynamicFlexLayout {
  final List<double> splits;
  final List<LegendLayoutItem> items;
  late int _index;
  final double width;

  DynamicFlexLayout({
    required this.splits,
    required this.items,
    required this.width,
  }) {
    assert(
        splits.length == items.length && splits.isNotEmpty && items.isNotEmpty);

    _index = getIndex();
  }

  int get index => _index;

  int getIndex() {
    double lsplit = 0;
    for (var i = 0; i < splits.length; i++) {
      if (width < splits[i] && width >= lsplit) {
        return i;
      }
      if (i == splits.length - 1) {
        return i;
      }

      lsplit = splits[i];
    }

    return 0;
  }

  LegendLayoutItem get item => items[_index];
}
