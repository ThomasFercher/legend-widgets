import 'package:flutter/material.dart';
import 'package:legend_design/components/actioncard/actionCard.dart';
import 'package:legend_design/legend_design.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LegendTheme actionCardTheme = LegendTheme(
      backgroundColor: Colors.deepOrange[200],
      elevation: 2,
      iconColor: Colors.deepOrange,
      borderRadius: 10,
      textSize: 24,
      iconSize: 32,
    );
    return MaterialApp(
      title: 'Legend Design Example APp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Example App"),
        ),
        body: Column(
          children: [
            Container(
              child: ActionCard(
                icon: Icons.transgender,
                theme: actionCardTheme,
                layoutInfo: LayoutInfo(expandHorizontally: true),
                text: "Test",
                onPressed: () => {},
              ),
            ),
            Container(
              height: 400,
              child: Row(
                children: [
                  ActionCard(
                    icon: Icons.transgender,
                    theme: actionCardTheme,
                    layoutInfo: LayoutInfo(expandVertically: false),
                    text: "Test",
                    onPressed: () => {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
