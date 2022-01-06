import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LegendRangeSlider extends StatefulWidget {
  final void Function(RangeValues value)? onChanged;
  final RangeValues? rangeValues;
  LegendRangeSlider({
    Key? key,
    this.onChanged,
    this.rangeValues,
  }) : super(key: key);

  @override
  _LegendRangeSliderState createState() => _LegendRangeSliderState();
}

class _LegendRangeSliderState extends State<LegendRangeSlider> {
  late final double min;
  late final double max;
  late double start;
  late double end;

  @override
  void initState() {
    super.initState();
    max = widget.rangeValues?.end ?? 100;
    min = widget.rangeValues?.start ?? 0;
    start = min;
    end = max;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: RangeSlider(
        values: RangeValues(
          start,
          end,
        ),
        max: max,
        min: min,
        divisions: (max - min).toInt(),
        labels: RangeLabels("$start", "$end"),
        onChanged: (value) {
          setState(() {
            start = value.start.truncateToDouble();
            end = value.end.truncateToDouble();
          });
          if (widget.onChanged != null)
            widget.onChanged!(
              RangeValues(start, end),
            );
        },
      ),
    );
  }
}
