import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:legend_design_core/icons/legend_animated_icon.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';
import 'package:legend_design_widgets/datadisplay/searchableList.dart/legend_searchable.dart';
import 'package:provider/src/provider.dart';

const IconData ascending = Icons.arrow_upward;
const IconData descending = Icons.arrow_downward;
const IconData none = Icons.arrow_forward;

class LegendSortIcon extends StatefulWidget {
  const LegendSortIcon({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  final void Function(SortStatus status) onClicked;

  @override
  State<LegendSortIcon> createState() => _LegendSortIconState();
}

class _LegendSortIconState extends State<LegendSortIcon> {
  late SortStatus status;

  @override
  void initState() {
    status = SortStatus.None;
    super.initState();
  }

  IconData getIcon() {
    switch (status) {
      case SortStatus.Ascending:
        return ascending;
      case SortStatus.Descending:
        return descending;
      case SortStatus.None:
        return none;
    }
  }

  void setStatus() {
    setState(() {
      switch (status) {
        case SortStatus.Ascending:
          status = SortStatus.Descending;
          break;
        case SortStatus.Descending:
          status = SortStatus.None;
          break;
        case SortStatus.None:
          status = SortStatus.Ascending;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = context.watch<ThemeProvider>();

    return LegendAnimatedIcon(
      icon: getIcon(),
      theme: LegendAnimtedIconTheme(
        enabled: theme.colors.selectionColor,
        disabled: theme.colors.disabledColor,
      ),
      disableShadow: true,
      iconSize: 20,
      onPressed: () {
        setStatus();

        widget.onClicked(status);
      },
    );
  }
}
