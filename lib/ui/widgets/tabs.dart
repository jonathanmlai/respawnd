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
      Matches(
        userId: userId,
      ),
      Search(
        userId: userId,
      ),
      Messages(
        userId: userId,
      ),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: colorLightBlue,
        ).copyWith(
          secondary: colorbackgroundBlack,
        ),
      ),
      child: DefaultTabController(
        length: 3,
        initialIndex: 1,
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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                      indicatorColor: colorRed,
                      labelColor: colorRed,
                      unselectedLabelColor: colorbackgroundBlack,
                      tabs: <Widget>[
                        Tab(
                          icon: Icon(
                            Icons.person,
                            size: size.height * 0.04,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.videogame_asset_rounded,
                            size: size.height * 0.04,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.message,
                            size: size.height * 0.04,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
