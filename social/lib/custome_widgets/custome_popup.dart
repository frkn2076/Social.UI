import 'package:flutter/material.dart';

class CustomePopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonName;
  final VoidCallback onPressed;
  const CustomePopup(
      {Key? key,
      required this.title,
      required this.message,
      required this.buttonName,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(message)],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: onPressed, child: Text(buttonName)),
      ],
    );
  }
}
