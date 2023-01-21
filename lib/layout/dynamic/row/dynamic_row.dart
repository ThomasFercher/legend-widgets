import 'package:flutter/widgets.dart';
import 'package:legend_design_widgets/layout/dynamic/row/custom_row_renderbox.dart';

class DynamicRow extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<int> {
  final List<Widget> children;
  final double? spacing;
  final double? verticalSpacing;
  final MainAxisSize mainAxisSize;
  const DynamicRow({
    Key? key,
    required this.children,
    this.spacing,
    this.verticalSpacing,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Iterable<int> get slots =>
      children.map((Widget child) => children.indexOf(child));

  @override
  Widget? childForSlot(int i) {
    return children[i];
  }

  @override
  SlottedContainerRenderObjectMixin<int> createRenderObject(
    BuildContext context,
  ) {
    return CustomRowRenderBox(
      indexes: slots.toList(),
      spacing: spacing,
      verticalSpacing: verticalSpacing,
      mainAxisSize: mainAxisSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    SlottedContainerRenderObjectMixin<int> renderObject,
  ) {
    (renderObject as CustomRowRenderBox);
  }
}
