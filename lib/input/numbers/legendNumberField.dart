import 'package:flutter/widgets.dart';
import 'package:legend_design_core/typography/legend_text.dart';
import 'package:legend_design_widgets/input/text/legendInputDecoration.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';

class LegendNumberField extends StatelessWidget {
  final void Function(num?)? onChanged;
  const LegendNumberField({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LegendTextField(
      onChanged: (value) {
        num? number;
        try {
          number = num.parse(value);
        } catch (e) {
          number = null;
        }

        if (onChanged != null) onChanged!(number);
      },
      decoration: LegendInputDecoration(),
    );
  }
}
