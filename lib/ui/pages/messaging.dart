import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Respawnd/bloc/messaging/bloc.dart';
import 'package:Respawnd/models/message.dart';
import 'package:Respawnd/models/user.dart';
import 'package:Respawnd/repositories/messaging.dart';
import 'package:Respawnd/ui/constants.dart';
import 'package:Respawnd/ui/widgets/message.dart';
import 'package:Respawnd/ui/widgets/photo.dart';
import 'package:google_fonts/google_fonts.dart';

class Messaging extends StatefulWidget {
  final User currentUser, selectedUser;

  const Messaging({this.currentUser, this.selectedUser});

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  TextEditingController _messageTextController = TextEditingController();
  MessagingRepository _messagingRepository = MessagingRepository();
  MessagingBloc _messagingBloc;

  bool isValid = false;

  // //checks if text controller is empty
  // bool get isPopulated => _messageTextController.text.isNotEmpty;
  //
  // bool isSubmitButtonEnabled(MessagingState state) {
  //   return isPopulated;
  // }

  @override
  void initState() {
    super.initState();
    _messagingBloc = MessagingBloc(messagingRepository: _messagingRepository);

    //checks if text controller is empty
    _messageTextController.text = '';
    _messageTextController.addListener(
      () {
        setState(
          () {
            isValid = (_messageTextController.text.isEmpty) ? false : true;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    print("Message Submitted");

    _messagingBloc.add(
      SendMessageEvent(
        message: Message(
          text: _messageTextController.text,
          senderId: widget.currentUser.uid,
          senderName: widget.currentUser.name,
          selectedUserId: widget.selectedUser.uid,
          photo: null,
        ),
      ),
    );
    _messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: colorRed,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: ClipOval(
              child: Container(
                height: size.height * 0.07,
                width: size.height * 0.07,
                child: PhotoWidget(
                  photoLink: widget.selectedUser.photo,
                ),
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     ClipOval(
          //       child: Container(
          //         height: size.height * 0.06,
          //         width: size.height * 0.06,
          //         child: PhotoWidget(
          //           photoLink: widget.selectedUser.photo,
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: size.width * 0.03,
          //     ),
          //     Expanded(
          //       child: Text(
          //         widget.selectedUser.name,
          //         style: GoogleFonts.openSans(
          //           textStyle: TextStyle(color: Colors.black),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                widget.selectedUser.name,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700,
                  textStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MessagingBloc, MessagingState>(
        bloc: _messagingBloc,
        builder: (BuildContext context, MessagingState state) {
          if (state is MessagingInitialState) {
            _messagingBloc.add(
              MessageStreamEvent(
                currentUserId: widget.currentUser.uid,
                selectedUserId: widget.selectedUser.uid,
              ),
            );
          }
          if (state is MessagingLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MessagingLoadedState) {
            Stream<QuerySnapshot> messageStream = state.messageStream;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        "Start the conversation?",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      );
                    }
                    if (snapshot.data.docs.isNotEmpty) {
                      return Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return MessageWidget(
                                      currentUserId: widget.currentUser.uid,
                                      messageId: snapshot.data.docs[index].id,
                                    );
                                  },
                                  itemCount: snapshot.data.docs.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Start the conversation?",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.08,
                  color: colorRed,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult photo = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          File file = File(photo.files.first.path);

                          if (photo != null) {
                            _messagingBloc.add(
                              SendMessageEvent(
                                message: Message(
                                  text: null,
                                  senderName: widget.currentUser.name,
                                  senderId: widget.currentUser.uid,
                                  photo: file,
                                  selectedUserId: widget.selectedUser.uid,
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.005,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: size.height * 0.04,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: size.height * 0.05,
                          padding: EdgeInsets.all(size.height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _messageTextController,
                              textInputAction: TextInputAction.send,
                              maxLines: null,
                              decoration: null,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: backgroundColor,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: isValid ? _onFormSubmitted : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.01,
                          ),
                          child: Icon(
                            Icons.send,
                            color: isValid ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
