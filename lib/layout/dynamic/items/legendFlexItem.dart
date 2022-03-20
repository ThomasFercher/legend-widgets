abstract class ChildrenFlexItem {
  final num value;

  ChildrenFlexItem(this.value);
}

class ChildrenFlexValue extends ChildrenFlexItem {
  ChildrenFlexValue(int value) : super(value);
}

class ChildrenFlexWidth extends ChildrenFlexItem {
  ChildrenFlexWidth(double value) : super(value);
}