import 'package:flutter/material.dart';
import 'package:legend_design_core/icons/legend_animated_icon.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';
import 'package:legend_design_widgets/input/dropdown.dart/legendDropdown.dart';
import 'package:legend_design_widgets/input/dropdown.dart/legendDropdownOption.dart';
import 'package:legend_design_widgets/input/text/legendInputDecoration.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';
import 'package:provider/src/provider.dart';

class LegendInputDropdown extends StatefulWidget {
  final List<PopupMenuOption> options;
  final void Function(String value)? onSelected;
  late final LegendInputDecoration? decoration;
  final String? initalValue;
  final double? popupWidth;
  final Offset? offset;

  LegendInputDropdown({
    Key? key,
    this.onSelected,
    this.initalValue,
    this.popupWidth,
    required this.options,
    LegendInputDecoration? decoration,
    this.offset,
  }) : super(key: key) {
    this.decoration = decoration ?? LegendInputDecoration();
  }

  @override
  State<LegendInputDropdown> createState() => _LegendInputDropdownState();
}

class _LegendInputDropdownState extends State<LegendInputDropdown> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController(
      text: widget.initalValue ?? "",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = context.watch<ThemeProvider>();
    return TextField(
      controller: _controller,
      style: theme.typography.h1.copyWith(
        color: widget.decoration?.textColor,
      ),
      decoration: widget.decoration?.copyWith(
        suffixIcon: LegendDropdown(
          popupWidth: widget.popupWidth,
          options: widget.options,
          offset: widget.offset,
          onSelected: (selected) {
            _controller.text = selected.value;

            if (widget.onSelected != null) {
              widget.onSelected!(selected.value);
            }
          },
          icon: Icons.arrow_drop_down,
        ),
      ),
    );
  }
}
