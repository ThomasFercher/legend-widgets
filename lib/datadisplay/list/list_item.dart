import 'package:flutter/material.dart';

import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';

class LegendListItem extends StatelessWidget {
  final Icon icon;
  final LegendText text;

  const LegendListItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            Icons.circle_outlined,
            color: theme.colors.foreground3,
            size: 8,
          ),
          const SizedBox(
            width: 16,
          ),
          icon,
          const SizedBox(
            width: 8,
          ),
          Expanded(child: text)
        ],
      ),
    );
  }
}
