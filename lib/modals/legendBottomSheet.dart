import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_design_core/widgets/size_info.dart';
import 'package:legend_utils/extensions/extensions.dart';

import 'package:provider/provider.dart';

import '../legendButton/legendButton.dart';

class LegendBottomSheet extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Widget content;

  LegendBottomSheet({
    Key? key,
    required this.title,
    required this.onConfirm,
    required this.onCancel,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeInfo ss = SizeInfo.of(context);
    LegendTheme theme = Provider.of<LegendTheme>(context);
    double width = theme.sizingTheme.sizeIsMax(1000) ? ss.width : ss.width / 3;

    return Container(
      alignment: Alignment.bottomCenter,
      height: 160,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: 160,
          minWidth: width,
          minHeight: 160,
        ),
        child: Card(
          color: Colors.white,
          elevation: 10.0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: theme.sizing.radius1.asRadius().copyWith(
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
          ),
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: theme.sizing.radius1 / 2,
                    bottom: theme.sizing.radius1 / 2,
                    right: theme.sizing.radius1 / 2,
                    left: theme.sizing.radius1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                      ),
                      IconButton(
                        splashRadius: 20.0,
                        onPressed: () => {
                          // Maybe Implement with RouterProvider
                          Navigator.pop(context),
                        },
                        icon: Icon(Icons.close),
                        padding: EdgeInsets.all(0),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.sizing.radius1,
                    ),
                    child: content,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: theme.sizing.radius1 / 2,
                    bottom: theme.sizing.radius1 / 2,
                    right: theme.sizing.radius1 / 2,
                    left: theme.sizing.radius1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LegendButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onCancel();
                        },
                        text: LegendText(
                          "Cancel",
                          selectable: false,
                        ),
                        style: LegendButtonStyle.danger(),
                      ),
                      LegendButton(
                        onPressed: () {
                          onConfirm();
                        },
                        text: LegendText(
                          "Confirm",
                          selectable: false,
                        ),
                        style: LegendButtonStyle.confirm(
                          color: Colors.blue,
                          activeColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
