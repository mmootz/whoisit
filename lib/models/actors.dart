
import 'dart:math';

Names(List json) {
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
  actors = Names(randomList);
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