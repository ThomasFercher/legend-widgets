import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:provider/provider.dart';

class LegendColorPicker extends StatefulWidget {
  LegendColorPicker({Key? key}) : super(key: key);

  @override
  _LegendColorPickerState createState() => _LegendColorPickerState();
}

class _LegendColorPickerState extends State<LegendColorPicker> {
  @override
  Widget build(BuildContext context) {
    LegendTheme theme = context.watch<LegendTheme>();
    return Container(
      alignment: Alignment.center,
      width: 200,
      /* child: ColorPicker(
        onColorChanged: (Color value) {},
        pickerColor: Colors.red,
        showLabel: false,
        enableAlpha: false,
        displayThumbColor: false,
        portraitOnly: true,
        colorPickerWidth: 200,
        pickerAreaBorderRadius: theme.sizing.radius1.asRadius(),
      ),*/
    );
  }
}
