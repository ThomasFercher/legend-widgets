import 'package:flutter/material.dart';
import 'package:legend_design_widgets/layout/dynamic/custom/custom_layout_items.dart';
import 'package:legend_design_widgets/layout/dynamic/custom/custom_layout_renderbox.dart';

export 'package:legend_design_widgets/layout/dynamic/custom/custom_layout_items.dart';

typedef LayoutEntry = MapEntry<double, LegendCustomLayout>;

class LegendWidgetLayout extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<int> {
  final List<Widget> children;
  final LegendCustomLayout layout;
  final Color? background;

  /// Custom Multi Child Layout Widget
  /// The [children] represent the [List<Widgets>] which will be layouted.
  /// The [LegendCustomLayout] layout defines the layout of the children.
  /// The Layout can either be [LegendCustomColumn], [LegendCustomRow] or [LegendCustomWidget].
  ///
  /// [LegendCustomColumn] and [LegendCustomRow] each have a List of [LegendCustomLayout]
  /// as children. This way you can define complex layouts in one object,
  ///
  /// [LegendCustomWidget] is used to define which widget from the [children] will
  /// used in the corresponding slot/ position.
  /// [LegendCustomWidget] requires an [id] which is the index of the Widget in the [children] List.
  ///
  LegendWidgetLayout({
    Key? key,
    required this.children,
    required this.layout,
    this.background,
  }) : super(key: ValueKey(layout.hashCode + children.hashCode));

  /// Instead of one fixed [LegendCustomLayout], we can have different
  /// [LegendCustomLayout] for different screen Sizes. Each Map Entry has a [width], which is
  /// the [Key] and the corresponding [LegendCustomLayout] as the [Value].
  /// The first [Key] which is bigger than the [width] will be selected.
  /// The Map Entries are iterated from front to back.
  /// If no [Key] is bigger than the [width] the last Map Entry will be selected.,
  /// The selected layout is determined by the speficied [width].
  ///
  /// The Layout works the same way as the [LegendWidgetLayout]
  factory LegendWidgetLayout.dyn({
    required List<Widget> children,
    required Map<double, LegendCustomLayout> layouts,
    required double width,
    Color? background,
  }) {
    LegendCustomLayout? selected_layout;
    LayoutEntry layout;

    for (int i = 0; i < layouts.length; i++) {
      layout = layouts.entries.elementAt(i);
      if ((layout.key >= width) || i == layouts.length - 1) {
        selected_layout = layout.value;
        break;
      }
    }

    selected_layout ??= layouts.values.last;

    return LegendWidgetLayout(
        children: children, layout: selected_layout, background: background);
  }

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
    return CustomLayoutRenderBox(
        customLayout: layout, indexes: slots.toList(), background: background);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    SlottedContainerRenderObjectMixin<int> renderObject,
  ) {
    (renderObject as CustomLayoutRenderBox);
  }
}
