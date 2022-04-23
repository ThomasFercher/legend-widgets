import '../dynamic_flex_layout.dart';
import 'legendCustomFormLayout.dart';

class LegendDynamicFormLayout {
  final LegendCustomFormLayout layout;
  final DynamicFlexLayout dynamicLayout;
  final List<double> heights;

  final bool animated;

  LegendDynamicFormLayout({
    required this.layout,
    required this.dynamicLayout,
    required this.heights,
    this.animated = false,
  });
}
