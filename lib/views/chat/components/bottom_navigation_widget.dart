import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';

class BottomNavigationWidget extends StatefulWidget {
  final VoidCallback onSendButtonPressed;

  const BottomNavigationWidget({super.key, required this.onSendButtonPressed});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late final TextEditingController _message;

  late final ValueNotifier<bool> _textFieldHasData;

  @override
  void initState() {
    super.initState();
    _message = TextEditingController();
    _textFieldHasData = ValueNotifier(false);
    _message.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _message.removeListener(_onTextChanged);
    _message.dispose();
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
                controller: _message,
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
                        ? widget.onSendButtonPressed
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
    _textFieldHasData.value = _message.text.trim().isNotEmpty;
  }
}
