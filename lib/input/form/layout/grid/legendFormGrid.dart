import 'package:flutter/material.dart';
import 'package:legend_design_widgets/input/form/layout/grid/legendGridLayoutDelegate.dart';

class LegendFormGrid {
  final List<dynamic> children;
  final double? verticalSpacing;
  final double? horizontalSpacing;
  final double? rowHeight;
  final List<double>? rowHeights;
  final int crossAxisCount;

  LegendFormGrid({
    required this.children,
    required this.crossAxisCount,
    this.rowHeight,
    this.horizontalSpacing,
    this.rowHeights,
    this.verticalSpacing,
  });
}

class LegendGrid extends StatelessWidget {
  final List<dynamic> children;
  late final List<LayoutId> layout;

  final double? verticalSpacing;
  final double? horizontalSpacing;
  final double? rowHeight;
  final List<double>? rowHeights;
  final int? crossAxisCount;
  final bool? contentSizing;

  LegendGrid({
    required this.children,
    this.crossAxisCount,
    this.rowHeight,
    this.horizontalSpacing,
    this.rowHeights,
    this.verticalSpacing,
    this.contentSizing,
  }) {
    layout = getLayout();
  }

  //https://stackoverflow.com/questions/59483051/how-to-use-custommultichildlayout-customsinglechildlayout-in-flutter/59483482

  List<LayoutId> getLayout() {
    List<LayoutId> list = [];
    for (var i = 0; i < children.length; i++) {
      list.add(
        LayoutId(
          id: i,
          child: children[i],
        ),
      );
    }
    return list;
  }

  factory LegendGrid.fixedCrossAxisCount({
    required List<dynamic> children,
    required int crossAxisCount,
    double? rowHeight,
    double? horizontalSpacing,
    double? verticalSpacing,
  }) {
    return LegendGrid(
      children: children,
      crossAxisCount: crossAxisCount,
      rowHeight: rowHeight,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
    );
  }

  factory LegendGrid.contentSized({
    required List<dynamic> children,
    double? horizontalSpacing,
    double? rowHeight,
    double? verticalSpacing,
  }) {
    return LegendGrid(
      children: children,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
      contentSizing: true,
      rowHeight: rowHeight,
    );
  }

  factory LegendGrid.fixedCrossAxisCountWithHeighz({
    required List<Widget> children,
    required int crossAxisCount,
    required List<double> rowHeights,
    double? horizontalSpacing,
    double? verticalSpacing,
  }) {
    return LegendGrid(
      children: children,
      crossAxisCount: crossAxisCount,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
      rowHeights: rowHeights,
    );
  }

  factory LegendGrid.custom({
    required List<Widget> children,
    required int crossAxisCount,
    required List<double> rowHeights,
    double? horizontalSpacing,
    double? verticalSpacing,
  }) {
    return LegendGrid(
      children: children,
      crossAxisCount: crossAxisCount,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
      rowHeights: rowHeights,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double mWidth = constraints.maxWidth;
      double mHeight = constraints.maxHeight;

      if (mHeight == double.infinity) {
        int rows = -1;
        mHeight = 400;
        if (crossAxisCount != null) {
          rows = (children.length / crossAxisCount!).ceil();

          // Speficic row Height
          if (rowHeight != null) {
            mHeight = rows * rowHeight!;
            if (verticalSpacing != null)
              mHeight += (rows - 1) * verticalSpacing!;
          }

          // Speficic Item Heights
          double maxHight = 0;
          if (rowHeights != null) {
            for (var i = 0; i < crossAxisCount!; i++) {
              double height = 0;
              for (var j = i; j < rowHeights!.length; j += crossAxisCount!) {
                height += rowHeights![j];
              }
              if (height > maxHight) {
                maxHight = height;
              }
            }
            if (verticalSpacing != null)
              maxHight += (rows - 1) * verticalSpacing!;
            mHeight = maxHight;
          }
        }
      }

      return Container(
        constraints: BoxConstraints(
          maxHeight: mHeight,
          maxWidth: mWidth,
        ),
        child: CustomMultiChildLayout(
          delegate: LegendGridLayoutDelegate(
            length: children.length,
            crossAxisCount: crossAxisCount,
            rowHeight: rowHeight,
            verticalSpacing: verticalSpacing,
            horizontalSpacing: horizontalSpacing,
            rowHeights: rowHeights,
            contentSizing: contentSizing,
          ),
          children: layout,
        ),
      );
    });
  }
}
