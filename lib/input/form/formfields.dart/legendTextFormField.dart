import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';
import 'package:legend_design_widgets/input/form/legendFormField.dart';
import 'package:legend_design_widgets/input/text/legendInputDecoration.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';
import 'package:provider/src/provider.dart';

class LegendTextFormField extends FormField<String> {
  final LegendFormField field;
  final LegendInputDecoration? decoration;
  final void Function(String value) onChanged;

  LegendTextFormField({
    Key? key,
    required this.field,
    required this.decoration,
    required this.onChanged,
  }) : super(
          validator: (value) {
            if (field.isRequired) {
              if (field.validator != null) {
                field.validator!(value);
              } else {
                if (value == null || value.length == 0) {
                  return 'Field required';
                }
              }
            } else if (field.validator != null) {
              field.validator!(value);
            }
          },
          enabled: decoration?.enabled ?? true,
          initialValue: field.initalValue,
          builder: (state) {
            return LegendTextField(
              onChanged: (value) {
                onChanged(value);
                state.didChange(value);
                state.validate();

                if (field.onChanged != null) field.onChanged!(value);
              },
              onSubmitted: (value) {
                print(value);
              },
              decoration: state.hasError
                  ? LegendInputDecoration(
                      errorText: "Field required",
                      prefixIcon: decoration?.prefixIcon,
                    )
                  : /* decoration ??*/ LegendInputDecoration(
                      prefixIcon: Icon(
                        Icons.yard,
                      ),
                    ),
            );
          },
        );

  LegendInputDecoration getDecoration() {
    return decoration ?? LegendInputDecoration();
  }

  /*return TextFormField(
      validator: (value) {
        if (field.isRequired) {
          if (field.validator != null) {
            field.validator!(value);
          } else {
            if (value == null || value.length == 0) {
              return 'Field required';
            }
          }
        } else if (field.validator != null) {
          field.validator!(value);
        }
      },
      style: theme.typography.h1.copyWith(
        color: field.textField?.decoration.textColor,
      ),

      decoration: field.textField?.decoration,
      initialValue: field.initalValue,
      //     autovalidateMode: AutovalidateMode.disabled,
      onChanged: (value) {
        field.value = value;
        if (field.onChanged != null) field.onChanged!(value);
      },
      onSaved: field.onSave != null
          ? (value) {
              field.onSave!(value);
            }
          : null,
      onFieldSubmitted: field.onSave != null
          ? (value) {
              field.onSave!(value);
            }
          : null,
    );
  }*/

}
