import 'package:Respawnd/repositories/userRepository.dart';
import 'package:Respawnd/bloc/signup/bloc.dart';
import 'package:Respawnd/bloc/authentication/authentication_bloc.dart';
import 'package:Respawnd/bloc/authentication/authentication_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignUpForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpBloc _signUpBloc;
  //UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onFormSubmitted() {
    _signUpBloc.add(
      SignUpWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sign Up Failed"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("isSubmitting");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Signing up..."),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
        if (state.isSuccess) {
          print("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.08,
                          bottom: size.height * 0.08,
                          left: size.height * 0.05),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Create your \nAccount",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            textStyle: TextStyle(
                                fontSize: size.width * 0.1, color: colorRed),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: size.height * 0.05,
                          left: size.height * 0.05,
                          bottom: size.height * 0.03),
                      child: TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (_) {
                          return !state.isEmailValid ? "Invalid Email" : null;
                        },
                        decoration: InputDecoration(
                          fillColor: colorGrey,
                          filled: true,
                          hintText: "Email",
                          hintStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: size.height * 0.05,
                          left: size.height * 0.05,
                          bottom: size.height * 0.2),
                      child: TextFormField(
                        controller: _passwordController,
                        autocorrect: false,
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          return !state.isPasswordValid
                              ? "Invalid Password"
                              : null;
                        },
                        decoration: InputDecoration(
                          fillColor: colorGrey,
                          filled: true,
                          hintText: "Password",
                          hintStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: isSignUpButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                            child: Text(
                              "Create Account",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                textStyle: TextStyle(
                                    fontSize: size.width * 0.04,
                                    color: Colors.white),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: colorRed,
                              shadowColor: colorRed[800],
                              fixedSize:
                                  Size(size.width * 0.7, size.height * 0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                        ],
                      ),
                      // child: GestureDetector(
                      //   onTap: isSignUpButtonEnabled(state)
                      //       ? _onFormSubmitted
                      //       : null,
                      //   child: Container(
                      //     width: size.width * 0.8,
                      //     height: size.height * 0.06,
                      //     decoration: BoxDecoration(
                      //       color: isSignUpButtonEnabled(state)
                      //           ? Colors.white
                      //           : Colors.grey,
                      //       borderRadius:
                      //           BorderRadius.circular(size.height * 0.05),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Sign Up",
                      //         style: TextStyle(
                      //             fontSize: size.height * 0.025,
                      //             color: Colors.blue),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onEmailChanged() {
    _signUpBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
