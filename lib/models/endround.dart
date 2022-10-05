
import 'dart:ui';

class endRound {
  final int score;
  final bool perfectRound;
  final int bonus;
  final Map answers;
  final VoidCallback resetQuiz;
  final VoidCallback nextSet;

  endRound(this.score, this.answers, this.bonus, this.nextSet,
      this.perfectRound, this.resetQuiz);
}