import 'package:flutter/material.dart';

class CustomInfoButton extends StatelessWidget {
  const CustomInfoButton({
    super.key,
    required this.buttonText,
    required this.parentContext,
    required this.route,
    required this.icon,
    this.routeCode,
  });

  final String buttonText;
  final BuildContext parentContext;

  final dynamic route;
  final IconData icon;
  final bool? routeCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (details) {},
      onTap: () {
        Navigator.pushNamed(
          parentContext,
          route,
          arguments: routeCode,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 2,
            ),
          ),
        ),
        height: 85,
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
                  width: 25,
                ),
                Text(buttonText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
