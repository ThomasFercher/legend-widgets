import 'package:flutter/material.dart';

/*class CheckboxWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;
  final Widget title;
  final Widget subtitle;
  final Widget? child;
  final VoidCallback? onTap;

  const CheckboxWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.title,
    this.subtitle,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              size: 20,
              color: value ? checkColor : Colors.transparent,
            ),
            SizedBox(width: 8),
            if (child != null) child,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) title,
                if (subtitle != null) subtitle,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/