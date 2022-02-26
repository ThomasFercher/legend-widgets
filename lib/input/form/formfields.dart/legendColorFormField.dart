import 'package:flutter/material.dart';

class LegendColorFormField extends FormField<Color> {
  final void Function(Color color) onChanged;
  final Color inital;

  LegendColorFormField({
    this.inital = Colors.white,
    required this.onChanged,
    required Widget Function(FormFieldState<Color> state) builder,
  }) : super(builder: builder);
}
