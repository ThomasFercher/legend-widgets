import 'package:flutter/material.dart';

class LegendHeader extends StatelessWidget {
  final Widget child;
  final Widget header;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const LegendHeader({
    Key? key,
    required this.child,
    required this.header,
    this.spacing = 4,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        header,
        SizedBox(
          height: spacing,
        ),
        child,
      ],
    );
  }
}
