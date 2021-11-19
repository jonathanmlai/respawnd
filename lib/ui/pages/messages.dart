import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Respawnd/bloc/message/bloc.dart';
import 'package:Respawnd/bloc/message/message_bloc.dart';
import 'package:Respawnd/repositories/messageRepository.dart';
import 'package:Respawnd/ui/widgets/chat.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class Messages extends StatefulWidget {
  final String userId;

  Messages({this.userId});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  MessageRepository _messagesRepository = MessageRepository();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(messageRepository: _messagesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _messageBloc,
      builder: (BuildContext context, MessageState state) {
        if (state is MessageInitialState) {
          _messageBloc.add(ChatStreamEvent(currentUserId: widget.userId));
        }
        if (state is ChatLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;

          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("No data");
              }
              if (snapshot.data.docs.isNotEmpty) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChatWidget(
                          creationTime:
                              snapshot.data.docs[index].get('timestamp'),
                          userId: widget.userId,
                          selectedUserId: snapshot.data.docs[index].id,
                        );
                      });
                }
              } else
                return Center(
                  child: Text(
                    "You Don't Have Any Messages",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      textStyle: TextStyle(
                          fontSize: size.width * 0.09, color: colorRed),
                    ),
                  ),
                );
            },
          );
        }
        return Container();
      },
    );
  }
}
