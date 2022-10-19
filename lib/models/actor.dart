import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../widgets/fetch_tmdb.dart';

class Actors{

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/data/data.json');
    final data = await json.decode(response);
    return data["results"];
  }
  Future fetchActors(int page) async {
    const String apiUrlRoot = "https://api.themoviedb.org/3/person/popular?";
    const String apiUrlKey = "api_key=e7012f0ede42eedde18f502522c6f94e";
    const String apiUrlPage = "&language=en-US&page=";

    final actors =
    await fetchJson(apiUrlRoot + apiUrlKey + apiUrlPage + page.toString());
    return actors["results"];
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
    final random = Random();
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
    return guessActor;
  }
}