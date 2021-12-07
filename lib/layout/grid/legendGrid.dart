import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/layouts/layout_type.dart';
import 'package:legend_design_core/styles/theming/sizing/size_provider.dart';
import 'package:legend_design_widgets/layout/grid/legendGridSize.dart';

class LegendGrid extends StatelessWidget {
  final List<Widget> children;
  final LegendGridSize? sizes;
  final int? crossAxisCount;
  final EdgeInsets? margin;
  final double? width;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsets? padding;

  LegendGrid({
    this.sizes,
    required this.children,
    this.crossAxisCount,
    this.margin,
    this.width,
    this.padding,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    ScreenSize ss = SizeProvider.of(context).screenSize;

    LegendGridSizeInfo? size = sizes?.getSizeForSize(ss);

    return LayoutBuilder(builder: (context, constraints) {
      int count = size?.count ?? crossAxisCount ?? 1;
      double singleChildWidth;

      double maxHeight = constraints.maxHeight;

      if (constraints.maxWidth == 0.0) {
        if (width != null)
          singleChildWidth = width! / count;
        else
          throw Error();
      } else
        singleChildWidth = constraints.maxWidth / count;

      int rows = (children.length / count).ceil();

      // Height
      double? height;
      double? aspectRatio;
      if (size != null) {
        height = size.height * rows +
            (rows - 1) * (mainAxisSpacing ?? 0) +
            (margin?.vertical ?? 0);
        aspectRatio = singleChildWidth /
            ((height - (rows - 1) * (mainAxisSpacing ?? 0)) / rows);
      } else {
        height = maxHeight -
            (rows - 1) * (mainAxisSpacing ?? 0) -
            (margin?.vertical ?? 0);
        aspectRatio = singleChildWidth /
            ((height - (rows - 1) * (mainAxisSpacing ?? 0)) / rows);
      }

      return Container(
        height: height,
        margin: margin,
        child: GridView.count(
          childAspectRatio: aspectRatio,
          crossAxisCount: count,
          children: children,
          shrinkWrap: true,
          crossAxisSpacing: crossAxisSpacing ?? 0.0,
          padding: padding,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: mainAxisSpacing ?? 0.0,
        ),
      );
    });
  }
}
