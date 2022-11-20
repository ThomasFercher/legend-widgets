import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';

class ParagraphType {
  final TextStyle textStyle;
  final double bottom;
  final Key? key;
  final Widget? bottomW;

  ParagraphType({
    required this.textStyle,
    required this.bottom,
    this.bottomW,
    this.key,
  });

  ParagraphType get withId => ParagraphType(
        bottom: bottom,
        textStyle: textStyle,
        bottomW: bottomW,
        key: UniqueKey(),
      );
}

class LegendParagraph extends StatelessWidget {
  final Map<ParagraphType, String> values;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadiusGeometry;

  LegendParagraph({
    Key? key,
    required this.values,
    this.margin,
    this.padding,
    this.borderRadiusGeometry,
    this.backgroundColor,
  }) : super(key: key);

  List<Widget> getTiles() {
    List<Widget> tiles = [];

    for (var i = 0; i < values.values.length; i++) {
      ParagraphType type = values.keys.toList()[i];
      String val = values.values.toList()[i];
      // print(type);
      tiles.add(
        Column(
          children: [
            LegendText(
              val,
              textStyle: type.textStyle,
              padding: (type.bottomW != null)
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      bottom: type.bottom,
                    ),
            ),
            if (type.bottomW != null) type.bottomW!,
          ],
        ),
      );
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    // print(values);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadiusGeometry,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getTiles(),
      ),
    );
  }
}
