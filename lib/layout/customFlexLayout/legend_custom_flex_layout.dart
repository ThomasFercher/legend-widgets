import 'package:flutter/material.dart';
import 'package:legend_design_widgets/input/form/legendFormField.dart';

class LegendCustomFlexFormLayout {
  final LegendFlexItem? item;
  final double? height;
  final List<LegendFormField> fields;
  final DynamicFlexItem? dynamicItem;

  LegendCustomFlexFormLayout({
    this.item,
    this.height,
    required this.fields,
    this.dynamicItem,
  });
}

class LegendCustomFlexLayout extends StatelessWidget {
  LegendFlexItem? item;
  final DynamicFlexItem? dynamicItem;
  final List<Widget> widgets;
  final double? height;
  List<Widget> alignedWidgets = [];

  LegendCustomFlexLayout({
    this.item,
    required this.widgets,
    this.dynamicItem,
    this.height,
  });

  Widget getChildrenExpanded(
    LegendFlexItem item, {
    double? height,
    double? width,
  }) {
    Widget widget;

    switch (item.type) {
      case LegendFlexLayoutType.COLUMN:
        List<Widget> columnWidgets = [];

        if (item.childrenIndex != null) {
          int i = 0;
          for (int index in item.childrenIndex!) {
            columnWidgets.add(
              Expanded(
                child: widgets[index],
                flex: item.childrenFlex?[i] ?? 1,
              ),
            );

            i++;
          }
        }

        if (item.hasChildren) {
          for (LegendFlexItem item in item.children!) {
            columnWidgets.add(
              Expanded(
                child: getChildrenExpanded(item),
                flex: item.flex ?? 1,
              ),
            );
          }
        }

        widget = Container(
          height: height,
          child: Column(
            children: columnWidgets,
          ),
        );

        break;
      case LegendFlexLayoutType.ROW:
        List<Widget> rowWidgets = [];

        if (item.childrenIndex != null) {
          int i = 0;
          for (int index in item.childrenIndex!) {
            rowWidgets.add(
              Expanded(
                child: widgets[index],
                flex: item.childrenFlex?[i] ?? 1,
              ),
            );
            i++;
          }
        }

        if (item.hasChildren) {
          for (LegendFlexItem item in item.children!) {
            print(item.flex);
            rowWidgets.add(
              Flexible(
                child: getChildrenExpanded(item),
                flex: item.flex ?? 1,
              ),
            );
          }
        }

        for (var i = 1; i < rowWidgets.length; i += 2) {
          rowWidgets.insert(
            i,
            SizedBox(
              width: item.spacing,
            ),
          );
        }

        widget = Container(
          height: height,
          child: Row(
            children: rowWidgets,
          ),
        );

        break;
    }

    return widget;
  }

  Widget getChildren(
    LegendFlexItem item, {
    double? height,
    double? width,
  }) {
    Widget widget;

    switch (item.type) {
      case LegendFlexLayoutType.COLUMN:
        List<Widget> columnWidgets = [];

        if (item.childrenIndex != null) {
          int i = 0;
          for (int index in item.childrenIndex!) {
            columnWidgets.add(
              widgets[index],
            );

            i++;
          }
        }

        if (item.hasChildren) {
          for (LegendFlexItem item in item.children!) {
            columnWidgets.add(
              getChildren(item),
            );
          }
        }
        for (var i = 1; i < columnWidgets.length; i += 2) {
          columnWidgets.insert(
            i,
            SizedBox(
              height: item.spacing,
            ),
          );
        }

        widget = Container(
          height: height,
          child: Column(
            children: columnWidgets,
          ),
        );

        break;
      case LegendFlexLayoutType.ROW:
        List<Widget> rowWidgets = [];

        if (item.childrenIndex != null) {
          int i = 0;
          for (int index in item.childrenIndex!) {
            rowWidgets.add(
              widgets[index],
            );
            i++;
          }
        }

        if (item.hasChildren) {
          for (LegendFlexItem item in item.children!) {
            print(item.flex);
            rowWidgets.add(
              getChildren(item),
            );
          }
        }

        for (var i = 1; i < rowWidgets.length; i += 2) {
          rowWidgets.insert(
            i,
            SizedBox(
              width: item.spacing,
            ),
          );
        }

        widget = Container(
          height: height,
          child: Row(
            children: rowWidgets,
          ),
        );

        break;
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, snapshot) {
        print(snapshot);
        bool heightInfinity =
            snapshot.maxHeight == double.infinity && height == null;

        print(heightInfinity);

        if (dynamicItem != null) {
          item = dynamicItem!.getItem(snapshot.maxWidth);
        }
        if (item != null) {
          return heightInfinity
              ? getChildren(item!)
              : getChildrenExpanded(
                  item!,
                  height: height ?? 300,
                );
        } else {
          throw Exception("Flex layout item is null");
        }
      },
    );
  }
}

enum LegendFlexLayoutType {
  COLUMN,
  ROW,
}

class DynamicFlexItem {
  final List<int> splits;
  final List<LegendFlexItem> items;

  DynamicFlexItem({
    required this.splits,
    required this.items,
  });
  LegendFlexItem getItem(double w) {
    for (var i = 0; i < splits.length; i++) {
      int split = splits[i];
      int p_split = 0;

      if (i > 0) splits[i - 1];

      if (w < split) {
        if (w > p_split) {
          return items[i];
        }
      }
    }
    return items.first;
  }
}

class LegendFlexItem {
  final List<LegendFlexItem>? children;
  final List<int>? childrenIndex;
  final List<int>? childrenFlex;
  final int? flex;
  final double? spacing;
  late final LegendFlexLayoutType type;

  bool get hasChildren => children != null;

  LegendFlexItem({
    this.children,
    required this.type,
    this.childrenIndex,
    this.childrenFlex,
    this.flex,
    this.spacing,
  });

  factory LegendFlexItem.column({
    List<LegendFlexItem>? children,
    List<int>? childrenIndex,
    List<int>? childrenFlex,
    int? flex,
    double? spacing,
  }) {
    return LegendFlexItem(
      children: children,
      childrenIndex: childrenIndex,
      type: LegendFlexLayoutType.COLUMN,
      childrenFlex: childrenFlex,
      flex: flex,
      spacing: spacing,
    );
  }

  factory LegendFlexItem.row({
    List<LegendFlexItem>? children,
    List<int>? childrenIndex,
    List<int>? childrenFlex,
    int? flex,
    double? spacing,
  }) {
    return LegendFlexItem(
      children: children,
      childrenIndex: childrenIndex,
      type: LegendFlexLayoutType.ROW,
      childrenFlex: childrenFlex,
      flex: flex,
      spacing: spacing,
    );
  }
}
