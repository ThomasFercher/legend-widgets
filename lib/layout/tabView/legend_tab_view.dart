import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_widgets/datadisplay/tag/legendTag.dart';
import 'package:legend_design_widgets/layout/tabView/tab_item.dart';

class LegendTabBar extends StatefulWidget {
  final List<TabItem> items;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;
  final LegendAnimatedTagTheme theme;
  final EdgeInsetsGeometry? margin;
  final double spacing;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final void Function(int index)? onChanged;

  LegendTabBar({
    Key? key,
    required this.theme,
    required this.items,
    this.onChanged,
    this.margin,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.spacing = 8,
    this.alignment = MainAxisAlignment.spaceEvenly,
  }) : super(key: key);

  @override
  State<LegendTabBar> createState() => _LegendTabBarState();
}

class _LegendTabBarState extends State<LegendTabBar> {
  late int sel;
  late double currentWidth;

  @override
  void initState() {
    sel = 0;
    currentWidth = 0;
    super.initState();
  }

  List<Widget> getTabs(double maxWidth) {
    List<Widget> tabs = [];
    currentWidth = 0;
    for (var i = 0; i < widget.items.length; i++) {
      TabItem item = widget.items[i];
      tabs.add(
        LegendAnimatedTag(
          backgroundColor: item.background,
          foregroundColor: item.foreground,
          theme: widget.theme,
          icon: item.icon,
          text: item.title,
          selected: i == sel,
          onTap: () {
            onTap(i);
          },
        ),
      );
      Widget w = tabs[i];
      if (w is LegendAnimatedTag) {
        LegendAnimatedTag tag = w;
        currentWidth += tag.getWidth(context);
      }
    }
    for (var i = 1; i <= widget.items.length; i += 2) {
      tabs.insert(
        i,
        Expanded(
          child: Container(),
        ),
      );
    }
    currentWidth += 24 + 4;
    currentWidth += widget.margin?.horizontal ?? 0;
    currentWidth += widget.padding?.horizontal ?? 0;
    print("Current Width  $currentWidth");
    return tabs;
  }

  void onTap(int i) {
    setState(() {
      sel = i;
    });
    if (widget.onChanged != null) widget.onChanged!(i);
  }

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);

    bool overflow = false;
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      print("MaxWidth $width");

      overflow = currentWidth > width;
      print(overflow);
      return Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
          child: SizedBox(
            height: widget.theme.height,
            child: overflow ? listview() : rowView(width),
          ),
        ),
      );
    });
  }

  Widget rowView(double width) {
    return Row(
      children: getTabs(width),
    );
  }

  Widget listview() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.items.length,
      itemBuilder: (context, i) {
        TabItem item = widget.items[i];
        return Padding(
          padding: EdgeInsets.only(
            left: i != 0 ? widget.spacing : 0,
          ),
          child: LegendAnimatedTag(
            backgroundColor: item.background,
            foregroundColor: item.foreground,
            theme: widget.theme,
            icon: item.icon,
            text: item.title,
            selected: i == sel,
            onTap: () {
              onTap(i);
            },
          ),
        );
      },
    );
  }
}
