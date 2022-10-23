// trohpy with confiti and score displayed
// unlocks guess movie

import 'package:flutter/material.dart';
import 'package:tmdb_game/screens/quiz.dart';
import 'package:tmdb_game/widgets/gameover.dart';
import 'package:tmdb_game/models/quizPass.dart';
import '../models/actors.dart';
import '../widgets/fetch_tmdb.dart';
import 'package:tmdb_game/models/newRound.dart';
import 'package:tmdb_game/widgets/confetti.dart';

class endScreen extends StatefulWidget {
  //const endScreen({Key? key}) : super(key: key);
  static const routeName = 'endScreen';

  @override
  State<endScreen> createState() => _endScreenState();
}

class _endScreenState extends State<endScreen> {
  List actorMap = [];
  List actorNames = [];
  Map pickedActors = {};

  //final score = 15;
  final int bonus = 25;

  
  //confetti
  
  

  //int newScore = 0;
  @override
  void didChangeDependencies() {}

  Future fetchActors(int page) async {
    const String apiUrlRoot = "https://api.themoviedb.org/3/person/popular?";
    const String apiUrlKey = "api_key=e7012f0ede42eedde18f502522c6f94e";
    const String apiUrlPage = "&language=en-US&page=";

    final actors =
        await fetchJson(apiUrlRoot + apiUrlKey + apiUrlPage + page.toString());

    return actors["results"];
  }
  

  Future<void> nextSet(context, int page, int nxtScore, int nxtRound) async {
    int round;
    int newPage = 0;
    if (page <= 10) {
      newPage = page + 1;
    }

    round = nxtRound + 1;

    actorMap = await fetchActors(newPage);
    pickedActors = pickActors(actorMap, 10);
    actorNames = Names(actorMap);
    Navigator.pop(context);
    Navigator.pushNamed(context, quiz.routeName,
        arguments:
            newRoundScreen(nxtScore, pickedActors, actorNames, newPage, round));
  }

  Future<void> retry(context) async {
    actorMap = await fetchActors(1);
    pickedActors = pickActors(actorMap, 10);
    actorNames = Names(actorMap);
    Navigator.pop(context);
    Navigator.pushNamed(context, quiz.routeName,
        arguments: newRoundScreen(100, pickedActors, actorNames, 1, 1));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as quizPass;
    //args.perfect ? newScore = args.score + bonus : newScore = 0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Who is it?'),
        centerTitle: true,
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          args.score <= 0
              ? const Text('GameOver',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26))
              : const Text(
                  'Round Cleared!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
          args.perfect ? Text('Perfect Round +$bonus') : Container(),
          confettiBlast(args.perfect),
          Text(args.score.toString(), style: TextStyle(fontSize: 75)),
          gameOver(args.answers),
          ElevatedButton(
              onPressed: args.score <= 0
                  ? () => retry(context)
                  : () =>
                      nextSet(context, args.page, args.score, args.endRound),
              child: args.score <= 0
                  ? const Text('Retry')
                  : const Text('Next Set'))
        ],
      ),
    );
  }
}
