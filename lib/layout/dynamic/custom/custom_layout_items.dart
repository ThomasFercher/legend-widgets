import 'package:flutter/rendering.dart';

abstract class LegendCustomLayout {
  final List<LegendCustomLayout>? children;
  final int? flex;

  const LegendCustomLayout({
    this.children,
    this.flex,
  });
}

class LegendCustomColumn extends LegendCustomLayout {
  final List<LegendCustomLayout> children;
  final double? spacing;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final bool? expandCrossAxis;

  LegendCustomColumn({
    required this.children,
    this.spacing,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.expandCrossAxis,
    int? flex,
  }) : super(children: children, flex: flex);
}

class LegendCustomRow extends LegendCustomLayout {
  final List<LegendCustomLayout> children;
  final double? spacing;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final bool? expandCrossAxis;

  LegendCustomRow({
    required this.children,
    this.spacing,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.expandCrossAxis,
    int? flex,
  }) : super(children: children, flex: flex);
}

class LegendCustomWidget extends LegendCustomLayout {
  final int id;
  final int? flex;

  LegendCustomWidget(this.id, {this.flex}) : super(flex: flex);
}
