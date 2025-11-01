import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' as foundation;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class CustomEmojiPicker extends StatefulWidget {
  final TextEditingController controller;

  const CustomEmojiPicker({super.key, required this.controller});

  @override
  State<CustomEmojiPicker> createState() => _CustomEmojiPickerState();
}

class _CustomEmojiPickerState extends State<CustomEmojiPicker> {
  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      textEditingController: widget.controller,
      onBackspacePressed: () {},
      config: Config(
        height: 256,
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          emojiSizeMax:
              28 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.20
                  : 1.0),
        ),
        viewOrderConfig: const ViewOrderConfig(
          top: EmojiPickerItem.searchBar,
          middle: EmojiPickerItem.emojiView,
          bottom: EmojiPickerItem.categoryBar,
        ),
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig: const CategoryViewConfig(),
        bottomActionBarConfig: const BottomActionBarConfig(),
        searchViewConfig: const SearchViewConfig(),
      ),
    );
  }
}
