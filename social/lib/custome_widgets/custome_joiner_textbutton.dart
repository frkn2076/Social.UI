import 'package:flutter/material.dart';

class CustomeJoinerTextButton extends StatelessWidget {
  final bool isPrivate;
  final String userName;
  final GestureTapCallback onTap;
  const CustomeJoinerTextButton(
      {Key? key,
      required this.isPrivate,
      required this.userName,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(1),
        child: Text(
          userName,
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: isPrivate ? Colors.red : Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
      ),
    );
  }
}
