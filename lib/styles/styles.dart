library legend_design.styles;

import 'dart:ui';

class LegendTheme {
  final double? borderRadius;
  final double? elevation;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? textSize;
  final double? iconSize;

  LegendTheme({
    this.iconSize,
    this.textSize,
    this.elevation,
    this.borderRadius,
    this.iconColor,
    this.backgroundColor,
  });
}

class LayoutInfo {
  final bool? expandHorizontally;
  final bool? expandVertically;

  LayoutInfo({
    this.expandHorizontally,
    this.expandVertically,
  });
}
