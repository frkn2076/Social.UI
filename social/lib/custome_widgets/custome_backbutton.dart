import 'package:flutter/material.dart';
import 'package:social/utils/disk_resources.dart';

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
        if (!DiskResources.getBool("isMuteOn")) {
          Feedback.forTap(context);
        }
        Navigator.pop(context);
      },
    );
  }
}
