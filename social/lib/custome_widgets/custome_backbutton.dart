import 'package:flutter/material.dart';

class CustomeBackButton extends StatelessWidget {
  const CustomeBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
