import 'package:flutter/widgets.dart';
import 'package:legend_design_widgets/scrolling/scene/scene_item.dart';

class LegendScene extends StatefulWidget {
  final List<SceneItem> children;

  LegendScene({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  State<LegendScene> createState() => _LegendSceneState();
}

class _LegendSceneState extends State<LegendScene> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        print(notification);
        return true;
      },
      child: SizedBox(
        height: 400,
        child: Stack(
          children: [
            for (SceneItem item in widget.children)
              Container(
                child: item.child,
              ),
          ],
        ),
      ),
    );
  }
}
