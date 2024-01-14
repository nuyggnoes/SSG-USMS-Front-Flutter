import 'package:flutter/material.dart';
import 'package:usms_app/screen/login_screen.dart';

class CustomDialog {
  static void showPopDialog(
    BuildContext context,
    String title,
    String message,
    String? route,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // onPressedCallback(context, code);
                if (route != null) {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Login()),
                  //   (route) => false,
                  // );
                  Navigator.pushNamed(context, '/');
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
