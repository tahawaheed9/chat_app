import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: AppSizes.spaceBetweenDividers),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.defaultConstrainedWidth,
          ),
          child: const Divider(),
        ),
        const SizedBox(height: AppSizes.spaceBetweenDividers),
      ],
    );
  }
}
