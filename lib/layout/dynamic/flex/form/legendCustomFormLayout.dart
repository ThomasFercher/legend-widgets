import 'package:legend_design_widgets/input/form/legendFormField.dart';

import '../items/legendLayoutItem.dart';

class LegendCustomFormLayout {
  final LegendLayoutItem item;
  final List<LegendFormField> fields;

  final double? height;

  LegendCustomFormLayout({
    required this.item,
    required this.fields,
    this.height,
  });

  factory LegendCustomFormLayout.dyna({
    required List<LegendFormField> fields,
  }) {
    return LegendCustomFormLayout(
      item: LegendLayoutNone(),
      fields: fields,
    );
  }
}
