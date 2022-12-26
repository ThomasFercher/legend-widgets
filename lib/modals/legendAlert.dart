import 'package:flutter/material.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/widgets/legend_text.dart';
import 'package:legend_design_widgets/input/button/legendButton/legend_button.dart';
import 'package:legend_utils/legend_utils.dart';

class LegendAlert extends StatelessWidget {
  final String? message;
  final String? buttonMessage;
  final Widget? icon;
  final IconData? iconData;
  final Function? onConfirm;

  const LegendAlert({
    this.message,
    this.buttonMessage,
    this.icon,
    this.iconData,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = LegendTheme.of(context);
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
                          style: theme.typography.h5,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LegendButton.text(
                      text: buttonMessage ?? "OK",
                      style: theme.typography.h5,
                      onTap: () {
                        onConfirm?.call();
                        Navigator.of(context).pop();
                      },
                      background: Colors.red,
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
