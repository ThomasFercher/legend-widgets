import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';

enum LegendFormFieldType {
  TEXT,
  BOOL,
  INT,
  FLOAT,
  COLOR,
}

class LegendFormRow {
  final List<LegendFormField> children;
  final MainAxisAlignment? alignment;

  LegendFormRow({
    required this.children,
    this.alignment,
  });
}

class LegendFormField<T> {
  final LegendFormFieldType type;
  final LegendTextField? textField;
  final T? initalValue;
  final Function(T value)? onChanged;
  final Function(T value)? onSave;
  final String title;
  final TextStyle? textStyle;
  final Function(T? val)? validator;
  late bool isRequired;
  late T? value;

  LegendFormField({
    required this.type,
    this.textField,
    this.initalValue,
    this.onChanged,
    this.onSave,
    required this.title,
    this.textStyle,
    this.validator,
    bool? isRequired,
  }) {
    this.isRequired = isRequired ?? false;
    this.value = initalValue;
  }
  factory LegendFormField.text({
    required LegendTextField text,
    required String title,
    Function(T value)? onChanged,
    Function(T value)? onSave,
    bool? isRequired,
    TextStyle? textStyle,
  }) {
    return LegendFormField<T>(
      type: LegendFormFieldType.TEXT,
      textField: text,
      onChanged: onChanged,
      onSave: onSave,
      isRequired: isRequired,
      title: title,
      textStyle: textStyle,
    );
  }

  factory LegendFormField.integer({
    required LegendTextField text,
    required String title,
    Function(T value)? onChanged,
    Function(T value)? onSave,
    bool? isRequired,
  }) {
    return LegendFormField<T>(
      type: LegendFormFieldType.INT,
      textField: text,
      onChanged: onChanged,
      onSave: onSave,
      isRequired: isRequired,
      title: title,
    );
  }

  factory LegendFormField.float({
    required LegendTextField text,
    required String title,
    Function(T value)? onChanged,
    Function(T value)? onSave,
    bool? isRequired,
  }) {
    return LegendFormField<T>(
      type: LegendFormFieldType.FLOAT,
      textField: text,
      onChanged: onChanged,
      onSave: onSave,
      isRequired: isRequired,
      title: title,
    );
  }

  factory LegendFormField.color({
    required LegendTextField text,
    required String title,
    Function(T value)? onChanged,
    Function(T value)? onSave,
    bool? isRequired,
  }) {
    return LegendFormField<T>(
      type: LegendFormFieldType.COLOR,
      textField: text,
      onChanged: onChanged,
      onSave: onSave,
      isRequired: isRequired,
      title: title,
    );
  }

  factory LegendFormField.boolean({
    Function(T value)? onChanged,
    Function(T value)? onSave,
    Function(T? value)? validator,
    required String title,
    bool? isRequired,
  }) {
    return LegendFormField<T>(
      type: LegendFormFieldType.BOOL,
      onChanged: onChanged,
      onSave: onSave,
      title: title,
      isRequired: isRequired,
      validator: validator,
    );
  }
}
