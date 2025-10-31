import 'package:flutter/material.dart';

class HelperFunctions {
  HelperFunctions._();

  // Loading Widget...
  static Center showLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
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
