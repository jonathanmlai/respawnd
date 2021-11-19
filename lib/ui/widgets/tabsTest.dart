import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Respawnd/bloc/authentication/authentication_bloc.dart';
import 'package:Respawnd/bloc/authentication/bloc.dart';
import 'package:Respawnd/ui/pages/messages.dart';
import 'package:Respawnd/ui/pages/search.dart';
import 'package:Respawnd/ui/pages/matches.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class Tabs extends StatelessWidget {
  final userId;

  const Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> pages = [
      Search(
        userId: userId,
      ),
      Matches(
        userId: userId,
      ),
      Messages(
        userId: userId,
      ),
    ];

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: colorLightBlue,
        ).copyWith(
          secondary: colorbackgroundBlack,
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Respawnd",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: size.height * 0.025,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              )
            ],
          ),
          body: TabBarView(
            children: pages,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: 100,
            height: 100,
            child: FloatingActionButton(
              onPressed: () {},
              elevation: 2.0,
              child: Icon(
                Icons.videogame_asset_rounded,
                color: Colors.white,
                size: size.height * 0.05,
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: size.height * 0.15,
            child: BottomAppBar(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        IconButton(
                            icon: Padding(
                              padding: EdgeInsets.only(
                                  right: size.width * 0.1,
                                  top: size.height * 0.02),
                              child: Icon(Icons.person),
                            ),
                            iconSize: size.height * 0.05,
                            onPressed: () {
                              Matches(
                                userId: userId,
                              );
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        IconButton(
                            icon: Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * 0.1,
                                  top: size.height * 0.02),
                              child: Icon(Icons.message),
                            ),
                            iconSize: size.height * 0.05,
                            onPressed: () {}),
                      ],
                    ),
                  ),
                ],
              ),
              shape: CircularNotchedRectangle(),
              color: colorLightBlue,
            ),
          ),
        ),
      ),
    );
  }
}
