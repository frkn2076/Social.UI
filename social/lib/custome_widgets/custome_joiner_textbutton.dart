import 'package:flutter/material.dart';

class CustomeJoinerTextButton extends StatelessWidget {
  final bool? isPrivate;
  final String? userName;
  final GestureTapCallback? onTap;
  const CustomeJoinerTextButton(
      {Key? key, this.isPrivate, this.userName, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // () => {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => isPrivate
      //             ? const PrivateProfile()
      //             : PublicProfile(id: joiner.id!)),
      //   )
      // },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(1),
        child: Text(
          userName ?? "",
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: isPrivate == true ? Colors.red : Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
      ),
    );

    //  Container(
    //   alignment: Alignment.center,
    //   padding: const EdgeInsets.all(1),
    //   child: Text(
    //     userName ?? "",
    //     style: TextStyle(
    //         decoration: TextDecoration.underline,
    //         color: isPrivate == true ? Colors.red : Colors.blue,
    //         fontWeight: FontWeight.w500,
    //         fontSize: 20),
    //   ),
    // );
  }
}
