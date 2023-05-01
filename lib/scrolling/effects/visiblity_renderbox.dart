import 'package:flutter/rendering.dart';
import 'dart:math' as math;

typedef VisibilityCallback = void Function(double visiblePercentage);

class VisibilityPercentageRenderSliver extends RenderSliverSingleBoxAdapter {
  VisibilityCallback onVisibilityChanged;

  VisibilityPercentageRenderSliver({
    required this.onVisibilityChanged,
  }) : super(child: RenderErrorBox());

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );

    final paintRatio = paintedChildSize / childExtent;

    final scollRatio = math.max(
      0.0,
      1 - (constraints.scrollOffset / childExtent),
    );

    final inverted = constraints.scrollOffset > 0.0;

    final _ratio = inverted ? scollRatio : paintRatio;
    onVisibilityChanged(_ratio);

    setChildParentData(child!, constraints, geometry!);
  }
}
