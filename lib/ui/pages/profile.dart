import 'package:Respawnd/bloc/profile/bloc.dart';
import 'package:Respawnd/repositories/userRepository.dart';
import 'package:Respawnd/ui/constants.dart';
import 'package:Respawnd/ui/widgets/profileForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  final _userRepository;
  final userId;

  Profile({@required UserRepository userRepository, String userId})
      : assert(userRepository != null && userId != null),
        _userRepository = userRepository,
        userId = userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorRed,
        ),
        title: Text(
          "Profile Setup",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(userRepository: _userRepository),
        child: ProfileForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
