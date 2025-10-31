import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

class BottomNavigationWidget extends StatefulWidget {
  final TextEditingController message;
  final VoidCallback onSendButtonPressed;

  final void Function(String text) onMessageEntered;

  const BottomNavigationWidget({
    super.key,
    required this.message,
    required this.onSendButtonPressed,
    required this.onMessageEntered,
  });

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late final ValueNotifier<bool> _textFieldHasData;

  @override
  void initState() {
    super.initState();
    _textFieldHasData = ValueNotifier(false);
    widget.message.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.message.removeListener(_onTextChanged);
    _textFieldHasData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardInsets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        constraints: BoxConstraints(maxHeight: 200.0 + keyboardInsets),
        padding: EdgeInsets.only(
          top: AppSizes.bottomNavWidgetVertical,
          left: AppSizes.bottomNavWidgetHorizontal,
          right: AppSizes.bottomNavWidgetHorizontal,
          bottom: AppSizes.bottomNavWidgetVertical + keyboardInsets,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Chat Box...
            Expanded(
              child: TextFormField(
                controller: widget.message,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hint: Text(AppTextStrings.messageFieldHint),
                  prefixIcon: Icon(Icons.chat_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(width: AppSizes.spaceBetweenAppBarItems),

            ValueListenableBuilder(
              valueListenable: _textFieldHasData,
              builder: (context, textFieldHasData, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: IconButton(
                    onPressed: textFieldHasData
                        ? () {
                            final message = widget.message.text.trim();

                            widget.onMessageEntered(message);

                            widget.onSendButtonPressed();
                          }
                        : null,
                    icon: const Icon(Icons.send_outlined),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onTextChanged() {
    _textFieldHasData.value = widget.message.text.trim().isNotEmpty;
  }
}
