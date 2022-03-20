import 'package:flutter/widgets.dart';

import 'items/legendFlexItem.dart';
import 'items/legendLayoutItem.dart';

class LegendCustomFlexDelegate extends MultiChildLayoutDelegate {
  final LegendLayoutItem item;

  LegendCustomFlexDelegate(this.item);

  @override
  void performLayout(Size size) {
    layoutItem(
      item,
      size,
      Offset.zero,
    );
  }

  layoutItem(LegendLayoutItem item, Size size, Offset pos) {
    if (item is LegendLayoutWidget) {
      int id = item.layoutId;
      if (hasChild(id)) {
        Size widgetSize = layoutChild(
          id,
          BoxConstraints.loose(Size(size.width, size.height)),
        );

        positionChild(id, pos);
      }
    } else if (item is LegendLayoutColumn) {
      List<LegendLayoutItem> items = item.children;
      List<double>? heights;
      double spacing = item.spacing ?? 0;
      double c_height = pos.dy;
      double mHeight = size.height - spacing * (items.length - 1);

      if (item.childrenFlex != null) {
        heights = getSplitsFromFlex(mHeight, item.childrenFlex!);
      }

      for (int i = 0; i < items.length; i++) {
        LegendLayoutItem col_i = items[i];

        double height = item.childrenFlex == null
            ? mHeight / item.children.length
            : heights![i];

        Size childSize = Size(size.width, height);
        Offset newPoss = Offset(pos.dx, c_height);

        layoutItem(col_i, childSize, newPoss);
        c_height += childSize.height;
        if (i != items.length - 1) {
          c_height += spacing;
        }
      }
    } else if (item is LegendLayoutRow) {
      List<LegendLayoutItem> items = item.children;
      double spacing = item.spacing ?? 0;
      List<double>? widths;
      double c_width = pos.dx;

      double mWidth = size.width - spacing * (items.length - 1);

      if (item.childrenFlex != null) {
        widths = getSplitsFromFlex(mWidth, item.childrenFlex!);
      }

      for (int i = 0; i < items.length; i++) {
        LegendLayoutItem row_i = items[i];
        double width =
            item.childrenFlex == null ? mWidth / items.length : widths![i];

        Size childSize = Size(width, size.height);
        Offset newPoss = Offset(c_width, pos.dy);
        layoutItem(row_i, childSize, newPoss);

        c_width += childSize.width;
        if (i != items.length - 1) {
          c_width += spacing;
        }
      }
    }
  }

  List<double> getSplitsFromFlex(
      double maxWidth, List<ChildrenFlexItem> flexList) {
    double flexMaxVal = 0;
    double filledSpace = 0;

    List<double> flexWidths = [];
    List<int> flexIndexes = [];

    for (int i = 0; i < flexList.length; i++) {
      ChildrenFlexItem flex = flexList[i];
      if (flex is ChildrenFlexValue) {
        flexMaxVal += flex.value;
        flexWidths.add(-1);
        flexIndexes.add(i);
      } else if (flex is ChildrenFlexWidth) {
        filledSpace += flex.value;
        flexWidths.add(flex.value as double);
      }
    }
    ;

    double split = (maxWidth - filledSpace) / flexMaxVal;

    for (int i = 0; i < flexList.length; i++) {
      ChildrenFlexItem flex = flexList[i];
      if (flex is ChildrenFlexValue) {
        flexWidths[i] = (flex.value * split);
      }
    }

    return flexWidths;
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
