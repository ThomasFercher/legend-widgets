import 'package:flutter/material.dart';
import 'package:legend_design_core/icons/legend_animated_icon.dart';
import 'package:legend_design_core/styles/theming/colors/legend_color_theme.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';
import 'package:legend_design_core/typography/legend_text.dart';

import 'package:legend_design_widgets/input/dropdown.dart/legendDropdownOption.dart';
import 'package:provider/provider.dart';

class LegendDropdown extends StatelessWidget {
  final List<PopupMenuOption> options;
  final Function(PopupMenuOption selected) onSelected;
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
      context, LegendColorTheme colors, ThemeProvider theme) {
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
                        color: colors.primaryColor,
                        size: 24,
                      ),
                      padding: EdgeInsets.only(right: 16),
                    )
                  : null,
            ),
            Expanded(
              child: LegendText(
                text: option,
                textStyle: theme.typography.h1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);

    return Container(
      height: 40,
      child: PopupMenuButton(
        child: Icon(icon),
        shape: RoundedRectangleBorder(
          borderRadius: theme.sizing.borderRadius[0],
        ),
        onSelected: (value) {
          onSelected(
            options.singleWhere((e) => e.value == value),
          );
        },
        tooltip: "",
        enableFeedback: true,
        offset: offset ?? Offset(0, 0),
        color: theme.colors.foreground[1],
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
