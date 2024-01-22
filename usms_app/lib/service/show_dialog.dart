import 'package:flutter/material.dart';

void customShowDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Function onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onPressed();
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}
