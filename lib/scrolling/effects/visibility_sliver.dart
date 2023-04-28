import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:legend_design_widgets/scrolling/effects/visiblity_renderbox.dart';

typedef VisibilityBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  double? visible,
);

class VisibilitySliver extends SingleChildRenderObjectWidget {
  final void Function(double) onVisibilityChanged;

  const VisibilitySliver({
    required super.child,
    required this.onVisibilityChanged,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      VisibilityPercentageRenderSliver(
        onVisibilityChanged: onVisibilityChanged,
      );

  // should rebuild
}

class SliverVis extends StatefulWidget {
  final VisibilityBuilder builder;
  final Widget? child;
  final Duration duration;
  final Curve curve;

  const SliverVis({
    super.key,
    required this.builder,
    this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<SliverVis> createState() => _SliverVisState();
}

class _SliverVisState extends State<SliverVis> {
  late double? _visible;

  void _scheduleRebuild(Function callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        callback.call();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _visible = null;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilitySliver(
      onVisibilityChanged: (visible) {
        if (visible == _visible) return;
        _scheduleRebuild(() {
          setState(() {
            _visible = visible;
          });
        });
      },
      child: widget.builder(
        context,
        widget.child,
        _visible,
      ),
    );
  }
}
