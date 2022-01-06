import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';
import 'package:legend_design_core/typography/legend_text.dart';
import 'package:legend_design_core/typography/typography.dart';
import 'package:legend_design_widgets/input/form/formfields.dart/legendTextFormField.dart';
import 'package:legend_design_widgets/input/form/legendFormField.dart';
import 'package:legend_design_widgets/input/switch/legendSwitch.dart';
import 'package:legend_design_widgets/legendButton/legendButton.dart';
import 'package:legend_design_widgets/legendButton/legendButtonStyle.dart';
import 'package:provider/src/provider.dart';

class LegendForm extends StatefulWidget {
  final List<dynamic> children;
  late List<LegendFormField> fields;
  late List<Widget> layouts;
  final bool? autovalidate;
  final double? height;
  final bool showSubmitButton;

  final String? submitText;
  final LegendButtonStyle? buttonStyle;
  final void Function(Map<String, dynamic> values)? onSubmit;
  final void Function(Map<String, dynamic> values)? onChanged;
  final Widget Function(GlobalKey<FormState> key)? buildSubmitButton;

  LegendForm({
    required this.children,
    this.autovalidate,
    this.height,
    this.onSubmit,
    this.showSubmitButton = true,
    this.buildSubmitButton,
    this.submitText,
    this.buttonStyle,
    this.onChanged,
  }) {
    fields = children.whereType<LegendFormField>().toList();
    layouts = children.whereType<Widget>().toList();
  }

  @override
  _LegendFormState createState() => _LegendFormState();
}

class _LegendFormState extends State<LegendForm> {
  final _formKey = GlobalKey<FormState>();
  late SplayTreeMap<String, dynamic> values;

  @override
  void initState() {
    super.initState();
    values = SplayTreeMap();

    for (LegendFormField field in widget.fields) {
      values[field.title] = null;
    }
  }

  List<Widget> getFields(BuildContext context) {
    List<Widget> widgets = [];

    for (var i = 0; i < widget.children.length; i++) {
      dynamic item = widget.children[i];
      if (item is LegendFormField) {
        LegendFormField field = item;
        widgets.add(getFormfield(field, context, false));
      } else if (item is LegendFormRow) {
        LegendFormRow row = item;
        widgets.add(getFormRow(row, context));
      } else {
        widgets.add(item);
      }
    }
    return widgets;
  }

  Widget getFormRow(LegendFormRow row, BuildContext context) {
    List<Widget> children =
        row.children.map((e) => getFormfield(e, context, true)).toList();
    return Row(
      children: children,
      mainAxisAlignment: row.alignment ?? MainAxisAlignment.start,
    );
  }

  Widget getFormfield(LegendFormField field, BuildContext context, bool isRow) {
    Widget formField = Container();
    double width = MediaQuery.of(context).size.width;

    ThemeProvider theme = context.watch<ThemeProvider>();

    switch (field.type) {
      case LegendFormFieldType.BOOL:
        formField = FormField<bool>(
          builder: (f) {
            return LegendSwitch(
              activeColor: f.hasError ? Colors.redAccent : Colors.tealAccent,
              onChanged: field.onChanged != null
                  ? (value) {
                      field.onChanged!(value);
                    }
                  : null,
            );
          },
          initialValue: field.initalValue,
          autovalidateMode: AutovalidateMode.disabled,
          onSaved: field.onSave != null
              ? (value) {
                  field.onSave!(value);
                }
              : null,
        );
        break;

      case LegendFormFieldType.TEXT:
        formField = LegendTextFormField(
          field: field,
          decoration: field.textField?.decoration,
          onChanged: (value) {
            setState(() {
              values[field.title] = value;
            });
          },
        );
        break;
      case LegendFormFieldType.INT:
        formField = FormField<int>(
          initialValue: field.initalValue,
          validator: (value) {
            if (field.isRequired) {
              if (field.validator != null) {
                field.validator!(value);
              } else {
                if (value == null) {
                  return 'Field required';
                }
              }
            } else if (field.validator != null) {
              field.validator!(value);
            }
          },
          builder: (f) {
            return SizedBox(
              width: 120,
              height: 80,
              child: TextField(),
            );
          },
          autovalidateMode: AutovalidateMode.disabled,
          onSaved: field.onSave != null
              ? (value) {
                  field.value = value;
                  field.onSave!(value);
                }
              : null,
        );
        break;

      case LegendFormFieldType.FLOAT:
        break;
      case LegendFormFieldType.COLOR:
        break;
      default:
        break;
    }

    Widget w = Container(
      padding: EdgeInsets.only(bottom: 12),
      width: isRow ? null : width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LegendText(
            text: field.title,
            textStyle: context.watch<ThemeProvider>().typography.h2,
          ),
          formField,
        ],
      ),
    );

    if (isRow) w = Expanded(child: w);

    return w;
  }

  Map<String, dynamic> getValues() {
    SplayTreeMap<String, dynamic> values = new SplayTreeMap();

    widget.fields.forEach((field) {
      values[field.title] = field.value;
    });

    return values;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Form(
        key: _formKey,
        child: Column(
          children: getFields(context) +
              [
                if (widget.showSubmitButton)
                  LegendButton(
                    text: LegendText(text: widget.submitText),
                    onPressed: () {
                      _formKey.currentState?.validate();
                      _formKey.currentState?.save();
                      if (widget.onSubmit != null) widget.onSubmit!(values);
                    },
                    style: widget.buttonStyle,
                  ),
                if (widget.buildSubmitButton != null)
                  widget.buildSubmitButton!(_formKey)
              ],
        ),
        onChanged: () {
          if (widget.onChanged != null) widget.onChanged!(values);
        },
      ),
    );
  }
}
