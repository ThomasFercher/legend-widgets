import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomRowRenderBox extends RenderBox
    with SlottedContainerRenderObjectMixin<int>, DebugOverflowIndicatorMixin {
  final List<int> indexes;
  final Color? background;
  final double? spacing;
  final double? verticalSpacing;

  CustomRowRenderBox({
    required this.indexes,
    this.background,
    this.spacing,
    this.verticalSpacing,
  });

  List<RenderBox>? _children;

  @override
  Iterable<RenderBox> get children {
    List<RenderBox> boxes = [];

    for (var i = 0; i < indexes.length; i++) {
      RenderBox? r = childForSlot(i);
      if (r != null) boxes.add(r);
    }
    return boxes;
  }

  Size getSizeOfChild(int i) {
    RenderBox? child = childForSlot(i);
    if (child != null) {
      child.layout(BoxConstraints(), parentUsesSize: true);
      BoxParentData childParentData = child.parentData as BoxParentData;

      childParentData.offset = Offset.zero;

      return child.size;
    }

    return Size.zero;
  }

  Size layoutRow() {
    final bool hasHeight = constraints.maxHeight != double.infinity;
    final double? height = hasHeight ? constraints.maxHeight : null;

    BoxConstraints childConstraints;
    Offset offset = Offset.zero;
    Size childSize = Size.zero;
    double rem_width = constraints.maxWidth;
    double max_height = 0;
    double height_sum = 0;
    double width = 0;
    bool oneLine = true;
    bool lineBreak = false;
    for (var i = 0; i < indexes.length; i++) {
      int index = indexes[i];

      final RenderBox? child = childForSlot(index);
      if (child != null) {
        if (rem_width - getSizeOfChild(index).width < 0) {
          width = constraints.maxWidth - rem_width;
          rem_width = constraints.maxWidth;
          offset = Offset(0, offset.dy + max_height + (verticalSpacing ?? 0));
          height_sum = offset.dy;
          oneLine = false;
          lineBreak = true;
        }

        childConstraints = BoxConstraints(
          maxWidth: rem_width,
        );

        child.layout(childConstraints, parentUsesSize: true);
        BoxParentData childParentData = child.parentData as BoxParentData;

        childParentData.offset = offset;

        childSize = child.size;

        double dx = childSize.width;

        if (spacing != null && i != indexes.length - 1) {
          dx += spacing!;
        }

        offset = offset.translate(dx, 0);

        if (childSize.height > max_height) max_height = childSize.height;

        rem_width -= dx;

        if (lineBreak) {
          height_sum += childSize.height;
          lineBreak = false;
        }
      }
    }

    if (oneLine) {
      height_sum = max_height;
      width = constraints.maxWidth - rem_width;
    }

    return Size(width, height_sum);
  }

  bool isNotInfinite(final double maxWidth) {
    return maxWidth != double.infinity;
  }

  late Size contentSize;

  @override
  void performLayout() {
    Size contentSize = layoutRow();
    /*
    for (RenderBox box in children) {
      box.layout(constraints, parentUsesSize: true);
      _positionChild(box, offset);

      s = box.size;
      offset = Offset(offset.dx + s.width, offset.dy + s.height);

      _childrenSize =
          Size(_childrenSize.width + s.width, _childrenSize.height + s.height);
    }*/

    // Calculate the overall size and constrain it to the given constraints.
    // Any overflow is marked (in debug mode) during paint.

    size = constraints.constrain(contentSize);
  }

  void _positionChild(RenderBox child, Offset offset) {
    (child.parentData! as BoxParentData).offset = offset;
  }

  // PAINT

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint the background.

    context.canvas.drawRect(
      offset & size,
      Paint()..color = background ?? Colors.transparent,
    );

    void paintChild(RenderBox child, PaintingContext context, Offset offset) {
      final BoxParentData childParentData = child.parentData! as BoxParentData;
      context.paintChild(child, childParentData.offset + offset);
    }

    for (RenderBox box in children) {
      paintChild(box, context, offset);
    }

    // Paint an overflow indicator in debug mode if the children want to be
    // larger than the incoming constraints allow.
    assert(() {
      paintOverflowIndicator(
        context,
        offset,
        Offset.zero & size,
        Offset.zero & contentSize,
      );
      return true;
    }());
  }

  // HIT TEST

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }

  // INTRINSICS

  // Incoming height/width are ignored as children are always laid out unconstrained.

  @override
  double computeMinIntrinsicWidth(double height) {
    double width = 0;
    for (RenderBox box in children) {
      width += box.getMinIntrinsicWidth(double.infinity);
    }

    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0;
    for (RenderBox box in children) {
      width += box.getMaxIntrinsicWidth(double.infinity);
    }

    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    double height = 0;
    for (RenderBox box in children) {
      height += box.getMinIntrinsicHeight(double.infinity);
    }

    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    double height = 0;
    for (RenderBox box in children) {
      height += box.getMaxIntrinsicHeight(double.infinity);
    }

    return height;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    const BoxConstraints childConstraints = BoxConstraints();
    Size s = Size.zero;
    for (RenderBox box in children) {
      Size boxSize = box.computeDryLayout(childConstraints);
      s = Size(s.width + boxSize.width, s.height + boxSize.height);
    }

    return constraints.constrain(s);
  }
}
