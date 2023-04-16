import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' show pi;

import 'package:legend_design_widgets/input/button/legendButton/legend_button.dart';

const _kExpand = Icons.arrow_forward_ios_rounded;
const _kDuration = Duration(milliseconds: 300);
const _kCurve = Curves.easeInOut;

class LegendExpandable extends StatefulHookWidget {
  final Widget title;
  final List<Widget> children;
  final double iconSize;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry childrenPadding;

  LegendExpandable({
    super.key,
    this.iconSize = 24.0,
    required this.title,
    required this.children,
    this.titlePadding =
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
    this.childrenPadding = const EdgeInsets.symmetric(vertical: 4.0),
  });

  @override
  State<LegendExpandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<LegendExpandable> {
  late bool _isExpanded;
  final Key key = UniqueKey();

  @override
  void initState() {
    _isExpanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: _kDuration,
    );
    final turns = Tween(begin: pi / 2, end: 1.5 * pi)
        .animate(CurvedAnimation(parent: controller, curve: _kCurve));
    final heightFactors = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: _kCurve));

    final hideChildren = _isExpanded && controller.isDismissed;

    void onTap() {
      if (_isExpanded) {
        setState(() {
          _isExpanded = false;
        });
        controller.reverse();
        return;
      }
      setState(() {
        _isExpanded = true;
      });
      controller.forward();
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: widget.titlePadding,
                child: Row(
                  children: [
                    Expanded(child: widget.title),
                    LegendButton(
                      text: Transform.rotate(
                        angle: turns.value,
                        child: Icon(
                          _kExpand,
                          size: widget.iconSize,
                        ),
                      ),
                      onTap: onTap,
                      background: Colors.transparent,
                      borderRadius: BorderRadius.circular(1E9),
                      padding: EdgeInsets.all(4),
                    ),
                  ],
                ),
              ),
            ),
            ClipRect(
              child: Align(
                heightFactor: heightFactors.value,
                alignment: Alignment.center,
                child: Offstage(
                  offstage: hideChildren,
                  child: Padding(
                    padding: widget.childrenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.children,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
