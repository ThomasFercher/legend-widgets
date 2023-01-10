import 'package:flutter/material.dart';

class LegendHeader extends StatelessWidget {
  final Widget child;
  final Widget header;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final EdgeInsetsGeometry? margin;
  final bool expand;

  const LegendHeader({
    Key? key,
    required this.child,
    required this.header,
    this.margin,
    this.expand = false,
    this.spacing = 4,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          header,
          SizedBox(
            height: spacing,
          ),
          if (expand)
            Expanded(
              child: child,
            )
          else
            child,
        ],
      ),
    );
  }
}
