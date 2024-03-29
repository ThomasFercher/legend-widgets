import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';

class ParagraphType {
  final TextStyle textStyle;
  final EdgeInsetsGeometry? margin;
  final Widget? bottomW;

  const ParagraphType(
    this.textStyle, {
    this.margin,
    this.bottomW,
  });

  ParagraphType copyWith({
    TextStyle? textStyle,
    EdgeInsetsGeometry? margin,
    Widget? bottomW,
  }) =>
      ParagraphType(
        textStyle ?? this.textStyle,
        margin: margin ?? this.margin,
        bottomW: bottomW ?? this.bottomW,
      );

  PEntry entry(String value) => PEntry(this, value);
}

class PEntry {
  final ParagraphType type;
  final String value;

  const PEntry(this.type, this.value);
}

class LegendParagraph extends StatelessWidget {
  final List<PEntry> values;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadiusGeometry;

  const LegendParagraph(
    this.values, {
    this.margin,
    this.padding,
    this.borderRadiusGeometry,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadiusGeometry,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in values) ...[
            LegendText(
              entry.value,
              style: entry.type.textStyle,
              margin: entry.type.margin,
            ),
            if (entry.type.bottomW != null) entry.type.bottomW!,
          ],
        ],
      ),
    );
  }
}
