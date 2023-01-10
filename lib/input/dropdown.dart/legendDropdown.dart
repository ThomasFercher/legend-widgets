import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_utils/legend_utils.dart';

import 'legendDropdownOption.dart';

class LegendDropdown extends StatelessWidget {
  final List<PopupRouteDisplay> options;
  final Function(PopupRouteDisplay selected) onSelected;
  final Color? color;
  final double? itemHeight;
  final IconData icon;
  final double? popupWidth;
  final Offset? offset;

  LegendDropdown({
    required this.options,
    required this.onSelected,
    this.color,
    this.itemHeight,
    this.popupWidth,
    required this.icon,
    this.offset,
  });

  PopupMenuItem<String> getDropDownMenuItem(String option, IconData? icon,
      context, LegendPalette colors, LegendTheme theme) {
    return PopupMenuItem<String>(
      height: itemHeight ?? 36,
      value: option,
      child: Container(
        width: popupWidth,
        child: Row(
          children: [
            Container(
              child: icon != null
                  ? Padding(
                      child: Icon(
                        icon,
                        color: colors.primary,
                        size: 24,
                      ),
                      padding: EdgeInsets.only(right: 16),
                    )
                  : null,
            ),
            Expanded(
              child: LegendText(
                option,
                style: theme.typography.h1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);

    return Container(
      height: 40,
      child: PopupMenuButton(
        child: Icon(icon),
        shape: RoundedRectangleBorder(
          borderRadius: theme.sizing.radius1.asRadius(),
        ),
        onSelected: (value) {
          onSelected(
            options.singleWhere((e) => e.value == value),
          );
        },
        tooltip: "",
        enableFeedback: true,
        offset: offset ?? Offset(0, 0),
        color: theme.colors.foreground2,
        itemBuilder: (BuildContext context) {
          return options
              .map(
                (opt) => getDropDownMenuItem(
                  opt.value,
                  opt.icon,
                  context,
                  theme.colors,
                  theme,
                ),
              )
              .toList();
        },
      ),
    );
  }
}
