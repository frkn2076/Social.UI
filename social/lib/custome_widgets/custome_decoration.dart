import 'package:flutter/material.dart';

InputDecoration customeInputDecoration([String? labelText]){
  return InputDecoration(
    labelStyle: const TextStyle(color: Colors.blue),
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    labelText: labelText
  );
}
