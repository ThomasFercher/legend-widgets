import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:legend_design_widgets/layout/dynamic/custom/custom_layout_items.dart';

class CustomLayoutRenderBox extends RenderBox
    with SlottedContainerRenderObjectMixin<int>, DebugOverflowIndicatorMixin {
  final LegendCustomLayout customLayout;
  final List<int> indexes;
  final Color? background;

  CustomLayoutRenderBox({
    required this.customLayout,
    required this.indexes,
    this.background,
  });

  List<RenderBox>? _children;

  late Size contentSize;

  @override
  Iterable<RenderBox> get children {
    List<RenderBox> boxes = [];

    for (var i = 0; i < indexes.length; i++) {
      RenderBox? r = childForSlot(i);
      if (r != null) boxes.add(r);
    }
    return boxes;
  }

  ///
  /// Returns the Size of every child in the items List.
  ///
  List<Size> getIterableSizesRow(
    List<LegendCustomLayout> items,
    BoxConstraints constraints,
  ) {
    List<Size> sizes = [];
    BoxConstraints childConstraints = constraints;

    Map<int, RenderBox> noWidthSpecified = {};

    for (int i = 0; i < items.length; i++) {
      LegendCustomLayout layout = items[i];
      switch (layout.runtimeType) {
        case LegendCustomWidget:
          LegendCustomWidget widget = layout as LegendCustomWidget;

          final RenderBox? child = childForSlot(widget.id);
          if (child != null) {
            double m_width = child.getMinIntrinsicWidth(0);
            if (m_width == 0) {
              noWidthSpecified[i] = child;
              continue;
            }

            child.layout(childConstraints, parentUsesSize: true);
            sizes.add(child.size);
            childConstraints = childConstraints.copyWith(
              maxWidth: childConstraints.maxWidth - child.size.width,
            );
          }
          break;
        case LegendCustomRow:
          LegendCustomRow row = layout as LegendCustomRow;
          List<Size> rowSizes =
              getIterableSizesRow(row.children, childConstraints);
          Size maxSize = Size.zero;
          double w = 0;
          for (Size s in rowSizes) {
            if (s.height > maxSize.height) {
              maxSize = s;
            }

            w += s.width;
          }
          sizes.add(Size(w, maxSize.height));
          break;

        case LegendCustomColumn:
          LegendCustomColumn col = layout as LegendCustomColumn;

          List<Size> columnSizes =
              getIterableSizesRow(col.children, childConstraints);
          print(columnSizes);
          Size maxSize = Size.zero;
          double h = 0;
          for (Size s in columnSizes) {
            if (s.width > maxSize.width) {
              maxSize = s;
            }

            h += s.height;
          }
          sizes.add(Size(maxSize.width, h));
          break;
      }
    }

    noWidthSpecified.forEach((index, box) {
      box.layout(childConstraints, parentUsesSize: true);
      childConstraints = childConstraints.copyWith(
          maxWidth: childConstraints.maxWidth - box.size.width);

      sizes.insert(index, box.size);
    });

    return sizes;
  }

  ///
  /// Returns the Size of every child in the items List.
  ///
  List<Size> getIterableSizesColumn(
    List<LegendCustomLayout> items,
    BoxConstraints constraints,
  ) {
    List<Size> sizes = [];
    BoxConstraints childConstraints = constraints;
    for (int i = 0; i < items.length; i++) {
      LegendCustomLayout layout = items[i];

      switch (layout.runtimeType) {
        case LegendCustomWidget:
          LegendCustomWidget widget = layout as LegendCustomWidget;

          final RenderBox? child = childForSlot(widget.id);
          if (child != null) {
            child.layout(childConstraints, parentUsesSize: true);
            sizes.add(child.size);
            childConstraints = childConstraints.copyWith(
                maxHeight: childConstraints.maxHeight - child.size.height);
          }
          break;
        case LegendCustomRow:
          LegendCustomRow row = layout as LegendCustomRow;
          List<Size> rowSizes =
              getIterableSizesColumn(row.children, childConstraints);
          break;

        case LegendCustomColumn:
          LegendCustomColumn column = layout as LegendCustomColumn;
          List<Size> columnSizes =
              getIterableSizesColumn(column.children, childConstraints);

          Size maxSize = Size.zero;
          for (Size s in columnSizes) {
            if (s.width > maxSize.width) {
              maxSize = s;
            }
          }
          sizes.add(maxSize);
          break;
      }
    }

    return sizes;
  }

  Size layoutColumn(LegendCustomColumn column, Offset offset,
      BoxConstraints childConstraints) {
    // Spacing
    double? spacing = column.spacing;

    // Constraints
    BoxConstraints constraints = childConstraints.copyWith(minWidth: 0);

    double height = 0;

    double width =
        isNotInfinite(constraints.maxWidth) ? constraints.maxWidth : 0;
    double mWidth = constraints.maxWidth;
    double mHeight = constraints.maxHeight;

    //
    List<Size> childSizes =
        getIterableSizesColumn(column.children, constraints);

    // CrossAxisAligment
    CrossAxisAlignment? crossAxisAligment = column.crossAxisAlignment;

    List<double> crossAxisSpacing = [];
    if (crossAxisAligment != null) {
      childSizes.forEach((size) {
        switch (crossAxisAligment) {
          case CrossAxisAlignment.center:
            double indent = 0;
            if (size.width < mWidth) {
              indent = (mWidth - size.width) / 2;
            }
            crossAxisSpacing.add(indent);
            break;
          case CrossAxisAlignment.end:
            double indent = 0;
            if (size.width < mWidth) {
              indent = (mWidth - size.width);
            }
            crossAxisSpacing.add(indent);
            break;
          case CrossAxisAlignment.start:
            crossAxisSpacing.add(0);
            break;

          default:
        }
      });
    }

    // Main Axis Aligment
    MainAxisAlignment? mainAxisAligment = column.mainAxisAlignment;
    List<double> mainAxisSpacing = [];
    if (mainAxisAligment != null) {
      double filledSpace = 0;

      childSizes.forEach((s) {
        filledSpace += s.height;
      });

      switch (mainAxisAligment) {
        case MainAxisAlignment.center:
          double indent = (mHeight - filledSpace) / 2;

          for (var i = 0; i < childSizes.length; i++) {
            if (i == 0) {
              mainAxisSpacing.add(indent);
            } else {
              mainAxisSpacing.add(0);
            }
          }
          break;
        case MainAxisAlignment.end:
          double indent = mHeight - filledSpace;

          for (var i = 0; i < childSizes.length; i++) {
            if (i == 0) {
              mainAxisSpacing.add(indent);
            } else {
              mainAxisSpacing.add(0);
            }
          }
          break;
        case MainAxisAlignment.spaceBetween:
          double indent = (mHeight - filledSpace) / (childSizes.length - 1);

          for (var i = 0; i < childSizes.length; i++) {
            if (i != 0) {
              mainAxisSpacing.add(indent);
            } else {
              mainAxisSpacing.add(0);
            }
          }
          break;
        case MainAxisAlignment.spaceEvenly:
          double indent = (mHeight - filledSpace) / (childSizes.length + 1);
          for (var i = 0; i < childSizes.length; i++) {
            mainAxisSpacing.add(indent);
          }
          break;
        case MainAxisAlignment.start:
          for (var i = 0; i < childSizes.length; i++) {
            mainAxisSpacing.add(0);
          }
          break;

        default:
      }
    }

    // Max Vertical Extent
    double mColWidth = 0;

    Offset columnOffset = offset;
    for (var i = 0; i < column.children.length; i++) {
      // Update Constraints

      // Cross Axis Aligment
      double crossAxisSpace = 0;
      if (crossAxisAligment != null) {
        crossAxisSpace = crossAxisSpacing[i];
      }

      double mainAxisSpace = 0;
      if (mainAxisAligment != null) {
        mainAxisSpace = mainAxisSpacing[i];
        columnOffset = Offset(columnOffset.dx, columnOffset.dy + mainAxisSpace);
      }

      Size childSize = layoutItem(
        column.children[i],
        Offset(columnOffset.dx + crossAxisSpace, columnOffset.dy),
        constraints,
      );

      // Add to rowWidth
      height += childSize.height + mainAxisSpace;

      // Max
      if (childSize.height > mColWidth) mColWidth = childSize.height;

      // Add Spacing
      if (i != column.children.length - 1 && spacing != null) {
        height += spacing;
      }

      // Update Offset
      columnOffset = Offset(columnOffset.dx, height);
    }

    return Size(width, height);
  }

  Size layoutRow(
    LegendCustomRow row,
    Offset offset,
    BoxConstraints childConstraints,
  ) {
    // Width of the Row
    double width = 0;

    // Max Width of the Row
    double mWidth = childConstraints.maxWidth;

    // Constraints
    BoxConstraints constraints = childConstraints.copyWith(minWidth: 0);

    double height =
        isNotInfinite(constraints.maxHeight) ? constraints.maxHeight : 0;

    Offset rowOffset = offset;

    // Spacing
    double? spacing = row.spacing;
    List<Size> childSizes = getIterableSizesRow(row.children, constraints);

    // CrossAxisAligment
    CrossAxisAlignment? crossAxisAligment = row.crossAxisAlignment;

    // Max Vertical Extent
    double mRowHeight = 0;
    for (Size s in childSizes) {
      if (s.height > mRowHeight) {
        mRowHeight = s.height;
      }
    }

    List<double> crossAxisSpacing = [];
    if (crossAxisAligment != null) {
      childSizes.forEach((size) {
        switch (crossAxisAligment) {
          case CrossAxisAlignment.center:
            double indent = 0;
            if (size.height < mRowHeight) {
              indent = (mRowHeight - size.height) / 2;
            }
            crossAxisSpacing.add(indent);
            break;
          case CrossAxisAlignment.end:
            double indent = 0;
            if (size.height < mRowHeight) {
              indent = (mRowHeight - size.height);
            }
            crossAxisSpacing.add(indent);
            break;
          case CrossAxisAlignment.start:
            crossAxisSpacing.add(0);
            break;

          default:
        }
      });
    }

    // MainAxis Spacing Calculations
    MainAxisAlignment? mainAxisAlignment = row.mainAxisAlignment;
    List<double> spaceEvenly = [];
    List<double> spaceBetween = [];
    double centerHorizontalOffset = -1;
    double endHorizontalOffset = -1;

    // Flex
    bool childHasFlex = row.children.any((element) => element.flex != null);

    // Get Sizes
    List<Size> itemsSizes = getIterableSizesRow(row.children, constraints);
    if (childHasFlex) {
      List<LegendCustomLayout> flexItems = [];

      List<Size> noFlexItemsSizes = [];

      for (var i = 0; i < row.children.length; i++) {
        LegendCustomLayout item = row.children[i];
        if (item.flex != null) {
          flexItems.add(item);
        } else {
          noFlexItemsSizes.add(itemsSizes[i]);
        }
      }

      double filledSpace = 0;
      for (Size size in noFlexItemsSizes) {
        filledSpace += size.width;
      }
      if (spacing != null) filledSpace += spacing * (row.children.length - 1);

      // Get FlexSum
      int flexSum = 0;
      flexItems.forEach((element) {
        if (element.flex != null) flexSum += element.flex!;
      });

      double remainingWidth = mWidth - filledSpace;

      double flexUnit = remainingWidth / flexSum;

      childSizes = [];
      for (var i = 0; i < row.children.length; i++) {
        LegendCustomLayout item = row.children[i];

        if (item.flex != null) {
          int flex = item.flex!;
          double height = itemsSizes[i].height;
          double width = flex * flexUnit;

          childSizes.add(Size(width, height));
        } else {
          childSizes.add(itemsSizes[i]);
        }
      }
      print(childSizes);
    } else if (mainAxisAlignment != null) {
      // Set Spacing null as we don't need it
      spacing = null;

      switch (mainAxisAlignment) {
        case MainAxisAlignment.spaceEvenly:
          double filledSpace = 0;
          for (Size s in childSizes) {
            filledSpace += s.width;
          }

          double rem = mWidth - filledSpace;

          double space = rem / (childSizes.length + 1);

          for (var i = 0; i < childSizes.length + 1; i++) {
            spaceEvenly.add(space);
          }
          break;
        case MainAxisAlignment.spaceBetween:
          double filledSpace = 0;
          for (Size s in childSizes) {
            filledSpace += s.width;
          }

          double rem = mWidth - filledSpace;

          double space = rem / (childSizes.length - 1);

          for (var i = 0; i < childSizes.length - 1; i++) {
            spaceBetween.add(space);
          }
          break;

        case MainAxisAlignment.center:
          spacing = row.spacing;
          double filledSpace = 0;
          for (Size s in childSizes) {
            filledSpace += s.width;
          }
          if (spacing != null) filledSpace += spacing * (childSizes.length - 1);

          double rem = mWidth - filledSpace;

          double space = rem / 2;

          centerHorizontalOffset = space;
          break;
        case MainAxisAlignment.end:
          spacing = row.spacing;
          double filledSpace = 0;
          for (Size s in childSizes) {
            filledSpace += s.width;
          }
          if (spacing != null) filledSpace += spacing * (childSizes.length - 1);

          double rem = mWidth - filledSpace;

          endHorizontalOffset = rem;
          break;
        default:
      }
    }

    bool s_evenly = spaceEvenly.isNotEmpty;
    bool s_between = spaceBetween.isNotEmpty;
    bool s_center = centerHorizontalOffset != -1;
    bool s_end = endHorizontalOffset != -1;

    if (!childHasFlex) {
      if (s_evenly) {
        rowOffset = Offset(offset.dx + spaceEvenly[0], offset.dy);
      }

      if (s_center) {
        rowOffset = Offset(offset.dx + centerHorizontalOffset, offset.dy);
      }

      if (s_end) {
        rowOffset = Offset(offset.dx + endHorizontalOffset, offset.dy);
      }
    }

    // Layout
    double c_width = 0;
    mRowHeight = 0;
    itemsSizes.forEach((element) {
      if (element.height > mRowHeight) mRowHeight = element.height;
    });

    for (var i = 0; i < row.children.length; i++) {
      // Update Constraints
      constraints = constraints.copyWith(
        //  minHeight: height,
        maxHeight: mRowHeight,
        maxWidth: constraints.maxWidth - c_width, // - rowOffset.dx,
      );

      if (childHasFlex) {
        double flexWidth = childSizes[i].width;
        constraints = constraints.copyWith(
          minWidth: flexWidth,
          maxWidth: flexWidth,
        );
      } else {
        constraints = constraints.copyWith(
          minWidth: childSizes[i].width,
          maxWidth: childSizes[i].width,
        );
      }

      double crossAxisSpace = 0;
      if (crossAxisAligment != null) {
        crossAxisSpace = crossAxisSpacing[i];
      }

      Size childSize = layoutItem(row.children[i],
          Offset(rowOffset.dx, rowOffset.dy + crossAxisSpace), constraints);

      // Add to rowWidth
      c_width = childSize.width;

      // Add Spacing
      if (i != row.children.length - 1 && spacing != null) {
        c_width += spacing;
      }

      // MainAxisSpacing Between
      if (s_between) {
        if (i != row.children.length - 1) {
          c_width += spaceBetween[i];
        }
      }

      // MainAxisSpacing Between
      if (s_evenly) {
        c_width += spaceEvenly[i + 1];
      }

      // Update Offset
      rowOffset = Offset(rowOffset.dx + c_width, rowOffset.dy);
    }

    return Size(mWidth, mRowHeight);
  }

  Size layoutItem(
    LegendCustomLayout layout,
    Offset offset,
    BoxConstraints childConstraints,
  ) {
    switch (layout.runtimeType) {
      case LegendCustomWidget:
        LegendCustomWidget widget = layout as LegendCustomWidget;
        final RenderBox? child = childForSlot(widget.id);

        if (child == null) return Size.zero;

        child.layout(childConstraints, parentUsesSize: true);
        BoxParentData childParentData = child.parentData as BoxParentData;

        childParentData.offset = offset;
        return child.size;

      case LegendCustomColumn:
        LegendCustomColumn column = layout as LegendCustomColumn;
        return layoutColumn(column, offset, childConstraints);

      case LegendCustomRow:
        LegendCustomRow row = layout as LegendCustomRow;
        return layoutRow(row, offset, childConstraints);

      default:
        return Size.zero;
    }
  }

  bool isNotInfinite(final double maxWidth) {
    return maxWidth != double.infinity;
  }

  @override
  void performLayout() {
    // Children are allowed to be as big as they want (= unconstrained).
    BoxConstraints constraints = this.constraints;
    contentSize = layoutItem(customLayout, Offset.zero, constraints);
    size = constraints.constrain(contentSize);
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
