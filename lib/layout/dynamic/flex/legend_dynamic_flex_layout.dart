import 'package:flutter/cupertino.dart';

import 'dynamic_flex_layout.dart';
import 'legend_custom_flex_layout.dart';

export 'dynamic_flex_layout.dart';
export 'legend_custom_flex_layout.dart';

class LegendDynamicFlexLayout extends StatelessWidget {
  final LegendCustomFlexLayout layout;
  final DynamicFlexLayout dynamicLayout;
  final List<double> heights;

  LegendDynamicFlexLayout({
    required this.layout,
    required this.dynamicLayout,
    required this.heights,
  });

  double getHeight(int itemIndex) {
    if (itemIndex < heights.length)
      return heights[itemIndex];
    else
      return heights[heights.length - 1];
  }

  @override
  Widget build(BuildContext context) {
    LegendLayoutItem item = dynamicLayout.item;
    double height = getHeight(dynamicLayout.index);

    print(dynamicLayout.index);

    return LegendCustomFlexLayout(
      item: item,
      height: height,
      children: layout.children,
      id: dynamicLayout.index,
    );
  }
}
