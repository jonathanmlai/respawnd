import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Respawnd/bloc/authentication/authentication_bloc.dart';
import 'package:Respawnd/bloc/authentication/authentication_event.dart';
import 'package:Respawnd/bloc/profile/bloc.dart';
import 'package:Respawnd/repositories/userRepository.dart';
import 'package:Respawnd/ui/constants.dart';
import 'package:Respawnd/ui/widgets/gender.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();

  String gender, interestedIn;
  DateTime age;
  File photo;
  GeoPoint location;
  ProfileBloc _profileBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      gender != null &&
      interestedIn != null &&
      photo != null &&
      age != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    location = GeoPoint(position.latitude, position.longitude);
  }

  _onSubmitted() async {
    await _getLocation();
    _profileBloc.add(
      Submitted(
        name: _nameController.text,
        age: age,
        location: location,
        gender: gender,
        interestedIn: interestedIn,
        photo: photo,
      ),
    );
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      //bloc: _profileBloc,
      listener: (context, state) {
        if (state.isFailure) {
          print("Failed");
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Profile Creation Unsuccessful'),
                    Icon(Icons.error)
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("Submitting");
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Submitting'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.white,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: size.height * 0.01),
                    width: size.width,
                    child: CircleAvatar(
                      radius: size.width * 0.25,
                      backgroundColor: Colors.transparent,
                      child: photo == null
                          ? GestureDetector(
                              onTap: () async {
                                FilePickerResult getPic =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                );
                                if (getPic != null) {
                                  setState(
                                    () {
                                      File file = File(getPic.files.first.path);
                                      photo = file;
                                    },
                                  );
                                }
                              },
                              child: Image.asset('assets/profilephoto.png'),
                            )
                          : GestureDetector(
                              onTap: () async {
                                FilePickerResult getPic =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                );
                                if (getPic != null) {
                                  setState(
                                    () {
                                      photo = getPic as File;
                                    },
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: size.width * 0.3,
                                backgroundImage: FileImage(photo),
                              ),
                            ),
                    ),
                  ),
                  textFieldWidget(_nameController, "Name", size),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        maxTime: DateTime.now(),
                        // minTime: DateTime(1900, 1, 1),
                        // maxTime: DateTime(DateTime.now().year - 19, 1, 1),
                        onConfirm: (date) {
                          setState(
                            () {
                              age = date;
                            },
                          );
                          print(age);
                        },
                      );
                    },
                    child: Text(
                      "Enter Birthday",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.height * 0.04,
                            bottom: size.height * 0.02),
                        child: Text(
                          "I Identify as a",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            textStyle: TextStyle(
                                fontSize: size.width * 0.05, color: colorRed),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          genderWidget(
                            FontAwesomeIcons.mars,
                            "Male",
                            size,
                            gender,
                            () {
                              setState(
                                () {
                                  gender = "Male";
                                },
                              );
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.venus,
                            "Female",
                            size,
                            gender,
                            () {
                              setState(
                                () {
                                  gender = "Female";
                                },
                              );
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.transgender,
                            "Transgender",
                            size,
                            gender,
                            () {
                              setState(
                                () {
                                  gender = "Transgender";
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      //Remove Interested in
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.height * 0.04,
                            bottom: size.height * 0.02),
                        child: Text(
                          "I want my teammate to be",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            textStyle: TextStyle(
                                fontSize: size.width * 0.05, color: colorRed),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          genderWidget(
                            FontAwesomeIcons.mars,
                            "Male",
                            size,
                            interestedIn,
                            () {
                              setState(
                                () {
                                  interestedIn = "Male";
                                },
                              );
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.venus,
                            "Female",
                            size,
                            interestedIn,
                            () {
                              setState(
                                () {
                                  interestedIn = "Female";
                                },
                              );
                            },
                          ),
                          genderWidget(
                            FontAwesomeIcons.transgender,
                            "Transgender",
                            size,
                            interestedIn,
                            () {
                              setState(
                                () {
                                  interestedIn = "Transgender";
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                    // child: ElevatedButton(
                    //   onPressed: isButtonEnabled(state) ? _onSubmitted() : null,
                    //   child: Text(
                    //     "Finish",
                    //     style: GoogleFonts.inter(
                    //       fontWeight: FontWeight.w700,
                    //       textStyle: TextStyle(
                    //           fontSize: size.width * 0.04, color: Colors.white),
                    //     ),
                    //   ),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: colorRed,
                    //     shadowColor: colorRed[800],
                    //     fixedSize: Size(size.width * 0.7, size.height * 0.05),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    child: GestureDetector(
                      onTap: () {
                        if (isButtonEnabled(state)) {
                          _onSubmitted();
                        } else {}
                      },
                      child: Container(
                        width: size.width * 0.7,
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                          color: isButtonEnabled(state)
                              ? colorLightBlue
                              : colorGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Finish",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              textStyle: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.only(
      left: size.height * 0.04,
      right: size.height * 0.04,
      top: size.height * 0.02,
      bottom: size.height * 0.02,
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: colorGrey,
        filled: true,
        hintText: "Name",
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
  );
}
