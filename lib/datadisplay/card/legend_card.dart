import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_utils/legend_utils.dart';

class LegendCard extends StatelessWidget {
  const LegendCard({
    this.height,
    this.width,
    this.icon,
    this.subtitle,
    this.title,
    this.value,
    this.children,
    this.iconColor,
    this.image,
    this.backgroundColor,
    this.borderRadiusGeometry,
  });

  final double? height;
  final double? width;
  final String? title;
  final String? value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget>? children;
  final Widget? image;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadiusGeometry;

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);

    return Card(
      color: backgroundColor ?? theme.colors.background2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusGeometry ?? theme.sizing.radius1.asRadius(),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: getContent(height, width, context),
            ),
          );
        },
      ),
    );
  }

  List<Widget> getContent(height, width, context) {
    LegendTheme theme = LegendTheme.of(context);

    if (children != null) {
      return children!;
    } else
      return [
        Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LegendText(
                      title ?? "",
                      style: theme.typography.h3.copyWith(
                        color: theme.colors.foreground4,
                      ),
                    ),
                  ),
                  LegendText(
                    subtitle ?? "",
                    style: theme.typography.h3.copyWith(
                      color: Colors.greenAccent[400],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    icon,
                    size: 64,
                    color: iconColor ?? theme.colors.primary,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: LegendText(
                        value ?? "",
                        style: theme.typography.h3.copyWith(
                          color: theme.colors.foreground4,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ];
  }
}
