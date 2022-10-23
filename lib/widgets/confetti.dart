
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
class confettiBlast extends StatefulWidget {
  //const confettiBlast({Key? key}) : super(key: key);
   final shoot;

   confettiBlast(this.shoot);
  @override
  State<confettiBlast> createState() => _confettiBlastState();
}

class _confettiBlastState extends State<confettiBlast> {
  late ConfettiController confetti;

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.shoot ? confetti.play() : null;
    return Align(alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: confetti,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: pi / 2,
        maxBlastForce: 200,
        numberOfParticles: 42,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.red,
          Colors.green,
          Colors.yellow
        ],
      ),);
  }
}
