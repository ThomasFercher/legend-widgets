import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/theming/colors/legend_color_palette.dart';
import 'package:legend_design_core/typography/legend_text.dart';
import 'package:legend_design_core/typography/typography.dart';
import 'package:legend_design_widgets/datadisplay/table/legendRowValue.dart';
import 'package:legend_design_widgets/datadisplay/table/legendTableCell.dart';
import 'package:legend_design_widgets/datadisplay/table/legendTableRow.dart';
import 'package:legend_design_widgets/legendButton/legendButton.dart';
import 'package:legend_design_widgets/legendButton/legendButtonStyle.dart';

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

class LegendTable extends StatelessWidget {
  final double? height;
  final double? width;
  final List<LegendTableValueType> columnTypes;
  final List<String>? columnNames;
  final List<int>? flexValues;
  final List<LegendRowValue> values;

  final String? header;
  final double? rowHeight;
  final bool showHeader;

  final LegendTableStyle? style;

  const LegendTable({
    this.columnNames,
    this.showHeader = false,
    this.style,
    Key? key,
    this.height,
    this.width,
    this.header,
    required this.columnTypes,
    required this.values,
    this.flexValues,
    this.rowHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = 0;
    double w = width ?? MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Container(
              width: w,
              height: rowHeight ?? 48,
              color: LegendColorPalette.darken(
                Colors.white,
                0.16,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.centerLeft,
              child: LegendText(
                text: header!,
                textStyle: LegendTextStyle(), // LegendTextStyle.tableHeader(),
              ),
            ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: getRows(),
          ),
        ],
      ),
    );
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [
      if (showHeader)
        TableRow(
          children: [
            LegendTableRow(
              flexValues: flexValues,
              columnsCells: columnNames
                      ?.map((name) => LegendTableCell.text(
                            typography:
                                style?.headerTextStyle ?? LegendTextStyle(),
                            text: name,
                          ))
                      .toList() ??
                  [],
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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
      BorderRadius? radius = j == 0 && !showHeader
          ? BorderRadius.vertical(top: Radius.circular(8))
          : j == values.length - 1
              ? BorderRadius.vertical(bottom: Radius.circular(8))
              : null;

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
              typography: style?.textStyle ?? LegendTextStyle(),
              text: val.toString(),
            );
            break;
          case LegendTableValueType.ACTION:
            cell = LegendTableCell.action(
              button: LegendButton(
                style: LegendButtonStyle.danger(),
                text: LegendText(text: val.toString()),
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
              typography: style?.textStyle ?? LegendTextStyle(),
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
            borderRadius: radius,
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
                    color: LegendColorPalette.darken(
                      style?.backgroundColor ?? Colors.white,
                      0.24,
                    ),
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
