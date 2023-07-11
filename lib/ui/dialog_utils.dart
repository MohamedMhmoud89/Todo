import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text(message),
              ],
            ),
          );
        },
        barrierDismissible: false);
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {String? postActionName,
      VoidCallback? postAction,
      String? negActionName,
      VoidCallback? negAction}) {
    List<Widget> actions = [];
    if (postActionName != Null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            postAction?.call();
          },
          child: Text(postActionName!)));
    }
    if (negActionName != Null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(negActionName!)));
    }
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          content: Text(message),
          actions: actions,
        );
      },
    );
  }
}