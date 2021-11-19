import 'package:flutter/material.dart';
import 'package:Respawnd/repositories/userRepository.dart';
import 'package:Respawnd/bloc/signup/bloc.dart';
import '../constants.dart';
import 'package:Respawnd/ui/widgets/signUpForm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorRed,
        ),
        backgroundColor: Colors.white,
        elevation: 0, //no border, flow freely
      ),
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
          userRepository: _userRepository,
        ),
        child: SignUpForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
