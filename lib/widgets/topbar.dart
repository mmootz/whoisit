import 'package:flutter/material.dart';

class topBar extends StatelessWidget {
  //const topBar({Key? key}) : super(key: key);

  final int score;
  final int round;
  final int endRound;

  topBar({required this.score, required this.round, required this.endRound});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$round/$endRound",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            score.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
