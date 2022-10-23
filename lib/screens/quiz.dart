// 3 diffrent game modes
// guess actor
// guess movie
// endless make this unlocked after completed one.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmdb_game/models/newRound.dart';
import 'package:tmdb_game/screens/endScreen.dart';
import 'package:tmdb_game/screens/winScreen.dart';
import 'package:tmdb_game/widgets/topbar.dart';
import 'package:tmdb_game/widgets/Poster.dart';
import 'dart:convert';
import '../models/newRound.dart';
import '../widgets/buttonAnswers.dart';
import 'package:tmdb_game/models/actors.dart';
import 'package:tmdb_game/models/quizPass.dart';

class quiz extends StatefulWidget {
  //const quiz({Key? key}) : super(key: key);
  static const routeName = 'quiz';

  @override
  State<quiz> createState() => _quizState();
}

class _quizState extends State<quiz> {
  List _items = [];
  List actorNames = [];
  List randomActors = [];
  List shuffledActors = [];
  Map pickedActor = {};
  Map answers = {};

  int round = 1;
  int score = 100;
  int setNumber = 1;
  int bonus = 25;
  int lastGameRound = 100;
  int displayRound = 1;
  bool isNotGameOver = true;
  bool perfectRound = true;
  bool roundStarted = false;
  bool loaded = false;
  String rightActor = '';
  String actorPicture = '';

  final int hit = 10;

  //final int endRound = startRound + 10;
  late AnimationController controller;
  final String profileUrl =
      "https://www.themoviedb.org/t/p/w300_and_h450_bestv2";

  @override
  void didChangeDependencies() {
    initRound();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/data/data.json');
    final data = await json.decode(response);

    setState(() {
      _items = data["results"];
    });

    actorNames = Names(_items);
    pickedActor = pickActors(_items, 10);
    newRound();
  }

  addBonus() {
    debugPrint('add bonus');
    setState(() {
      score = score + bonus;
    });
  }

  newGame() {
    actorNames = Names(_items);
    pickedActor = pickActors(_items, 10);
    //newRound();
  }

  initRound() {
    final args = ModalRoute.of(context)?.settings.arguments as newRoundScreen;

    args.pickedActors.isNotEmpty
        ? setState(() {
            actorPicture = args.pickedActors[round]['profile_path'];
            rightActor = args.pickedActors[round]['name'];
            shuffledActors = fillerNames(args.actorNames, 4, rightActor);
            score = args.score;
            displayRound = args.startRound;
          })
        : debugPrint('bunch of bullshit init');
  }

  newRound() {
    final args = ModalRoute.of(context)?.settings.arguments as newRoundScreen;

    args.pickedActors.isNotEmpty
        ? setState(() {
            actorPicture = args.pickedActors[round]['profile_path'];

            rightActor = args.pickedActors[round]['name'];
            shuffledActors = fillerNames(args.actorNames, 4, rightActor);
            debugPrint("name: $rightActor picture: $actorPicture");
            //score = args.score;
          })
        : debugPrint('bunch of bullshit');
  }

  Winscreen(context, int winScore) {
    Navigator.pop(context);
    Navigator.pushNamed(context, winScreen.routeName, arguments: winScore);
  }

  void showEndRoundScreen(context, int page, int lastRound) {
    Navigator.pop(context);
    Navigator.pushNamed(context, endScreen.routeName,
        arguments: quizPass(
            score: score,
            answers: answers,
            perfect: perfectRound,
            page: page,
            endRound: lastRound));
  }

  void updateAnswers(String actor, bool answer, int nextRound) {
    setState(() {
      answers[round - 1] = {'name': actor, 'answer': answer};
      round = nextRound;
      displayRound = displayRound + 1;
    });
  }

  rightAnswer(context, String selectedActor, int page, int startRound) {
    // answers and score are used but setstate and not called by the function
    int endRound = startRound + 9;
    //int lastRound = startRound + 9;
    int nextRound;
    nextRound = round + 1;
    if (displayRound == endRound) {
      if (lastGameRound == displayRound) {
        Winscreen(context, score);
      } else {
        setState(() {
          answers[round - 1] = {'name': selectedActor, 'answer': true};
          if (perfectRound) {
            addBonus();
          }
        });
        showEndRoundScreen(context, page, endRound);
      }
    } else {
      updateAnswers(selectedActor, true, nextRound);
      newRound();
    }
  }

  wrongAnswer(context, String selectorActor, int page, int startRound) {
    //final args = ModalRoute.of(context)?.settings.arguments as newRoundScreen;
    // score,round,hit and prefect round are called from outside
    int newScore;
    int nextRound;
    debugPrint('wrong');
    nextRound = round + 1;
    newScore = score - hit;
    int endRound = startRound + 9;

    if (displayRound == endRound || newScore <= 0) {
      if (lastGameRound == displayRound) {
        Winscreen(context, score);
      } else {
        setState(() {
          if (perfectRound) {
            perfectRound = false;
          }
        });
        updateAnswers(selectorActor, false, nextRound);
        showEndRoundScreen(context, page, endRound);
      }
    } else {
      setState(() {
        score = newScore;
        round = nextRound;
        displayRound = displayRound + 1;
        if (perfectRound) {
          perfectRound = false;
        }
      });
      updateAnswers(selectorActor, false, nextRound);
      newRound();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as newRoundScreen;
    return Scaffold(
      appBar: AppBar(
        title: Text('Who is it?'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Text("Set $setNumber", style: const TextStyle(fontSize: 20)),
          topBar(score: score, round: displayRound, endRound: 100),
          args.pickedActors.isNotEmpty
              ? posterCard(profileUrl + actorPicture)
              : Text('no Data'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          answerButtons(
              guesses: shuffledActors,
              right: () =>
                  rightAnswer(context, rightActor, args.page, args.startRound),
              wrong: () =>
                  wrongAnswer(context, rightActor, args.page, args.startRound),
              picked: rightActor),
          // LinearProgressIndicator(
          //   minHeight: 20,
          //   value:  controller.value,)
        ],
      ),
    );
  }
}
