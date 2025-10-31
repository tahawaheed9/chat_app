import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.chatBubbleMargin),
      padding: const EdgeInsets.all(AppSizes.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSizes.chatBubbleBorderRadius),
          bottomLeft: Radius.circular(AppSizes.chatBubbleBorderRadius),
          bottomRight: isCurrentUser
              ? Radius.zero
              : Radius.circular(AppSizes.chatBubbleBorderRadius),
          topLeft: isCurrentUser
              ? Radius.circular(AppSizes.chatBubbleBorderRadius)
              : Radius.zero,
        ),
        color: isCurrentUser
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Text(message),
    );
  }
}
