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
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     onPressed();
          //     // Navigator.pop(context);
          //   },
          //   child: const Text('확인'),
          // ),
        ],
      );
    },
    barrierDismissible: false,
  );
}
