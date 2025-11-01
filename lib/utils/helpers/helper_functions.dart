import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';

class HelperFunctions {
  HelperFunctions._();

  // Loading Widget...
  static Center showLoadingWidget({String? loadingText}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          Visibility(
            visible: loadingText != null,
            child: Column(
              children: [
                const SizedBox(height: AppSizes.spaceBetweenItems),
                Text(loadingText!, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Error Widget...
  static Center showErrorWidget({required String error}) {
    return Center(child: Text(error, style: const TextStyle(fontSize: 18.0)));
  }

  // Leading Avatar Widget...
  static CircleAvatar showAvatarWidget() {
    return const CircleAvatar(child: Icon(Icons.person_outline));
  }
}
