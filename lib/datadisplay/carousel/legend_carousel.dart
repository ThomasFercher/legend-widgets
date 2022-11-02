import 'dart:async';

import 'package:flutter/material.dart';
import 'package:legend_design_core/widgets/icons/legend_animated_icon.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_widgets/datadisplay/carousel/legend_carousel_item.dart';

const Duration duration = const Duration(milliseconds: 360);
Curve curve = Curves.easeInOutSine;

class LegendCarousel extends StatefulWidget {
  final double? height;
  final List<Widget> items;
  final Duration? animationDuration;
  final EdgeInsetsGeometry? padding;
  late bool isInfinite;
  final Duration? intervall;

  LegendCarousel({
    required this.items,
    this.height,
    this.animationDuration,
    this.padding,
    bool? isInfinite,
    this.intervall,
  }) {
    this.isInfinite = isInfinite ?? false;
  }

  @override
  _LegendCarouselState createState() => _LegendCarouselState();
}

class _LegendCarouselState extends State<LegendCarousel>
    with SingleTickerProviderStateMixin {
  late int selected;
  late PageController _pageController;
  late Timer? timer;
  late bool isAnimating;
  late double scrollStart;
  late double scrollEnd;
  bool isScrolling = false;
  int inital = 4000;

  @override
  void initState() {
    super.initState();
    scrollStart = 0.0;
    scrollEnd = 0.0;
    selected = inital;
    isAnimating = false;

    _pageController = PageController(initialPage: 4000, keepPage: true)
      ..addListener(() {
        //   print(_pageController.offset);
      });

    if (widget.intervall != null) {
      timer = new Timer.periodic(widget.intervall!, (timer) async {
        await changedSelected(1);
      });
    } else {
      timer = null;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  List<Widget> getItems(double width) {
    List<Widget> items = widget.items
        .map(
          (w) => LegendCarouselItem(
            maxWidth: width,
            item: w,
            duration: widget.animationDuration ?? Duration(milliseconds: 250),
          ),
        )
        .toList();

    return items;
  }

  List<Widget> getSelectors(LegendTheme theme) {
    List<Widget> selectors = [];
    for (int i = 0; i < widget.items.length; i++) {
      int distance = -(inital - selected);

      double div = (distance / widget.items.length);
      int full = div.floor();
      double dec = div - full;

      double number = dec * widget.items.length;

      bool sel = false;
      if (number > i - 0.1 && number < i + 0.1) {
        sel = true;
      }

      int index = inital - (full * widget.items.length) + (number).floor() + 1;

      selectors.add(
        GestureDetector(
          onTap: () async {
            if (!isAnimating) {
              isAnimating = true;
              setState(() {
                selected = index;
              });
              await _pageController.animateToPage(selected,
                  duration: duration, curve: curve);

              isAnimating = false;
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 8,
            width: 8,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: sel ? theme.colors.selection : theme.colors.disabled,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return selectors;
  }

  Future<void> changedSelected(int dir) async {
    print(isAnimating);
    if (!isAnimating) {
      int toSelect = selected + dir;
      isAnimating = true;

      setState(() {
        selected = toSelect;
      });
      await _pageController.animateToPage(selected,
          duration: duration, curve: curve);

      isAnimating = false;
    }
  }

  void _onScroll(double offset) async {
    if (isScrolling == false) {
      isScrolling = true;
      if (offset > 0) {
        await changedSelected(-1);

        isScrolling = false;
      } else {
        await changedSelected(1);
        isScrolling = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);
    double width = MediaQuery.of(context).size.width;
    List<Widget> items = getItems(width);

    return Container(
      height: widget.height,
      width: width,
      color: Colors.transparent,
      padding: widget.padding,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                scrollStart = details.globalPosition.dx;
                scrollEnd = scrollStart;
              },
              onHorizontalDragUpdate: (details) {
                scrollEnd = details.globalPosition.dx;
              },
              onHorizontalDragEnd: (details) {
                double scrollDiff = scrollEnd - scrollStart;

                _onScroll(scrollDiff);
              },
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),

                itemBuilder: (context, page) {
                  final index =
                      items.length - (4000 - page - 1) % items.length - 1;

                  selected = page;
                  return items[index];
                },

                //  pageSnapping: true,
                controller: _pageController,
                allowImplicitScrolling: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: LegendAnimatedIcon(
              icon: Icons.arrow_forward_ios,
              theme: LegendAnimtedIconTheme(
                enabled: theme.colors.selection,
                disabled: theme.colors.disabled,
              ),
              padding: EdgeInsets.all(32.0),
              onPressed: () async {
                await changedSelected(1);
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: LegendAnimatedIcon(
              icon: Icons.arrow_back_ios,
              theme: LegendAnimtedIconTheme(
                enabled: theme.colors.selection,
                disabled: theme.colors.disabled,
              ),
              padding: EdgeInsets.all(32.0),
              onPressed: () async {
                await changedSelected(-1);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getSelectors(theme),
              ),
            ),
          )
        ],
      ),
    );
  }
}
