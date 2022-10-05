// 3 diffrent game modes
// guess actor
// guess movie
// endless make this unlocked after completed one.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmdb_game/models/newRound.dart';
import 'package:tmdb_game/screens/endScreen.dart';
import 'package:tmdb_game/widgets/topbar.dart';
import 'package:tmdb_game/widgets/Poster.dart';
import 'dart:convert';
import '../models/newRound.dart';
import '../widgets/buttonAnswers.dart';
import '../widgets/fetch_tmdb.dart';
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
  int displayRound = 1;
  bool isNotGameOver = true;
  bool perfectRound = true;
  bool roundStarted = false;
  bool loaded = false;
  String rightActor = '';

  final int hit = 10;

  //final int endRound = startRound + 10;
  late AnimationController controller;
  final String profileUrl =
      "https://www.themoviedb.org/t/p/w300_and_h450_bestv2";

  @override
  void didChangeDependencies() {
    //if (!roundStarted) {
    //if (!loadedActors) {
    initRound();
    //newRound();
    //loadedActors = true;
    //}
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

  Future fetchActors(int page) async {
    const String apiUrlRoot = "https://api.themoviedb.org/3/person/popular?";
    const String apiUrlKey = "api_key=e7012f0ede42eedde18f502522c6f94e";
    const String apiUrlPage = "&language=en-US&page=";

    final actors =
    await fetchJson(apiUrlRoot + apiUrlKey + apiUrlPage + page.toString());
    setState(() {
      _items = actors["results"];
    });
    //newGame();
  }

  fillerNames(List randomList, int picks, String name) {
    final random = new Random();
    List pickedList = [];
    List shuffled = [];
    List tempList = new List<String>.from(randomList);
    tempList.remove(name);
    pickedList.add(name);

    for (int i = 0; i < picks; i++) {
      String Pick = tempList[random.nextInt(tempList.length)];
      tempList.remove(Pick);
      pickedList.add(Pick);
    }

    shuffled = (pickedList..shuffle());

    return shuffled;
  }

  actorsNames(List json) {
    List names = [];
    //Map<dynamic, dynamic> actor = jsonDecode(json);
    for (int i = 0; i < 19; i++) {
      names.add(json[i]['name']);
    }
    return names;
  }

  pickRandom(List randomList, int picks) {
    final random = new Random();
    List pickedList = [];
    for (int i = 0; i < picks; i++) {
      String Pick = randomList[random.nextInt(randomList.length)];
      randomList.remove(Pick);
      pickedList.add(Pick);
    }
    return pickedList;
  }

  pickActors(List randomList, int picks) {
    final List randomNames;
    List actors = [];
    Map<dynamic, dynamic> guessActor = {};
    String actorName = "";
    String randomActorName = "";
    actors = actorsNames(randomList);
    randomNames = pickRandom(actors, picks);
    randomNames.shuffle();
    for (int namesIndex = 0; namesIndex < randomList.length; namesIndex++) {
      for (int shuffleIndex = 0;
      shuffleIndex < randomNames.length;
      shuffleIndex++) {
        actorName = randomList[namesIndex]['name'];
        randomActorName = randomNames.elementAt(shuffleIndex);
        if (actorName == randomActorName) {
          guessActor[shuffleIndex + 1] = {'name': '', 'profile_path': ''};
          guessActor[shuffleIndex + 1]['name'] = randomList[namesIndex]['name'];
          guessActor[shuffleIndex + 1]['profile_path'] =
          randomList[namesIndex]['profile_path'];
          break;
        }
      }
    }
    print(guessActor);
    return guessActor;
  }

  addBonus() {
    debugPrint('add bonus');
    setState(() {
      score = score + bonus;
    });
  }

  newGame() {
    actorNames = actorsNames(_items);
    pickedActor = pickActors(_items, 10);
    //newRound();
  }

  initRound() {
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments as newRoundScreen;

    args.pickedActors.isNotEmpty ? setState(() {
      rightActor = args.pickedActors[round]['name'];
      shuffledActors = fillerNames(args.actorNames, 4, rightActor);
      score = args.score;
      displayRound = args.startRound;

    }) : debugPrint('bunch of bullshit init');
  }
  newRound() {
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments as newRoundScreen;

    args.pickedActors.isNotEmpty ? setState(() {
      rightActor = args.pickedActors[round]['name'];
      shuffledActors = fillerNames(args.actorNames, 4, rightActor);
      //score = args.score;

    }) : debugPrint('bunch of bullshit');
  }

  nextSet() {
    setState(() {
      //  score = 100;
      setNumber = setNumber + 1;
      round = 1;
      isNotGameOver = true;
      perfectRound = true;
      answers = {};
    });
    //readJson();
    fetchActors(setNumber);
    newGame();
  }

  rightAnswer(context) {
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments as newRoundScreen;
    int endRound;
    endRound = 10;
    int lastRound;
    lastRound  = args.startRound + 9;
    print("lastRound: $lastRound");

    int nextRound;
    print("end round:$endRound" );
    debugPrint('right');
    nextRound = round + 1;
    print("next round:$nextRound");
    print(args.pickedActors.length);
    if (nextRound >= endRound) {
      debugPrint('You Win');
      setState(() {
        answers[round - 1] = {
          'name': args.pickedActors[round]['name'],
          'answer': true
        };
        if (perfectRound) {
          addBonus();
        }
        isNotGameOver = false;
      });
      Navigator.pop(context);
      Navigator
          .pushNamed(context, endScreen.routeName, arguments: quizPass(
          score: score,
          answers: answers,
          perfect: perfectRound,
          page: args.page,
          endRound: lastRound));
    } else {
      setState(() {
        answers[round - 1] = {
          'name': args.pickedActors[round]['name'],
          'answer': true
        };
        round = nextRound;
        displayRound = displayRound + 1;
      });
      debugPrint(answers.toString());
      newRound();
    }
  }

  wrongAnswer(context) {
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments as newRoundScreen;
    int newScore;
    int nextRound;
    debugPrint('wrong');
    nextRound = round + 1;
    newScore = score - hit;
    int endRound;
    endRound = args.startRound + 9;

    if (nextRound > endRound || newScore <= 0) {
      debugPrint('game over');
      setState(() {
        if (perfectRound) {
          perfectRound = false;
        }
        answers[round - 1] = {
          'name': args.pickedActors[round]['name'],
          'answer': false
        };
        isNotGameOver = false;
      });
      Navigator.pop(context);
      Navigator
          .pushNamed(context, endScreen.routeName, arguments: quizPass(
          score: newScore,
          answers: answers,
          perfect: perfectRound,
          page: args.page,
          endRound: endRound));
    } else {
      setState(() {
        answers[round - 1] = {
          'name': args.pickedActors[round]['name'],
          'answer': false
        };
        score = newScore;
        round = nextRound;
        displayRound = displayRound + 1;
        if (perfectRound) {
          perfectRound = false;
        }
      });

      newRound();
    }
  }

  resetQuiz() {
    setState(() {
      setNumber = 1;
      score = 100;
      round = 1;
      isNotGameOver = true;
      perfectRound = true;
      answers = {};
    });
    readJson();
    //fetchActors(setNumber);
    newGame();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments as newRoundScreen;
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
              ? posterCard(
              profileUrl + args.pickedActors[round]['profile_path'])
              : Text('no Data'),
          SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.03,
          ),
          answerButtons(
              guesses: shuffledActors,
              right: () => rightAnswer(context),
              wrong: () => wrongAnswer(context),
              picked: rightActor),
          // LinearProgressIndicator(
          //   minHeight: 20,
          //   value:  controller.value,)
        ],
      ),
    );

  }
}
