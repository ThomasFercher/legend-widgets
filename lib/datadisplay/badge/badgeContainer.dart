import 'package:flutter/material.dart';
import 'package:legend_design_core/typography/legend_text.dart';
import 'package:legend_design_core/typography/typography.dart';

class BadgeContainer extends StatelessWidget {
  final int? count;
  final String? text;
  final double? height;
  final Color badgeColor;
  const BadgeContainer({
    this.count,
    this.text,
    this.height,
    required this.badgeColor,
  });

  String getData() {
    if (count != null) {
      return "$count";
    } else if (text != null) {
      return text!;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: badgeColor,
      ),
      child: LegendText(
        textStyle: LegendTextStyle(fontSize: 8),
        text: getData(),
      ),
    );
  }
}
