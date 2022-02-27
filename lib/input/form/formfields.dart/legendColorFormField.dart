import 'package:flutter/material.dart';

class LegendColorFormField extends FormField<Color> {
  final Color inital;

  LegendColorFormField({
    this.inital = Colors.white,
    required Widget Function(FormFieldState<Color> state) builder,
  }) : super(builder: builder);
}
