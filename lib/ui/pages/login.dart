import 'package:flutter/material.dart';
import 'package:Respawnd/repositories/userRepository.dart';
import 'package:Respawnd/bloc/login/bloc.dart';
import '../constants.dart';
import 'package:Respawnd/ui/widgets/loginForm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  final UserRepository _userRepository;

  Login({@required UserRepository userRepository})
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
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          userRepository: _userRepository,
        ),
        child: LoginForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
