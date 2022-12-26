import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_design_widgets/datadisplay/tag/legendTag.dart';
import 'package:legend_design_widgets/input/button/legendButton/legend_button.dart';

import 'package:legend_design_widgets/layout/dynamic/row/dynamic_row.dart';

enum LegendTableValueType {
  TEXT,
  TEXTHIGHLIGHT,
  ADRESS,
  TAG,
  ACTION,
}

class LegendTableCell extends StatelessWidget {
  late String? text;
  late LegendTableValueType type;
  late TextStyle? typography;
  LegendButton? button;
  late Color color;
  late List<List<dynamic>> tags;

  LegendTableCell.text({
    required this.typography,
    required this.text,
  }) {
    type = LegendTableValueType.TEXT;
  }

  LegendTableCell.action({
    required this.button,
    required this.color,
  }) {
    type = LegendTableValueType.ACTION;
  }

  LegendTableCell.tag({
    required this.tags,
    required this.color,
    this.typography,
  }) {
    type = LegendTableValueType.TAG;
  }

  Widget getChild() {
    switch (type) {
      case LegendTableValueType.TEXT:
        return Container(
          padding: EdgeInsets.all(8.0),
          child: LegendText(
            text ?? "",
            style: typography,
          ),
        );
      case LegendTableValueType.ACTION:
        return button!;
      case LegendTableValueType.TAG:
        return Container(
          child: DynamicRow(
            verticalSpacing: 12,
            spacing: 12,
            children: List.of(
              tags.map(
                (t) => LegendTag.fromColor(
                  textStyle: typography,
                  text: t[0],
                  color: t[1] ?? Colors.transparent,
                ),
              ),
            ),
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.all(8.0),
          child: LegendText(text ?? ""),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getChild(),
    );
  }
}
