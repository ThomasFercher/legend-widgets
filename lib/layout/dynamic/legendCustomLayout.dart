import 'package:flutter/material.dart';

import 'items/legendLayoutItem.dart';
import 'legendCustomFlexDelegate.dart';

class LegendCustomLayout extends StatelessWidget {
  final LegendLayoutItem item;
  final List<Widget> children;
  late final List<LayoutId> layout;
  final double? height;

  LegendCustomLayout({
    required this.item,
    required this.children,
    this.height,
  }) {
    layout = getLayoutsList();
  }

  factory LegendCustomLayout.dyna({
    required List<Widget> children,
  }) {
    return LegendCustomLayout(
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
          delegate: LegendCustomFlexDelegate(item),
          children: layout,
        ),
      );
    });
  }
}
