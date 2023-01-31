import 'package:flutter/material.dart';
import 'package:legend_design_core/state/legend_state.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_utils/extensions/extensions.dart';
import 'package:legend_utils/functions/functions.dart';

class LegendTag extends LegendWidget {
  final Color color;
  final Color background;
  final Color border;
  final String text;
  final TextStyle? textStyle;
  final bool? dissmissable;
  final double horizontalPadding;
  final double verticalPadding;

  const LegendTag({
    required this.text,
    required this.color,
    required this.background,
    required this.border,
    this.textStyle,
    this.dissmissable,
    this.horizontalPadding = 12,
    this.verticalPadding = 6,
  });

  factory LegendTag.fromColor({
    required String text,
    required Color color,
    TextStyle? textStyle,
    bool? dissmissable,
    double horizontalPadding = 16,
  }) {
    return LegendTag(
      text: text,
      color: color,
      background: color.lighten(0.35),
      border: color,
      textStyle: textStyle,
      dissmissable: dissmissable,
      horizontalPadding: horizontalPadding,
    );
  }

  factory LegendTag.fromForegroundBackground({
    required String text,
    required Color foreground,
    required Color background,
    TextStyle? textStyle,
    bool? dissmissable,
    double horizontalPadding = 16,
  }) {
    return LegendTag(
      text: text,
      color: foreground,
      background: background,
      border: foreground,
      textStyle: textStyle,
      dissmissable: dissmissable,
      horizontalPadding: horizontalPadding,
    );
  }
  @override
  Widget build(BuildContext context, LegendTheme theme) {
    final _textStyle = textStyle ??
        theme.typography.h1.copyWith(
          color: color,
          fontSize: 16,
        );
    final textWidth = LegendFunctions.calcTextSize(text, _textStyle).width;

    return SizedBox(
      width: textWidth + horizontalPadding * 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
          border: Border.all(
            color: border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
          ),
          child: Center(
            child: LegendText(
              text,
              style: _textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class LegendAnimatedTagTheme {
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final double height;

  LegendAnimatedTagTheme({
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    this.borderRadius,
    this.border,
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
              style: t.typography.h0.copyWith(
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
