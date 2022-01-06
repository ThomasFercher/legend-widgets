import 'dart:core';

import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';
import 'package:legend_design_core/typography/legend_text.dart';
import 'package:legend_design_widgets/datadisplay/searchableList.dart/legend_searchable.dart';
import 'package:legend_design_widgets/input/numbers/legendNumberField.dart';
import 'package:legend_design_widgets/input/slider/legendRangeSlider.dart';
import 'package:legend_design_widgets/input/text/legendInputDecoration.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';
import 'package:provider/provider.dart';

class LegendSearchableList extends StatefulWidget {
  final List<LegendSearchable> items;
  final List<LegendSearchableFilter> filters;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  LegendSearchableList({
    Key? key,
    required this.items,
    required this.filters,
    required this.itemBuilder,
    required this.itemCount,
  }) : super(key: key);

  @override
  _LegendSearchableListState createState() => _LegendSearchableListState();
}

class _LegendSearchableListState extends State<LegendSearchableList> {
  late List<Widget> widgets;
  late Map<Type, dynamic> filterValues;

  @override
  void initState() {
    filterValues = {};

    for (LegendSearchableFilter filter in widget.filters) {
      filterValues[filter.runtimeType] =
          filter.genValue != null ? filter.genValue!() : null;
    }
    widgets = getWidgets();
    super.initState();
  }

  void filterWidgets<T>(dynamic value) {
    switch (T) {
      case LegendSearchableFilterString:
        setState(() {
          filterValues[T] = value;
        });
        break;
      case LegendSearchableFilterRange:
        setState(() {
          filterValues[T].begin = value.start;
          filterValues[T].end = value.end;
        });

        break;
      default:
    }
    print(filterValues);

    setState(() {
      widgets = getWidgets<T>();
    });
  }

  bool filterEmpty() {
    for (dynamic filterVal in filterValues.values) {
      switch (filterVal.runtimeType) {
        case String:
          String? val = filterVal;
          if (val != null && val.length != 0) return false;
          break;
        case Tween<num>:
          Tween<num> val = filterVal;

          if (val.begin != null || val.end != null) return false;
          break;
        default:
      }
    }

    return true;
  }

  List<Widget> getWidgets<T>() {
    List<Widget> widgets = [];

    for (var i = 0; i < widget.itemCount; i++) {
      if (!filterEmpty()) {
        print("a");
        LegendSearchable item = widget.items[i];
        Widget w = filterWidget<T>(item, i);
        widgets.add(w);
      } else {
        widgets.add(widget.itemBuilder(context, i));
      }
    }

    return widgets;
  }

  Widget filterWidget<T>(
    LegendSearchable item,
    int index,
  ) {
    List<bool> let = widget.filters.map((e) => false).toList();
    int i = 0;
    for (LegendSearchableFilter filter in widget.filters) {
      if (filter is LegendSearchableFilterString) {
        String? filterVal = filterValues[LegendSearchableFilterString];
        filterVal = filterVal?.toLowerCase();

        List<String> fieldValues = [];

        for (LegendSearchableField field in item.fields) {
          if (field is LegendSearchableString) {
            fieldValues.add(field.value.toLowerCase());
          }
        }

        if (filterVal?.length != 0 && filterVal != null) {
          for (String fieldValue in fieldValues) {
            if (fieldValue.contains(filterVal)) {
              let[i] = true;
            }
          }
        } else {
          let[i] = true;
        }
      } else if (filter is LegendSearchableFilterRange) {
        Tween<num> filterVal = filterValues[LegendSearchableFilterRange];

        num n = item.fields[filter.singleField].value;

        if (filterVal.begin != null || filterVal.end != null) {
          if (filterVal.begin != null && filterVal.end == null) {
            if (n > filterVal.begin!) let[i] = true;
          } else if (filterVal.begin == null && filterVal.end != null) {
            if (n < filterVal.end!) let[i] = true;
          } else {
            if (n > filterVal.begin! && n < filterVal.end!) let[i] = true;
          }
        }
      }
      i++;
    }
    bool l = let.any((element) => element == false);
    if (l)
      return Container();
    else
      return widget.itemBuilder(context, index);
  }

  Widget filterInputs(List<LegendSearchableFilter> filters) {
    ThemeProvider theme = context.watch<ThemeProvider>();
    List<Widget> widgets = [];

    for (LegendSearchableFilter filter in filters) {
      Widget w;
      if (filter is LegendSearchableFilterString) {
        w = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LegendText(
              text: filter.displayName,
              padding: EdgeInsets.only(
                top: 8,
                bottom: 16,
              ),
              textStyle: theme.typography.h4,
            ),
            LegendTextField(
              decoration: LegendInputDecoration(
                filled: true,
                fillColor: theme.colors.cardBackgroundColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.colors.foreground[1],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.colors.selectionColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
              ),
              onChanged: (value) {
                filterWidgets<LegendSearchableFilterString>(value);
              },
            ),
          ],
        );
      } else if (filter is LegendSearchableFilterRange) {
        w = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LegendText(
              text: filter.displayName,
              padding: EdgeInsets.only(
                top: 8,
                bottom: 16,
              ),
              textStyle: theme.typography.h4,
            ),
            LegendRangeSlider(
              rangeValues: RangeValues(
                filter.range?.begin?.toDouble() ?? 0,
                filter.range?.end?.toDouble() ?? 0,
              ),
              onChanged: (value) {
                filterWidgets<LegendSearchableFilterRange>(value);
              },
            ),
          ],
        );
      } else {
        w = Container();
      }

      widgets.add(
        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: w),
      );
    }

    return Column(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          filterInputs(widget.filters),
          Expanded(
            child: ListView.builder(
              itemCount: widget.itemCount,
              itemBuilder: (context, index) {
                return widgets[index];
              },
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
