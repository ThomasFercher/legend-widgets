import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_design_widgets/legendButton/legendButton.dart';
import 'package:legend_utils/legend_utils.dart';
import 'package:provider/provider.dart';

class LegendAlert extends StatelessWidget {
  String? message;
  String? buttonMessage;
  Widget? icon;
  IconData? iconData;
  Function? onConfirm;
  LegendButtonStyle? buttonStyle;

  LegendAlert({
    this.message,
    this.buttonMessage,
    this.icon,
    this.iconData,
    this.onConfirm,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = Provider.of<LegendTheme>(context);
    double height = 140.0;

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: theme.sizing.radius1.asRadius(),
            ),
            child: Container(
              height: height,
              width: height * 18 / 9,
              padding: EdgeInsets.all(
                theme.sizing.radius1 / 2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: icon ?? Icon(iconData),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: LegendText(
                          message ?? "No Message",
                          textStyle: theme.typography.h5,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LegendButton(
                      text: LegendText(
                        buttonMessage ?? "OK",
                        textStyle: theme.typography.h5,
                      ),
                      onPressed: () {
                        onConfirm?.call();
                        Navigator.of(context).pop();
                      },
                      style: buttonStyle ?? LegendButtonStyle.normal(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget flareIcon(String flarePath) {
    return /*RiveAnimation.asset(
      flarePath,
      fit: BoxFit.fitWidth,
    );*/
        Container();
  }

  Widget normalIcon() {
    return Container(
      child: Column(
        children: [
          Icon(
            this.iconData,
          ),
          LegendText(message ?? "No message provided!")
        ],
      ),
    );
  }
}
