import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_decoration.dart';

class CustomeFocusedTextField extends StatelessWidget {
  final bool? readOnly;
  final String labelText;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;
  const CustomeFocusedTextField({
    Key? key,
    this.readOnly = false,
    required this.labelText,
    required this.controller,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(controller?.text.isEmpty ?? true){
      controller!.text = labelText;
    }
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        readOnly: readOnly == true,
        controller: controller,
        decoration: customeInputDecoration(labelText),
      ),
    );
  }
}
