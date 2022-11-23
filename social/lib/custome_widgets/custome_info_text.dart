import 'package:flutter/material.dart';

class CustomeInfoText extends StatelessWidget {
  final String title;
  final String text;

  const CustomeInfoText({Key? key, required this.title, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: Row(
        children: [
          Text(
            '$title ',
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 14),
          )
        ],
      ),
    );
  }
}
