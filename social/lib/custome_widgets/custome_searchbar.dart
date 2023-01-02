import 'package:flutter/material.dart';
import 'package:social/utils/localization_resources.dart';

class CustomeSearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  const CustomeSearchBar({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: TextField(
        onChanged: onChanged,
        autofocus: true,
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: LocalizationResources.search,
          hintStyle: const TextStyle(
            color: Colors.white60,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
