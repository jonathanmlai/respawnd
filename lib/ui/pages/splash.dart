import 'package:flutter/material.dart';
import '../constants.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorbackgroundBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/respawndFlatLogo.png',
              width: size.width * 0.3,
            ),
          ),
          // Center(
          //   child: Text(
          //     "Respawnd",
          //     style:
          //         TextStyle(color: Colors.white, fontSize: size.width * 0.15),
          //   ),
          // )
        ],
      ),
    );
  }
}
