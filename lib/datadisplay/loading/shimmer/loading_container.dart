import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'loading_shimmer.dart';

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingContainer({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: isLoading,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
