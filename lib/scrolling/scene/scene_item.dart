import 'package:flutter/material.dart';

class SceneItem {
  final Offset start;
  final Offset end;
  final Widget child;

  SceneItem(
    this.start,
    this.end,
    this.child,
  );
}
