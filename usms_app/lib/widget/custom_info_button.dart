import 'package:flutter/material.dart';

class CustomInfoButton extends StatelessWidget {
  const CustomInfoButton({
    super.key,
    required this.buttonText,
    required this.parentContext,
    required this.route,
    required this.icon,
  });
  // ignore: prefer_typing_uninitialized_variables
  final buttonText;
  final BuildContext parentContext;
  // ignore: prefer_typing_uninitialized_variables
  final route;
  final icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print('hi');
        print('$route');
        // Navigator.pushNamed(parentContext, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('$buttonText'),
              ],
            ),
            // Icon(
            //   Icons.arrow_forward_ios_rounded,
            //   color: Colors.grey.shade400,
            // ),
          ],
        ),
      ),
    );
  }
}
