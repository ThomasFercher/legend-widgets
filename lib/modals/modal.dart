import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_utils/extensions/edge_insets.dart';
import 'package:legend_utils/extensions/extensions.dart';

import '../input/button/legendButton/legendButton.dart';

class Modal extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget content;
  final Function onConfirm;
  final Function onCancle;

  const Modal({
    Key? key,
    this.height,
    this.width,
    required this.content,
    required this.onConfirm,
    required this.onCancle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);
    double maxWidth = MediaQuery.of(context).size.width;
    double padding = 0;

    if (width != null) {
      if (maxWidth - 24 <= width!) {
        padding = 24;
      }
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Material(
              borderRadius: theme.sizing.radius1.asRadius(),
              color: Colors.white,
              child: Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Container(
                      padding: theme.sizing.radius2.asPaddingAllBut(
                        theme.sizing.radius1,
                        left: true,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Title"),
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
                    Divider(
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: content,
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    Container(
                      padding: theme.sizing.radius2.asPaddingAllBut(
                        theme.sizing.radius1,
                        left: true,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LegendButton(
                            onPressed: () {
                              onCancle();
                              Navigator.pop(context);
                            },
                            text: LegendText("Cancel"),
                            style: LegendButtonStyle.danger(),
                          ),
                          LegendButton(
                            onPressed: () {
                              onConfirm();
                            },
                            text: LegendText("Confirm"),
                            style: LegendButtonStyle.normal(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
