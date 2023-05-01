import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:legend_design_widgets/scrolling/effects/visiblity_renderbox.dart';

typedef VisibilityBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  double visible,
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

enum VisibilityType {
  ONCE,
  IN,
  IN_OUT,
}

class SliverVis extends StatefulWidget {
  final VisibilityBuilder builder;
  final Widget? child;
  final Duration duration;
  final Curve curve;
  final VisibilityType type;
  final bool binary;
  final double binaryThreshold;

  const SliverVis({
    super.key,
    required this.builder,
    this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.type = VisibilityType.ONCE,
    this.binary = true,
    this.binaryThreshold = 1.0,
  });

  @override
  State<SliverVis> createState() => _SliverVisState();
}

class _SliverVisState extends State<SliverVis> {
  late double _visible;
  late bool _wasFullSize;

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
    _visible = 1.0;
    _wasFullSize = false;
  }

  void rebuild() => _scheduleRebuild(() => setState(() {}));

  @override
  Widget build(BuildContext context) {
    return VisibilitySliver(
      onVisibilityChanged: (visible) {
        if (visible == _visible) return;
        final diff = visible - _visible;
        _visible = visible;

        switch (widget.type) {
          case VisibilityType.ONCE:
            if (_wasFullSize) break;
            if (widget.binary) {
              if (_visible >= widget.binaryThreshold && !_wasFullSize) {
                _wasFullSize = true;
                _visible = 1.0;
                rebuild();
                return;
              }
            } else if (!_wasFullSize) {
              if (_visible >= widget.binaryThreshold) {
                _wasFullSize = true;
                _visible = 1.0;
              }

              rebuild();
              return;
            }
            return;
          case VisibilityType.IN:
            if (widget.binary) {
              if (_visible >= widget.binaryThreshold && !_wasFullSize) {
                _wasFullSize = true;
                _visible = 1.0;
                rebuild();
              }
              if (diff < 0 && _wasFullSize) _wasFullSize = false;
              if (_visible == 0.0) rebuild();
              return;
            }
            if (diff > 0) rebuild();
            return;
          case VisibilityType.IN_OUT:
            if (widget.binary) {
              if (widget.binary && _visible >= widget.binaryThreshold) {
                _wasFullSize = true;
                rebuild();
              }
              if (_wasFullSize && diff < 0) {
                _wasFullSize = false;
                _visible = 0.0;
                rebuild();
              }
              return;
            }
            rebuild();
            return;
        }
        return;
      },
      child: widget.builder(
        context,
        widget.child,
        _visible,
      ),
    );
  }
}
