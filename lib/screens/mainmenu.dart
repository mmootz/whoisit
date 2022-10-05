import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmdb_game/models/actors.dart';
import 'package:tmdb_game/models/remoteActors.dart';
import 'package:tmdb_game/screens/quiz.dart';
import '../widgets/fetch_tmdb.dart';
import 'package:tmdb_game/models/newRound.dart';

class mainMenu extends StatefulWidget {
  //const mainMenu({Key? key}) : super(key: key);
  static const routeName = 'mainMenu';

  @override
  State<mainMenu> createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  List actorMap = [];
  List actorNames = [];
  Map pickedActors = {};


  // need to add win screen when 100 rounds are completed with thorpy coneffit etc.

  // need to write a way to number of rounds and end on them.
  // if page is greater than 10 call win screen
  // likely rename endScreen to endRound

  // idea for guessing actor of a movie.
  // likely can use some of the same functions just need to look at json.

  // maybe add buttons  at bottom for rety or status

  // right or wrong animations

  Future fetchActors(int page) async {
    const String apiUrlRoot = "https://api.themoviedb.org/3/person/popular?";
    const String apiUrlKey = "api_key=e7012f0ede42eedde18f502522c6f94e";
    const String apiUrlPage = "&language=en-US&page=";

    final actors =
    await fetchJson(apiUrlRoot + apiUrlKey + apiUrlPage + page.toString());

    return actors["results"];
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/data/data.json');
    final data = await json.decode(response);

    // setState(() {
    //   actorMap = data["results"];
    //   print(actorMap.toString());
    //   pickedActors = pickActors(actorMap, 10);
    //   print(pickedActors.toString());
    //   actorNames = Names(actorMap);
    //   print(actorNames.toString());
    // });
    //print('done loading');
  }

  Future<void> startGame(context) async {
    //readJson();
     actorMap = await fetchActors(1);
     pickedActors = pickActors(actorMap,10);
     actorNames  = Names(actorMap);
    Navigator.pop(context);
    Navigator.pushNamed(context, quiz.routeName,
        arguments: newRoundScreen(100, pickedActors, actorNames,1,1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Who is it?'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('?', style: TextStyle(fontSize: 75)),
              ElevatedButton(
                  onPressed: () => startGame(context), child: Text('Start!'))
            ],
          ),
        ),
      ),
    );
  }
}
