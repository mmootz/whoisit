import 'package:flutter/material.dart';

class answerButtons extends StatelessWidget {

  final List guesses;
  final VoidCallback right;
  final VoidCallback wrong;
  final String picked;

  answerButtons(
      {required this.guesses, required this.right, required this.wrong, required this.picked});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: guesses.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                    onPressed:
                    guesses[index] == picked
                        ? right
                        : wrong,
                    child: Text(guesses[index])),
              )
            ],
          );
        },
      ),
    );
  }
}
