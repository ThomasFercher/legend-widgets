import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:legend_design/styles/styles.dart';

class ActionCard extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String text;
  final LegendTheme theme;
  final LayoutInfo layoutInfo;
  final Alignment? textAligment;
  final Alignment? iconAligment;

  final double defaultTextSize = 10;

  ActionCard({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.theme,
    this.textAligment,
    this.iconAligment,
    required this.layoutInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: theme.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(theme.borderRadius ?? 10),
        ),
      ),
      color: theme.backgroundColor,
      child: InkWell(
        enableFeedback: true,
        borderRadius: BorderRadius.circular(theme.borderRadius ?? 10),
        onTap: () => onPressed(),
        onLongPress: () => onPressed(),
        child: Padding(
          padding: EdgeInsets.all(theme.borderRadius ?? 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: layoutInfo.expandHorizontally ?? false
                    ? constraints.maxWidth
                    : 100,
                height: layoutInfo.expandVertically ?? false
                    ? constraints.maxHeight
                    : 30,
                child: Stack(
                  children: [
                    Align(
                      alignment: textAligment ?? Alignment.bottomLeft,
                      child: Container(
                        height: theme.textSize ?? defaultTextSize * 2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            text,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: theme.textSize ?? defaultTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: iconAligment ?? Alignment.topRight,
                      child: Container(
                        width: theme.iconSize,
                        height: theme.iconSize,
                        child: Icon(
                          icon,
                          size: theme.iconSize,
                          color: theme.iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
