import 'package:flutter/material.dart';

import 'legendTableCell.dart';

class LegendTableRow extends StatefulWidget {
  final List<LegendTableCell> columnsCells;
  final List<int>? flexValues;
  final Color? avtiveColor;
  final Color? backgroundColor;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  LegendTableRow({
    Key? key,
    required this.columnsCells,
    required this.height,
    this.padding,
    this.avtiveColor,
    this.backgroundColor,
    this.flexValues,
    this.borderRadius,
  }) : super(key: key);

  @override
  _LegendTableRowState createState() => _LegendTableRowState();
}

class _LegendTableRowState extends State<LegendTableRow>
    with SingleTickerProviderStateMixin {
  late Color color;
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    color = widget.backgroundColor ?? Colors.white;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    )..addListener(() {
        setState(() {
          color = _animation.value ?? Colors.white;
        });
      });

    _animation = ColorTween(
      begin: widget.backgroundColor,
      end: widget.avtiveColor,
    ).animate(_controller);
  }

  List<Widget> getColumnItems() {
    List<Widget> items = [];
    for (int i = 0; i < widget.columnsCells.length; i++) {
      int flex = widget.flexValues?[i] ?? 1;
      print(flex);
      items.add(Expanded(flex: flex, child: widget.columnsCells[i]));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: color,
          border: Border(
            bottom: BorderSide(color: Colors.black12),
          ),
        ),
        padding: widget.padding,
        child: MouseRegion(
          onEnter: (event) {
            _controller.forward();
          },
          onExit: (event) {
            _controller.reverse();
          },
          child: Row(
            children: getColumnItems(),
          ),
        ),
      ),
    );
  }
}
