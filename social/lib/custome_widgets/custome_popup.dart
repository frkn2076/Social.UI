import 'package:flutter/material.dart';

class CustomePopup extends StatelessWidget {
  final String? title;
  final String? message;
  final String? buttonName;
  final VoidCallback onPressed;
  const CustomePopup(
      {Key? key,
      this.title,
      this.message,
      this.buttonName,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: message != null
          ? SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(message!)],
              ),
            )
          : null,
      actions: buttonName != null
          ? <Widget>[
              TextButton(onPressed: onPressed, child: Text(buttonName!)),
            ]
          : null,
    );
  }
}
