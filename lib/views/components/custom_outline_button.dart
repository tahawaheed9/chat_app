import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: AppSizes.defaultConstrainedWidth,
        minHeight: AppSizes.defaultConstrainedHeight,
      ),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: isSecondary
              ? WidgetStatePropertyAll<Color>(Theme.of(context).primaryColor)
              : null,
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.defaultBorderRadius),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isSecondary ? Colors.white : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
