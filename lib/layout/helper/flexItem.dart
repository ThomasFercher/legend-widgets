import 'package:flutter/widgets.dart';

class FlexFiller extends StatelessWidget {
  final int flex;

  const FlexFiller({Key? key, this.flex = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(),
    );
  }
}
