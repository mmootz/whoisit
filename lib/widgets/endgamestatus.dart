
import 'package:flutter/material.dart';

class endGameStatus extends StatelessWidget {
  //const endGameStatus({Key? key}) : super(key: key);

  final int score;

  endGameStatus(this.score);

  @override
  Widget build(BuildContext context) {
    String finalScore = score <= 0 ? "you Lose!" : "you win!";
    return Text(finalScore);
  }
}
