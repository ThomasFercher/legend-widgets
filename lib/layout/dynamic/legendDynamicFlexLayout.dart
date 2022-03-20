import 'package:flutter/cupertino.dart';

import 'dynamicLayout.dart';
import 'items/legendLayoutItem.dart';
import 'legendCustomLayout.dart';

class LegendDynamicFlexLayout extends StatelessWidget {
  final LegendCustomLayout layout;
  final DynamicLayout dynamicLayout;
  final List<double> heights;
  final bool animated;

  LegendDynamicFlexLayout({
    required this.layout,
    required this.dynamicLayout,
    required this.heights,
    this.animated = false,
  });

  double getHeight(int itemIndex) {
    if (itemIndex < heights.length)
      return heights[itemIndex];
    else
      return heights[heights.length - 1];
  }

  @override
  Widget build(BuildContext context) {
    LegendLayoutItem item =
        dynamicLayout.getItem(MediaQuery.of(context).size.width);

    return animated
        ? AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: heights[dynamicLayout.lastIndex],
            child: LegendCustomLayout(
              item: item,
              children: layout.children,
            ),
          )
        : LegendCustomLayout(
            item: item,
            height: getHeight(dynamicLayout.lastIndex),
            children: layout.children,
          );
  }
}
