import 'package:flutter/material.dart';

BoxDecoration customeBackground() {
  return const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        );
  
  // const BoxDecoration(
  //   gradient: LinearGradient(
  //     begin: Alignment.topCenter,
  //     end: Alignment.bottomCenter,
  //     colors: [
  //       Color.fromARGB(255, 165, 245, 115),
  //       Color.fromARGB(255, 97, 241, 118),
  //       Color.fromARGB(255, 71, 224, 130),
  //       Color.fromARGB(255, 57, 229, 166),
  //     ],
  //     stops: [0.1, 0.4, 0.7, 0.9],
  //   ),
  // );
}
