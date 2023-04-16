import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/typography/typography.dart';

import 'package:legend_design_widgets/datadisplay/badge/badgeContainer.dart';

class LegendBadge extends StatelessWidget {
  final Widget content;
  final double? height;
  final Color badgeColor;
  final Widget badge;

  LegendBadge({
    required this.content,
    this.height,
    this.badgeColor = Colors.red,
    this.badge = const _DotBadge(),
  });

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
          content,
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              transform: Matrix4.translationValues(inset, -inset, 0),
              child: badge,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotBadge extends StatelessWidget {
  const _DotBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
