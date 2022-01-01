import 'package:flutter/material.dart';
import 'package:legend_design_widgets/datadisplay/searchableList.dart/legend_searchable.dart';
import 'package:legend_design_widgets/input/numbers/legendNumberField.dart';
import 'package:legend_design_widgets/input/text/legendInputDecoration.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';

class LegendSearchableList extends StatefulWidget {
  final List<LegendSearchable> items;
  final List<Searchable> filters;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  late final bool searchBar;
  late final bool value;

  LegendSearchableList({
    Key? key,
    required this.items,
    required this.filters,
    required this.itemBuilder,
    required this.itemCount,
  }) : super(key: key) {
    searchBar = filters.contains(Searchable.TEXT);
    value = filters.contains(Searchable.VALUE);
  }

  @override
  _LegendSearchableListState createState() => _LegendSearchableListState();
}

class _LegendSearchableListState extends State<LegendSearchableList> {
  late List<Widget> widgets;
  late List<dynamic> filters;
  late final Map<Searchable, dynamic> filterValues = {
    Searchable.VALUE: Tween<num>(),
    Searchable.TEXT: "",
  };

  @override
  void initState() {
    print(filterValues);
    print(widget.searchBar);
    filters = [];
    widgets = getWidgets();

    super.initState();
  }

  void filterWidgets(
    Searchable filter,
    dynamic value, {
    bool? begin,
  }) {
    switch (filter) {
      case Searchable.TEXT:
        setState(() {
          filterValues[Searchable.TEXT] = value;
        });
        break;
      case Searchable.VALUE:
        setState(() {
          if (begin ?? false) {
            filterValues[Searchable.VALUE].begin = value;
          } else {
            filterValues[Searchable.VALUE].end = value;
          }
        });
        break;
      default:
    }

    setState(() {
      filters = filterValues.values.toList();
      widgets = getWidgets(filters: filters);
    });
  }

  bool filterEmpty() {
    for (dynamic filterVal in filters) {
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

  List<Widget> getWidgets({List<dynamic>? filters}) {
    List<Widget> widgets = [];

    for (var i = 0; i < widget.itemCount; i++) {
      if (!filterEmpty()) {
        print("a");
        LegendSearchable item = widget.items[i];
        Widget w = filterWidget(item, filters!, i);
        widgets.add(w);
      } else {
        widgets.add(widget.itemBuilder(context, i));
      }
    }

    return widgets;
  }

  Widget filterWidget(LegendSearchable item, List<dynamic> filters, int index) {
    bool letThrough = false;
    for (dynamic filter in filters) {
      switch (filter.runtimeType) {
        case String:
          String? filterVal = filter;
          filterVal = filterVal?.toLowerCase();

          List<String> fieldValues = [];

          for (LegendSearchableField field in item.fields) {
            if (field is LegendSearchableString) {
              fieldValues.add(field.value.toLowerCase());
            }
          }

          if (filterVal?.length == 0 || filterVal == null) {
            break;
          } else {
            for (String fieldValue in fieldValues) {
              if (fieldValue.contains(filterVal)) {
                letThrough = true;
              }
            }
          }

          break;
        case Tween<num>:
          Tween<num> filterVal = filter;

          num? n;

          for (LegendSearchableField field in item.fields) {
            if (field is LegendSearchableNumber) {
              n = field.value;
            }
          }

          if (filterVal.begin == null && filterVal.end == null && n != null) {
            break;
          }

          if (filterVal.begin != null && filterVal.end == null) {
            if (n! > filterVal.begin!) letThrough = true;
          } else if (filterVal.begin == null && filterVal.end != null) {
            if (n! < filterVal.end!) letThrough = true;
          } else {
            if (n! > filterVal.begin! && n < filterVal.end!) letThrough = true;
          }

          break;
        default:
      }
    }

    print(letThrough);
    if (letThrough)
      return widget.itemBuilder(context, index);
    else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (widget.searchBar)
            LegendTextField(
              decoration: LegendInputDecoration(),
              onChanged: (value) {
                filterWidgets(Searchable.TEXT, value);
              },
            ),
          if (widget.value)
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 200,
                    child: LegendNumberField(
                      onChanged: (value) {
                        filterWidgets(Searchable.VALUE, value, begin: true);
                      },
                    ),
                  ),
                  Container(
                    width: 200,
                    child: LegendNumberField(
                      onChanged: (value) {
                        filterWidgets(Searchable.VALUE, value, begin: false);
                      },
                    ),
                  ),
                ],
              ),
            ),
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
