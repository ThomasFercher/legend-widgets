import 'package:flutter/material.dart';
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

    // final paintExtent = math.min(extent, constraints.remainingPaintExtent);
    // final cacheExtent = math.min(extent, constraints.remainingCacheExtent);

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );

    final displayRatio = constraints.remainingPaintExtent / childExtent;
    final _ratio = displayRatio > 1 ? 1.0 : displayRatio;

    onVisibilityChanged(_ratio);

    setChildParentData(child!, constraints, geometry!);
  }
}
