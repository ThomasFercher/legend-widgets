import 'package:flutter/material.dart';
import 'package:legend_utils/extensions/extensions.dart';

class LegendInputDecoration extends InputDecoration {
  final Widget? icon;

  final String? labelText;

  final TextStyle? labelStyle;

  final String? helperText;

  final TextStyle? helperStyle;

  final int? helperMaxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final TextDirection? hintTextDirection;

  final int? hintMaxLines;

  final String? errorText;

  final TextStyle? errorStyle;

  final int? errorMaxLines;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final bool? isDense;

  final EdgeInsetsGeometry? contentPadding;

  final bool isCollapsed;

  final Widget? prefixIcon;

  final BoxConstraints? prefixIconConstraints;

  final Widget? prefix;

  final String? prefixText;

  final TextStyle? prefixStyle;

  final Widget? suffixIcon;

  final Widget? suffix;

  final String? suffixText;

  final TextStyle? suffixStyle;

  final BoxConstraints? suffixIconConstraints;

  final String? counterText;

  final Widget? counter;

  final TextStyle? counterStyle;

  final bool? filled;

  final Color? fillColor;

  final Color? focusColor;

  final Color? hoverColor;

  final InputBorder? focusedBorder;

  final InputBorder? focusedErrorBorder;

  final InputBorder? errorBorder;

  final InputBorder? disabledBorder;

  final InputBorder? enabledBorder;

  final InputBorder? border;

  final bool enabled;

  final String? semanticCounterText;

  final bool? alignLabelWithHint;

  final Color? cursorColor;

  final Color? textColor;

  LegendInputDecoration({
    this.icon,
    this.labelText,
    this.labelStyle,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.hintText,
    this.hintStyle,
    this.hintTextDirection,
    this.hintMaxLines,
    this.errorText,
    this.errorStyle,
    this.errorBorder,
    this.errorMaxLines,
    this.floatingLabelBehavior,
    this.isDense,
    this.contentPadding,
    this.isCollapsed = false,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefix,
    this.prefixText,
    this.prefixStyle,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconConstraints,
    this.counterText,
    this.counter,
    this.counterStyle,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border,
    this.enabled = true,
    this.semanticCounterText,
    this.alignLabelWithHint,
    this.cursorColor,
    this.textColor,
  }) : super(
          alignLabelWithHint: alignLabelWithHint,
          border: border,
          contentPadding: contentPadding,
          counter: counter,
          counterStyle: counterStyle,
          counterText: counterText,
          disabledBorder: disabledBorder,
          enabled: enabled,
          enabledBorder: enabledBorder,
          errorBorder: errorBorder,
          errorMaxLines: errorMaxLines,
          errorStyle: errorStyle,
          errorText: errorText,
          fillColor: fillColor,
          filled: filled,
          floatingLabelBehavior: floatingLabelBehavior,
          focusColor: focusColor,
          focusedBorder: focusedBorder,
          focusedErrorBorder: focusedErrorBorder,
          helperMaxLines: helperMaxLines,
          helperStyle: helperStyle,
          helperText: helperText,
          hintMaxLines: hintMaxLines,
          hintStyle: hintStyle,
          hintText: hintText,
          hintTextDirection: hintTextDirection,
          hoverColor: hoverColor,
          icon: icon,
          isCollapsed: isCollapsed,
          isDense: isDense,
          labelStyle: labelStyle,
          labelText: labelText,
          prefix: prefix,
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixIconConstraints,
          prefixStyle: prefixStyle,
          prefixText: prefixText,
          semanticCounterText: semanticCounterText,
          suffix: suffix,
          suffixIcon: suffixIcon,
          suffixIconConstraints: suffixIconConstraints,
          suffixStyle: suffixStyle,
          suffixText: suffixText,
        );

  factory LegendInputDecoration.rounded({
    String? error,
    String? hint,
    Widget? leading,
    Widget? trailling,
    BorderRadius? radius,
    Color? borderColor,
    Color? textColor,
    Color? focusColor,
    Color? errorColor,
    Color? backgroundColor,
    double? borderWidth,
  }) {
    if (borderColor == null) borderColor = Colors.grey;
    if (textColor == null) textColor = Colors.grey;

    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: radius ?? BorderRadius.all(Radius.circular(8)),
    );

    return LegendInputDecoration(
      filled: true,
      fillColor: backgroundColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusColor ?? Colors.blueAccent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      isCollapsed: false,
      enabled: true,
      border: border,
      errorBorder: border.copyWith(
        borderSide: BorderSide(
          color: errorColor ?? Colors.redAccent,
          width: borderWidth ?? 1.2,
        ),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(
          color: errorColor ?? Colors.redAccent.darken(0.2),
          width: borderWidth ?? 1.2,
        ),
      ),
      errorText: error,
      focusColor: focusColor,
      cursorColor: textColor.withOpacity(1).lighten(),
      textColor: textColor,
      hintText: hint,
      prefixIcon: leading != null
          ? Padding(
              padding: EdgeInsets.only(left: 6, right: 12),
              child: leading,
            )
          : null,
      suffixIcon: trailling != null
          ? Padding(
              padding: EdgeInsets.only(left: 12, right: 6),
              child: trailling,
            )
          : null,
    );
  }
}
