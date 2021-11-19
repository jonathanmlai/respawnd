import 'package:Respawnd/ui/pages/login.dart';
import 'package:Respawnd/ui/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:Respawnd/repositories/userRepository.dart';
import '../constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  final UserRepository _userRepository;

  Welcome({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: new Container(
        color: colorbackgroundBlack,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.15, bottom: size.height * 0.15),
              child: Text(
                "Respawnd",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: size.height * 0.06,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Image.asset(
              'assets/respawndFlatLogo.png',
              width: size.width * 0.4,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.15, bottom: size.height * 0.03),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUp(userRepository: _userRepository);
                      },
                    ),
                  );
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: size.height * 0.018, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shadowColor: Colors.white60,
                  fixedSize: Size(size.width * 0.7, size.height * 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            //SizedBox(height: size.height * 0.6),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return Login(userRepository: _userRepository);
                  }),
                );
              },
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: size.height * 0.018, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: colorRed,
                shadowColor: colorRed[500],
                fixedSize: Size(size.width * 0.7, size.height * 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
