import 'package:flutter/material.dart';
import 'package:legend_design_widgets/datadisplay/searchableList.dart/legend_searchable.dart';
import 'package:legend_design_widgets/input/numbers/legendNumberField.dart';
import 'package:legend_design_widgets/input/text/legendInputDecoration.dart';
import 'package:legend_design_widgets/input/text/legendTextField.dart';

class LegendSearchableList extends StatefulWidget {
  final List<LegendSearchable> items;
  final List<Enum> filters;
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
  late final Map<Enum, dynamic> filterValues = {
    Searchable.VALUE: <num?>[
      null,
      null,
    ],
    Searchable.TEXT: null,
  };

  @override
  void initState() {
    print(filterValues);
    print(widget.searchBar);
    super.initState();
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
                setState(() {
                  filterValues[Searchable.TEXT] = value;
                });
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
                        setState(() {
                          filterValues[Searchable.VALUE][0] = value;
                        });
                        print(filterValues);
                      },
                    ),
                  ),
                  Container(
                    width: 200,
                    child: LegendNumberField(
                      onChanged: (value) {
                        setState(() {
                          filterValues[Searchable.VALUE][1] = value;
                        });
                        print(filterValues);
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
                LegendSearchable item = widget.items[index];

                if (widget.searchBar) {
                  String field = item.fields[Searchable.TEXT];
                  String? filterValue = filterValues[Searchable.TEXT];

                  if (filterValue == null || filterValue.length == 0)
                    return widget.itemBuilder(context, index);

                  filterValue = filterValue.toLowerCase();
                  field = field.toLowerCase();

                  if (field.contains(filterValue)) {
                    return widget.itemBuilder(context, index);
                  } else {
                    return Container();
                  }
                } else if (widget.value) {
                  num n = item.fields[Searchable.VALUE];
                  num? lowerValue = filterValues[Searchable.VALUE][0];
                  num? upperValue = filterValues[Searchable.VALUE][1];

                  if (lowerValue == null && upperValue == null)
                    return widget.itemBuilder(context, index);

                  if (lowerValue != null && upperValue == null) {
                    if (lowerValue > n)
                      return widget.itemBuilder(context, index);
                    else
                      return Container();
                  } else if (lowerValue == null && upperValue != null) {
                    if (upperValue < n)
                      return widget.itemBuilder(context, index);
                    else
                      return Container();
                  } else if (lowerValue != null && upperValue != null) {
                    if (upperValue > n && lowerValue < n)
                      return widget.itemBuilder(context, index);
                    else
                      return Container();
                  } else {
                    return Container();
                  }
                } else {
                  return widget.itemBuilder(context, index);
                }
              },
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
