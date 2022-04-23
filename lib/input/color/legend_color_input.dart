import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legend_design_core/styles/colors/legend_colors.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:provider/provider.dart';

import '../text/legendInputDecoration.dart';
import '../text/legendTextField.dart';

class LegendColorInput extends StatefulWidget {
  const LegendColorInput({
    Key? key,
    required this.s,
    required this.onChanged,
  }) : super(key: key);
  final FormFieldState<Color> s;
  final Function(Color) onChanged;

  @override
  _LegendColorInputState createState() => _LegendColorInputState();
}

class _LegendColorInputState extends State<LegendColorInput> {
  late Color value;
  late String hexString;
  late int r, g, b, a;

  late TextEditingController r_c, g_c, b_c, a_c, hex_c;

  @override
  void initState() {
    value = Colors.white;

    r = value.red;
    g = value.green;
    b = value.blue;
    a = value.alpha;
    r_c = TextEditingController(text: formatInt(r));
    g_c = TextEditingController(text: formatInt(g));
    b_c = TextEditingController(text: formatInt(b));
    a_c = TextEditingController(text: formatInt(a));

    hexString = colorToHex(value);
    hex_c = TextEditingController(text: "$hexString");
    super.initState();
  }

  String formatInt(int n) {
    return "$n";
  }

  void updateRGB() {
    r_c.text = formatInt(r);
    g_c.text = formatInt(g);
    b_c.text = formatInt(b);
    a_c.text = formatInt(a);
    Color c = Color.fromARGB(a, r, g, b);
    setState(() {
      value = c;
    });

    widget.onChanged(c);
  }

  String colorToHex(Color color) {
    String hex = color.toString();
    hex = hex.substring(6, hex.length - 1).replaceAll("0x", "#").toUpperCase();
    return hex;
  }

  void updateHex() {
    Color c = Color.fromARGB(a, r, g, b);
    String s = c.toString();
    s = s.substring(6, s.length - 1).replaceAll("0x", "#").toUpperCase();
    hex_c.text = s;

    setState(() {
      value = c;
    });

    widget.onChanged(c);
  }

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = context.watch<LegendTheme>();
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: width < 480 ? 120 : 52,
      child: Column(
        children: [
          if (width < 480)
            Container(
              height: 32,
              width: width,
              margin: EdgeInsets.only(
                bottom: 4,
              ),
              decoration: BoxDecoration(
                color: value,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                border: Border.all(
                  color: Colors.white60,
                  width: 1,
                ),
              ),
            ),
          Row(
            children: [
              if (width > 480)
                Expanded(
                  child: Container(
                    height: 48,
                    width: 64,
                    decoration: BoxDecoration(
                      color: value,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      border: Border.all(
                        color: Colors.white60,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              if (width > 480)
                const SizedBox(
                  width: 24,
                ),
              SizedBox(
                width: 116,
                child: LegendTextField(
                  ctrl: hex_c,
                  textAlign: TextAlign.center,
                  formatter: [
                    FilteringTextInputFormatter(
                      RegExp(
                        r'^[0-9a-fA-F#]{1,9}$',
                      ),
                      allow: true,
                      replacementString: hexString,
                    ),
                  ],
                  decoration: LegendInputDecoration.rounded(
                    focusColor: theme.colors.selection,
                  ),
                  onChanged: (string) {
                    String colorstring = string;
                    setState(() {
                      hexString = colorstring;
                    });
                    Color c = value;

                    if (colorstring.startsWith('#')) {
                      colorstring = colorstring.substring(1);
                    }

                    if (colorstring.length >= 6 && colorstring.length <= 8) {
                      final buffer = StringBuffer();
                      if (colorstring.length == 6) {
                        buffer.write("ff");
                      }

                      buffer.write(colorstring);

                      c = Color(int.parse(buffer.toString(), radix: 16));

                      setState(() {
                        r = c.red;
                        g = c.green;
                        b = c.blue;
                        a = c.alpha;
                        value = c;
                        hexString = string;
                      });
                      updateRGB();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              SizedBox(
                width: 190,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        transform: Matrix4.translationValues(2, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(24)),
                          color: theme.colors.selection,
                        ),
                        padding: EdgeInsets.only(
                          left: 1,
                          top: 2,
                          bottom: 2,
                        ),
                        child: Container(
                          transform: Matrix4.translationValues(1, 0, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(22)),
                            color: LegendColors.gray8,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            left: 24,
                          ),
                          child: SizedBox(
                            width: 24,
                            child: LegendTextField(
                              textAlign: TextAlign.center,
                              formatter: [
                                FilteringTextInputFormatter(
                                  RegExp(
                                    r'^([01]?[0-9][0-9]?|2[0-4][0-9]|25[0-5])$',
                                  ),
                                  allow: true,
                                  replacementString: "$r",
                                ),
                              ],
                              decoration: LegendInputDecoration(
                                border: InputBorder.none,
                              ),
                              ctrl: r_c,
                              onChanged: (string) {
                                if (string.isNotEmpty) {
                                  setState(() {
                                    r = int.parse(string);
                                    value = Color.fromARGB(a, r, g, b);
                                  });
                                  updateHex();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        transform: Matrix4.translationValues(1, 0, 0),
                        decoration: BoxDecoration(
                          color: LegendColors.gray8,
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: theme.colors.selection,
                            ),
                            bottom: BorderSide(
                              width: 2,
                              color: theme.colors.selection,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 8,
                          ),
                          width: 24,
                          child: LegendTextField(
                            textAlign: TextAlign.center,
                            formatter: [
                              FilteringTextInputFormatter(
                                RegExp(
                                  r'^([01]?[0-9][0-9]?|2[0-4][0-9]|25[0-5])$',
                                ),
                                allow: true,
                                replacementString: "$g",
                              ),
                            ],
                            decoration: LegendInputDecoration(
                              border: InputBorder.none,
                            ),
                            ctrl: g_c,
                            onChanged: (string) {
                              if (string.isNotEmpty) {
                                setState(() {
                                  g = int.parse(string);
                                  value = Color.fromARGB(a, r, g, b);
                                });
                                updateHex();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        transform: Matrix4.translationValues(-1, 0, 0),
                        decoration: BoxDecoration(
                          color: LegendColors.gray8,
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: theme.colors.selection,
                            ),
                            bottom: BorderSide(
                              width: 2,
                              color: theme.colors.selection,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 24,
                          margin: EdgeInsets.only(
                            right: 8,
                          ),
                          child: LegendTextField(
                            textAlign: TextAlign.center,
                            formatter: [
                              FilteringTextInputFormatter(
                                RegExp(
                                  r'^([01]?[0-9][0-9]?|2[0-4][0-9]|25[0-5])$',
                                ),
                                allow: true,
                                replacementString: "$b",
                              ),
                            ],
                            decoration: LegendInputDecoration(
                              border: InputBorder.none,
                            ),
                            ctrl: b_c,
                            onChanged: (string) {
                              if (string.isNotEmpty) {
                                setState(() {
                                  b = int.parse(string);
                                  value = Color.fromARGB(a, r, g, b);
                                });
                                updateHex();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        transform: Matrix4.translationValues(-2, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(24),
                          ),
                          color: theme.colors.selection,
                        ),
                        padding: EdgeInsets.only(
                          right: 1,
                          top: 2,
                          bottom: 2,
                        ),
                        child: Container(
                          transform: Matrix4.translationValues(-1, 0, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(22)),
                            color: LegendColors.gray8,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            right: 24,
                          ),
                          child: SizedBox(
                            width: 24,
                            child: LegendTextField(
                              textAlign: TextAlign.center,
                              formatter: [
                                FilteringTextInputFormatter(
                                  RegExp(
                                    r'^([01]?[0-9][0-9]?|2[0-4][0-9]|25[0-5])$',
                                  ),
                                  allow: true,
                                  replacementString: "$a",
                                ),
                              ],
                              decoration: LegendInputDecoration(
                                border: InputBorder.none,
                              ),
                              ctrl: a_c,
                              onChanged: (string) {
                                if (string.isNotEmpty) {
                                  setState(() {
                                    a = int.parse(string);
                                    value = Color.fromARGB(a, r, g, b);
                                  });
                                  updateHex();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
