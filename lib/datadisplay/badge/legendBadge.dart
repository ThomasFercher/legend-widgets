import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/typography/typography.dart';

import 'package:legend_design_widgets/datadisplay/badge/badgeContainer.dart';

enum LegendBadgeValues { Text, Count, Dot }

class LegendBadge extends StatelessWidget {
  late final LegendBadgeValues value;
  LegendTextStyle? typography;
  String? text;
  int? count;
  final Widget badgeWidget;
  double? height;
  Color badgeColor;

  LegendBadge.text({
    required this.text,
    required this.typography,
    required this.badgeWidget,
    this.height,
    required this.badgeColor,
  }) {
    value = LegendBadgeValues.Text;
  }

  LegendBadge.count({
    required this.count,
    required this.badgeWidget,
    this.height,
    required this.badgeColor,
  }) {
    value = LegendBadgeValues.Count;
  }
  LegendBadge.dot({
    required this.badgeColor,
    required this.badgeWidget,
  }) {
    value = LegendBadgeValues.Dot;
  }

  Widget getBadge() {
    switch (value) {
      case LegendBadgeValues.Text:
        return BadgeContainer(
          text: text,
          height: height,
          badgeColor: badgeColor,
        );
      case LegendBadgeValues.Count:
        return BadgeContainer(
          height: height,
          count: count,
          badgeColor: badgeColor,
        );
      case LegendBadgeValues.Dot:
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double inset = 6;

    if (height != null) {
      inset = height! / 2;
    }
    return Container(
      padding: EdgeInsets.only(top: inset, right: inset),
      child: Stack(
        children: [
          badgeWidget,
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              transform: Matrix4.translationValues(inset, -inset, 0),
              child: getBadge(),
            ),
          ),
        ],
      ),
    );
  }
}
