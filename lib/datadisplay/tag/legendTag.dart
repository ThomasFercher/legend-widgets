import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_utils/extensions/extensions.dart';
import 'package:legend_utils/functions/functions.dart';
import 'package:provider/src/provider.dart';

class LegendTag extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle? textStyle;
  final bool? dissmissable;

  const LegendTag({
    required this.color,
    required this.text,
    this.textStyle,
    this.dissmissable,
  });

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: color.lighten(0.2),
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: LegendText(
        text,
        textStyle: textStyle ??
            theme.typography.h1.copyWith(
              color: color.darken(0.05),
              fontSize: 16,
            ),
      ),
    );
  }
}

class LegendAnimatedTagTheme {
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;
  final double height;

  LegendAnimatedTagTheme({
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.borderRadius,
    required this.border,
    required this.height,
  });
}

class LegendAnimatedTag extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final String text;
  final bool? dissmissable;
  final LegendAnimatedTagTheme theme;
  final bool? selected;
  final void Function()? onTap;

  LegendAnimatedTag({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.theme,
    required this.text,
    this.selected,
    this.onTap,
    this.icon,
    this.dissmissable,
  }) {
    print(selected);
  }

  double getWidth(BuildContext context) {
    return (theme.height / 2 - 4) * 2 +
        LegendFunctions.calcTextSize(
                text, LegendTheme.of(context).typography.h0)
            .width;
  }

  @override
  State<LegendAnimatedTag> createState() => _LegendAnimatedTagState();
}

class _LegendAnimatedTagState extends State<LegendAnimatedTag>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> foreground;
  late Animation<Color?> background;
  late Animation<double?> sizing;
  late double? progress;
  late Color? foregroundColor;
  late Color? backgroundColor;

  @override
  void initState() {
    progress = 0;
    foregroundColor = widget.theme.disabledForegroundColor;
    backgroundColor = widget.theme.disabledBackgroundColor;
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    );
    sizing = Tween<double?>(
      begin: 0,
      end: 1,
    ).animate(controller)
      ..addListener(
        () {
          setState(() {
            progress = sizing.value;
          });
        },
      );

    background = ColorTween(
      begin: widget.theme.disabledBackgroundColor,
      end: widget.backgroundColor,
    ).animate(controller)
      ..addListener(() {
        setState(() {
          backgroundColor = background.value;
        });
      });

    foreground = ColorTween(
      begin: widget.theme.disabledForegroundColor,
      end: widget.foregroundColor,
    ).animate(controller)
      ..addListener(() {
        setState(() {
          foregroundColor = foreground.value;
        });
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected != null) {
      if (widget.selected!) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
    LegendTheme t = LegendTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.selected == null) {
          if (controller.isCompleted && !controller.isAnimating) {
            controller.reverse();
          } else if (!controller.isAnimating) {
            controller.forward();
          }
        }
        if (widget.onTap != null) widget.onTap!();
      },
      child: Container(
        height: widget.theme.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: widget.theme.borderRadius,
          border: Border.all(
            color: foregroundColor ?? Colors.transparent,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.theme.height / 2 - 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LegendText(
              widget.text,
              textStyle: t.typography.h0.copyWith(
                color: foregroundColor,
              ),
            ),
            SizedBox(
              width: (progress ?? 1) * 4,
            ),
            Icon(
              widget.icon,
              size: (progress ?? 1) * 22,
              color: foregroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
