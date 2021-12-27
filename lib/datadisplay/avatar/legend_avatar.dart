import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:legend_design_core/styles/theming/theme_provider.dart';

class LegendAvatar extends StatelessWidget {
  const LegendAvatar({
    Key? key,
    required this.child,
    this.margin,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.borderRadius,
    this.isCard = true,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool isCard;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 12),
        ),
        boxShadow: [
          if (isCard)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
            )
        ],
      ),
      child: ClipRRect(
        child: GestureDetector(
          onTap: () {
            if (onTap != null) onTap!();
          },
          child: Container(
            alignment: Alignment.center,
            child: Container(
              child: child,
            ),
            height: height,
            width: width,
            color: backgroundColor ?? Colors.teal,
          ),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 12),
        ),
      ),
    );
  }
}
