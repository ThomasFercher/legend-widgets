import 'package:flutter/material.dart';

import 'legendButtonStyle.dart';

export 'legendButtonStyle.dart';

class LegendButton extends StatelessWidget {
  final LegendButtonStyle? style;
  final Widget text;
  final Function onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const LegendButton({
    Key? key,
    this.style,
    required this.text,
    required this.onPressed,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double? height = style?.height;
      double? width = style?.width;

      return Container(
        padding: margin,
        constraints: height != null
            ? BoxConstraints(
                minHeight: height,
                maxHeight: height,
              )
            : null,
        child: TextButton(
          onPressed: () => onPressed(),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(style?.borderRadius ?? Radius.circular(0)),
              gradient: style?.backgroundGradient,
              boxShadow: style?.boxShadow == null
                  ? []
                  : [
                      style?.boxShadow ?? BoxShadow(),
                    ],
            ),
            child: text,
          ),
          style: style ?? ButtonStyle(),
        ),
      );
    });
  }
}
