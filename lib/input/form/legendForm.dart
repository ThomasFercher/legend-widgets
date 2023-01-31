import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_design_widgets/input/button/legendButton/legend_button.dart';

import 'package:legend_design_widgets/input/color/legend_color_input.dart';
import 'package:legend_design_widgets/input/form/formfields.dart/legendColorFormField.dart';
import 'package:legend_design_widgets/input/form/formfields.dart/legendTextFormField.dart';
import 'package:legend_design_widgets/input/form/legendFormField.dart';
import 'package:legend_design_widgets/input/switch/legendSwitch.dart';

import '../../layout/dynamic/flex/form/legendCustomFormLayout.dart';
import '../../layout/dynamic/flex/form/legendDynamicFormLayout.dart';
import '../../layout/dynamic/flex/legend_dynamic_flex_layout.dart';

class LegendForm extends StatefulWidget {
  final List<dynamic> children;

  late List<Widget> layouts;
  final bool? autovalidate;
  final double? height;
  final bool showSubmitButton;

  final String? submitText;

  final void Function(Map<String, dynamic> values)? onSubmit;
  final void Function(Map<String, dynamic> values)? onChanged;
  final Widget Function(GlobalKey<FormState> key, SplayTreeMap values)?
      buildSubmitButton;

  LegendForm({
    required this.children,
    this.autovalidate,
    this.height,
    this.onSubmit,
    this.showSubmitButton = false,
    this.buildSubmitButton,
    this.submitText,
    this.onChanged,
  }) {
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
      } else if (item is LegendCustomFormLayout) {
        LegendCustomFormLayout layout = item;
        widgets.add(getCustomLayout(layout, context));
      } else if (item is LegendDynamicFormLayout) {
        LegendDynamicFormLayout layout = item;
        widgets.add(getDynamicCustomLayout(layout, context));
      } else {
        widgets.add(item);
      }
    }
    return widgets;
  }

  Widget getDynamicCustomLayout(
      LegendDynamicFormLayout layout, BuildContext context) {
    List<Widget> formfields = [];
    for (var i = 0; i < layout.layout.fields.length; i++) {
      LegendFormField field = layout.layout.fields[i];

      formfields.add(getFormfield(field, context, true));
    }

    return LegendDynamicFlexLayout(
      dynamicLayout: layout.dynamicLayout,
      heights: layout.heights,
      layout: LegendCustomFlexLayout.dyna(
        children: formfields,
      ),
    );
  }

  Widget getCustomLayout(LegendCustomFormLayout layout, BuildContext context) {
    List<Widget> formfields = [];
    for (var i = 0; i < layout.fields.length; i++) {
      LegendFormField field = layout.fields[i];

      formfields.add(getFormfield(field, context, true));
    }

    return LegendCustomFlexLayout(
      children: formfields,
      height: layout.height,
      item: layout.item,
    );
  }

  Widget getFormRow(LegendFormRow row, BuildContext context) {
    List<Widget> children =
        row.children.map((e) => getFormfield(e, context, true)).toList();
    return Expanded(
      child: Row(
        children: children,
        mainAxisAlignment: row.alignment ?? MainAxisAlignment.start,
      ),
    );
  }

  Widget getFormfield(LegendFormField field, BuildContext context, bool isRow) {
    Widget formField = Container();
    double width = MediaQuery.of(context).size.width;

    LegendTheme theme = LegendTheme.of(context);

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
            return null;
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
        formField = LegendColorFormField(
          inital: Colors.red,
          builder: (FormFieldState<Color> s) {
            return LegendColorInput(
              onChanged: (color) {
                setState(() {
                  values[field.title] = color;
                });
                if (field.onSave != null) {
                  field.onSave!(color);
                }
                s.didChange(color);
              },
            );
          },
        );
        break;
      default:
        break;
    }

    Widget w = Container(
      width: isRow ? null : width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LegendText(
            field.title,
            style: field.textStyle ?? LegendTheme.of(context).typography.h2,
          ),
          SizedBox(
            height: 8,
          ),
          formField,
          Expanded(child: Container()),
        ],
      ),
    );

    return w;
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
                  LegendButton.text(
                    text: widget.submitText,
                    onTap: () {
                      _formKey.currentState?.validate();
                      _formKey.currentState?.save();
                      if (widget.onSubmit != null) widget.onSubmit!(values);
                    },
                    background: Colors.yellow,
                  ),
                if (widget.buildSubmitButton != null)
                  widget.buildSubmitButton!(_formKey, values)
              ],
        ),
        onChanged: () {
          if (widget.onChanged != null) widget.onChanged!(values);
        },
      ),
    );
  }
}
