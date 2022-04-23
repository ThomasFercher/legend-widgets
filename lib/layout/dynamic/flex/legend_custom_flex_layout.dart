import 'package:flutter/material.dart';

import 'custom_flex_delegate.dart';
import 'items/legendLayoutItem.dart';

export 'items/legendLayoutItem.dart';

class LegendCustomFlexLayout extends StatelessWidget {
  final LegendLayoutItem item;
  final List<Widget> children;
  late final List<LayoutId> layout;
  final double? height;
  final int? id;

  LegendCustomFlexLayout({
    required this.item,
    required this.children,
    this.height,
    this.id,
  }) {
    layout = getLayoutsList();
  }

  factory LegendCustomFlexLayout.dyna({
    required List<Widget> children,
  }) {
    return LegendCustomFlexLayout(
      item: LegendLayoutNone(),
      children: children,
    );
  }

  List<LayoutId> getLayoutsList() {
    List<LayoutId> layout = [];

    for (int i = 0; i < children.length; i++) {
      layout.add(
        LayoutId(
          id: i,
          child: children[i],
        ),
      );
    }
    return layout;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double mHeight = constraints.maxHeight;
      if (mHeight == double.infinity && height == null) {
        mHeight = 400;
      } else {
        mHeight = height ?? mHeight;
      }

      return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: mHeight,
        ),
        child: CustomMultiChildLayout(
          delegate: CustomFlexDelegate(item, id),
          children: layout,
        ),
      );
    });
  }
}
