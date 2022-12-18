import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_design_core/styles/typography/typography.dart';

import 'package:legend_utils/extensions/extensions.dart';
import 'package:legend_design_widgets/datadisplay/table/legendRowValue.dart';
import 'package:legend_design_widgets/datadisplay/table/legendTableCell.dart';
import 'package:legend_design_widgets/datadisplay/table/legendTableRow.dart';
import 'package:legend_design_widgets/input/button/legendButton/legendButton.dart';
import 'package:legend_design_widgets/input/button/legendButton/legendButtonStyle.dart';

class LegendTableStyle {
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadiusGeometry;
  final Color selectionColor;
  final TextStyle textStyle;
  final EdgeInsets? rowPadding;
  final Color? headerColor;
  final TextStyle? headerTextStyle;

  const LegendTableStyle({
    this.rowPadding,
    this.headerTextStyle,
    this.headerColor,
    required this.textStyle,
    required this.backgroundColor,
    required this.selectionColor,
    required this.borderRadiusGeometry,
  });
}

/// TODO: Implement either with Custom Painter (if layout is possible with it) or else with a MultiChildLayoutDelegate
class LegendTable extends StatelessWidget {
  final double? height;
  final double? width;
  final List<LegendTableValueType> columnTypes;
  final List<String>? columnNames;
  final List<int>? flexValues;
  final List<LegendRowValue> values;

  final double? rowHeight;

  final LegendTableStyle? style;

  const LegendTable({
    this.columnNames,
    this.style,
    Key? key,
    this.height,
    this.width,
    required this.columnTypes,
    required this.values,
    this.flexValues,
    this.rowHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = width ?? MediaQuery.of(context).size.width;

    return Container(
      height: height,
      child: ClipRRect(
        borderRadius: style?.borderRadiusGeometry ?? BorderRadius.zero,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: getHeaderRow(),
        ),
      ),
    );
  }

  List<TableRow> getHeaderRow() {
    List<TableRow> rows = [
      TableRow(
        children: [
          LegendTableRow(
            flexValues: flexValues,
            columnsCells: columnNames
                    ?.map((name) => LegendTableCell.text(
                          typography: style?.headerTextStyle ?? TextStyle(),
                          text: name,
                        ))
                    .toList() ??
                [],
            height: rowHeight ?? 48,
            avtiveColor: style?.selectionColor,
            backgroundColor: style?.headerColor,
            padding: style?.rowPadding,
          ),
        ],
      ),
    ];

    // Row
    TableRow row;
    for (var j = 0; j < values.length; j++) {
      var value = values[j];
      // Columns
      List<LegendTableCell> columnsCells = [];
      for (var i = 0; i < value.fields.length; i++) {
        LegendTableValueType type = columnTypes[i];
        LegendTableCell cell;

        dynamic val = value.fields[i];

        switch (type) {
          case LegendTableValueType.TEXT:
            cell = LegendTableCell.text(
              typography: style?.textStyle ?? TextStyle(),
              text: val.toString(),
            );
            break;
          case LegendTableValueType.ACTION:
            cell = LegendTableCell.action(
              button: LegendButton(
                style: LegendButtonStyle.danger(),
                text: LegendText(val.toString()),
                onPressed: () {
                  value.actionFunction!();
                },
              ),
              color: Colors.red,
            );
            break;
          case LegendTableValueType.TAG:
            cell = LegendTableCell.tag(
              // typography: style?.textStyle,
              color: Colors.red,
              tags: val,
            );
            break;
          default:
            cell = LegendTableCell.text(
              typography: style?.textStyle ?? TextStyle(),
              text: val.toString(),
            );
            break;
        }
        columnsCells.add(cell);
      }

      row = new TableRow(
        children: [
          LegendTableRow(
            flexValues: flexValues,
            columnsCells: columnsCells,
            height: rowHeight ?? 48,
            avtiveColor: style?.selectionColor,
            backgroundColor: style?.backgroundColor,
            padding: style?.rowPadding,
          ),
        ],
        decoration: BoxDecoration(
          border: j % 2 == 0
              ? Border.symmetric(
                  horizontal: BorderSide(
                    color: style?.backgroundColor.darken(0.24) ??
                        Colors.white.darken(0.24),
                    width: 2,
                  ),
                )
              : null,
        ),
      );
      rows.add(row);
    }

    return rows;
  }
}
