import 'legendFlexItem.dart';

enum LayoutItemType {
  WIDGET,
  COLUMN,
  ROW,
  NONE,
}

abstract class LegendLayoutItem {
  final LayoutItemType type;

  LegendLayoutItem(this.type);
}

class LegendLayoutNone extends LegendLayoutItem {
  LegendLayoutNone() : super(LayoutItemType.NONE);
}

class LegendLayoutWidget extends LegendLayoutItem {
  final int layoutId;
  final int? flex;

  LegendLayoutWidget(
    this.layoutId, {
    this.flex,
  }) : super(LayoutItemType.WIDGET);
}

class LegendLayoutRow extends LegendLayoutItem {
  final List<LegendLayoutItem> children;
  final List<ChildrenFlexItem>? childrenFlex;
  final double? spacing;

  LegendLayoutRow({
    required this.children,
    this.childrenFlex,
    this.spacing,
  }) : super(LayoutItemType.ROW) {
    if (childrenFlex != null) assert(childrenFlex!.length == children.length);
  }
}

class LegendLayoutColumn extends LegendLayoutItem {
  final List<LegendLayoutItem> children;
  final List<ChildrenFlexItem>? childrenFlex;
  final double? spacing;

  LegendLayoutColumn({
    required this.children,
    this.childrenFlex,
    this.spacing,
  }) : super(LayoutItemType.COLUMN) {
    if (childrenFlex != null) assert(childrenFlex!.length == children.length);
  }
}
