import 'package:flutter/cupertino.dart';

class LegendGridLayoutDelegate extends MultiChildLayoutDelegate {
  final int length;
  final int? crossAxisCount;
  final double? rowHeight;
  final double? verticalSpacing;
  final double? horizontalSpacing;
  final List<double>? rowHeights;
  final bool? contentSizing;

  LegendGridLayoutDelegate({
    this.rowHeight,
    required this.length,
    this.crossAxisCount,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.rowHeights,
    this.contentSizing,
  });

  @override
  void performLayout(Size size) {
    if (crossAxisCount != null && rowHeights != null)
      layoutFixedCrossAxisWithHeight(crossAxisCount!, size);
    else if (crossAxisCount != null)
      layoutFixedCrossAxisCount(crossAxisCount!, size);
    else if (contentSizing != null) {
      layoutContent(size);
    }
  }

  void layoutContent(Size size) {
    final double width = size.width;
    final double height = size.height;

    Size childSize = Size.zero;
    Offset position = Offset.zero;
    for (var i = 0; i < length; i++) {
      if (hasChild(i)) {
        childSize = layoutChild(
          i,
          BoxConstraints.loose(Size(size.width, rowHeight ?? size.height)),
        );

        if (position.dx + childSize.width > width && i != 0) {
          position = Offset(0, position.dy + (rowHeight ?? 10));
        }

        positionChild(i, position);

        double nextX = position.dx + childSize.width;

        position = Offset(nextX, position.dy);
      }
    }
  }

  void layoutFixedCrossAxisCount(int crossAxisCount, Size size) {
    final double width = size.width;
    final double height = size.height;
    int rows = (length / crossAxisCount).ceil();
    int vertical_spacings = rows - 1;
    int horizontal_spacings = crossAxisCount - 1;

    double itemWidth;
    if (horizontalSpacing != null) {
      itemWidth =
          (width - (horizontalSpacing! * horizontal_spacings)) / crossAxisCount;
    } else {
      itemWidth = width / crossAxisCount;
    }

    double rHeight;
    if (rowHeight != null) {
      rHeight = rowHeight!;
    } else if (verticalSpacing != null) {
      rHeight = (height - (verticalSpacing! * vertical_spacings)) / rows;
    } else {
      rHeight = height / rows;
    }

    Size childSize = Size.zero;
    Offset position = Offset.zero;
    for (var i = 0; i < length; i++) {
      if (hasChild(i)) {
        if (rowHeights != null) {
          rHeight = rowHeights![i];
        }

        childSize = layoutChild(
          i,
          BoxConstraints.expand(
            width: itemWidth,
            height: rHeight,
          ),
        );
        positionChild(i, position);

        if ((i + 1) % crossAxisCount == 0 && i != 0) {
          position = Offset(0, position.dy + rHeight);
          if (verticalSpacing != null) {
            position = Offset(position.dx, position.dy + verticalSpacing!);
          }
        } else {
          position = Offset(position.dx + childSize.width, position.dy);
          if (horizontalSpacing != null) {
            position = Offset(position.dx + horizontalSpacing!, position.dy);
          }
        }
      }
    }
  }

  double getTop(int index) {
    double height = 0;
    int top = (index / crossAxisCount!).floor();

    for (var i = 1; i < top + 1; i++) {
      index -= crossAxisCount!;
      height += rowHeights![index];
      if (verticalSpacing != null) {
        height += verticalSpacing!;
      }
    }
    return height;
  }

  void layoutFixedCrossAxisWithHeight(int crossAxisCount, Size size) {
    final double width = size.width;
    final double height = size.height;
    int rows = (length / crossAxisCount).ceil();
    int vertical_spacings = rows - 1;
    int horizontal_spacings = crossAxisCount - 1;

    double itemWidth;
    if (horizontalSpacing != null) {
      itemWidth =
          (width - (horizontalSpacing! * horizontal_spacings)) / crossAxisCount;
    } else {
      itemWidth = width / crossAxisCount;
    }

    Size childSize = Size.zero;
    Offset position = Offset.zero;
    for (var i = 0; i < length; i++) {
      if (hasChild(i)) {
        double rowHeight = rowHeights![i];
        bool isFirstRow = i < crossAxisCount;
        bool isLastInRow = ((i + 1) % crossAxisCount == 0 && i != 0);

        if (isFirstRow) {
          position = Offset(position.dx, 0);
        } else {
          double upperChildHeight = getTop(i);

          position = Offset(position.dx, upperChildHeight);
        }

        childSize = layoutChild(
          i,
          BoxConstraints.expand(
            width: itemWidth,
            height: rowHeight,
          ),
        );
        positionChild(i, position);

        if (isLastInRow) {
          position = Offset(0, position.dy);
        } else {
          position = Offset(position.dx + childSize.width, position.dy);
          if (horizontalSpacing != null) {
            position = Offset(position.dx + horizontalSpacing!, position.dy);
          }
        }
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
