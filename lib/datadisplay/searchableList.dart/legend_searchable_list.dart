import 'dart:core';

import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';
import 'package:legend_design_core/typography/legend_text.dart';
import 'package:legend_design_widgets/datadisplay/searchableList.dart/legend_searchable.dart';
import 'package:legend_design_widgets/input/dropdown.dart/legendDropdownOption.dart';
import 'package:legend_design_widgets/input/dropdown.dart/legendInputDropdown.dart';
import 'package:legend_design_widgets/input/slider/legendRangeSlider.dart';
import 'package:legend_design_widgets/input/text/legendInputDecoration.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';
import 'package:legend_design_widgets/layout/customFlexLayout/legend_custom_flex_layout.dart';
import 'package:provider/provider.dart';

class LegendSearchableList extends StatefulWidget {
  final List<LegendSearchable> items;
  final List<LegendSearchableFilter> filters;
  final List<Widget> itemWidgets;
  final List<SortableField>? sortableFields;
  final int itemCount;
  final LegendFlexItem? customFilterLayout;
  final double? filterHeight;
  final Widget Function(
      void Function(SortableField field, SortStatus status) sort) buildHeader;

  LegendSearchableList({
    Key? key,
    required this.items,
    required this.filters,
    required this.itemWidgets,
    required this.itemCount,
    this.sortableFields,
    this.customFilterLayout,
    this.filterHeight,
    required this.buildHeader,
  }) : super(key: key) {
    for (LegendSearchable item in items) {
      print(item.fields[0].value);
    }
  }

  @override
  _LegendSearchableListState createState() => _LegendSearchableListState();
}

class _LegendSearchableListState extends State<LegendSearchableList> {
  late List<Widget> widgets;
  late Map<Type, dynamic> filterValues;
  late Map<SortableField, SortStatus> sortStatus;
  late List<Widget> allWidgets;
  late List<LegendSearchable> allItems;

  @override
  void initState() {
    filterValues = {};
    sortStatus = {};

    for (LegendSearchableFilter filter in widget.filters) {
      filterValues[filter.runtimeType] =
          filter.genValue != null ? filter.genValue!() : null;
    }

    if (widget.sortableFields != null)
      for (SortableField field in widget.sortableFields!) {
        sortStatus[field] = SortStatus.None;
      }

    allItems = List.from(widget.items);
    allWidgets = List.from(widget.itemWidgets);
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
      case LegendSearchableFilterCategory:
        setState(() {
          filterValues[T] = value;
        });
        break;
      default:
    }
    print(filterValues);

    setState(() {
      widgets = getWidgets();
    });
  }

  void sortWidgets(SortableField field, SortStatus status) {
    int i = field.index;
    bool setOld = status == SortStatus.None;
    List<Widget> new_widgets;

    if (setOld) {
      new_widgets = List.from(widget.itemWidgets);
      allItems = List.from(widget.items);
      sortStatus[field] = SortStatus.None;
    } else {
      Comparator<LegendSearchable>? comparator;
      switch (field.type) {
        case double:
          comparator = (a, b) {
            double val_a = a.fields[i].value as double;
            double val_b = b.fields[i].value as double;

            switch (status) {
              case SortStatus.Ascending:
                return (val_a - val_b).toInt();

              case SortStatus.Descending:
                return (val_b - val_a).toInt();

              case SortStatus.None:
                return 0;
            }
          };
          break;
        case String:
          comparator = (a, b) {
            String val_a = a.fields[i].value as String;
            String val_b = b.fields[i].value as String;

            switch (status) {
              case SortStatus.Ascending:
                return val_a.compareTo(val_b);

              case SortStatus.Descending:
                return val_b.compareTo(val_a);

              case SortStatus.None:
                return 0;
            }
          };
          break;
      }

      List<int> order = allItems.map((e) => e.hashCode).toList();
      allItems.sort(comparator);
      List<int> orderAfter = allItems.map((e) => e.hashCode).toList();

      new_widgets = new List.generate(
        allWidgets.length,
        (index) => Container(),
      );

      for (var i = 0; i < allWidgets.length; i++) {
        int new_index = orderAfter.indexOf(order[i]);
        new_widgets[new_index] = allWidgets[i];
      }
    }

    setState(() {
      allWidgets = new_widgets;
      widgets = getWidgets();
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

  List<Widget> getWidgets() {
    List<Widget> widgets = [];

    for (var i = 0; i < widget.itemCount; i++) {
      if (!filterEmpty()) {
        LegendSearchable item = allItems[i];
        Widget w = filterWidget(item, i);
        widgets.add(w);
      } else {
        widgets.add(allWidgets[i]);
      }
    }

    return widgets;
  }

  Widget filterWidget(
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
        } else {
          let[i] = true;
        }
      } else if (filter is LegendSearchableFilterCategory) {
        String? filterVal = filterValues[LegendSearchableFilterCategory];
        String fieldVal = item.fields[filter.singleField].value;
        if (filterVal != null && filterVal.length != 0) {
          if (filterVal == fieldVal) {
            let[i] = true;
          }
        } else {
          let[i] = true;
        }
      }
      i++;
    }

    bool l = let.any((element) => element == false);

    if (l)
      return Container();
    else
      return allWidgets[index];
  }

  List<Widget> getFilterInputs(List<LegendSearchableFilter> filters) {
    ThemeProvider theme = context.watch<ThemeProvider>();
    List<Widget> widgets = [];

    for (int i = 0; i < filters.length; i++) {
      LegendSearchableFilter filter = filters[i];
      Widget w;
      if (filter is LegendSearchableFilterString) {
        w = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendText(
              text: filter.displayName,
              padding: EdgeInsets.only(
                bottom: 8,
              ),
              textStyle: theme.typography.h4,
            ),
            LegendTextField(
              decoration: LegendInputDecoration.rounded(
                backgroundColor: theme.colors.foreground[1],
                focusColor: theme.colors.selectionColor,
                borderColor: theme.colors.disabledColor,
                textColor: theme.colors.textColorLight,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendText(
              text: filter.displayName,
              padding: EdgeInsets.only(
                bottom: 8,
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
      } else if (filter is LegendSearchableFilterCategory) {
        w = LayoutBuilder(builder: (context, constraints) {
          print(constraints);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendText(
                text: filter.displayName,
                padding: EdgeInsets.only(
                  bottom: 8,
                ),
                textStyle: theme.typography.h4,
              ),
              LegendInputDropdown(
                options: filter.categories
                    .map(
                      (e) => PopupMenuOption(
                        value: e.value,
                        icon: e.icon,
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  filterWidgets<LegendSearchableFilterCategory>(value);
                },
                offset: Offset(0, constraints.maxHeight / 2 - 2),
                decoration: LegendInputDecoration.rounded(
                  backgroundColor: theme.colors.foreground[1],
                  focusColor: theme.colors.selectionColor,
                  borderColor: theme.colors.disabledColor,
                  textColor: theme.colors.textColorLight,
                ),
              ),
            ],
          );
        });
      } else {
        w = Container();
      }

      widgets.add(
        Container(
          color: Colors.green,
          padding: EdgeInsets.only(
            top: 4,
            bottom: (i == filters.length - 1) ? 4 : 0,
          ),
          child: Container(
            child: w,
            color: Colors.red,
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> headerInputs() {
    List<Widget> widgets = [];

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (widget.customFilterLayout != null)
            LegendCustomFlexLayout(
              item: widget.customFilterLayout!,
              widgets: getFilterInputs(widget.filters),
              height: widget.filterHeight ?? 400,
            ),
          if (widget.customFilterLayout == null)
            Column(
              children: getFilterInputs(widget.filters),
            ),
          widget.buildHeader(sortWidgets),
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
