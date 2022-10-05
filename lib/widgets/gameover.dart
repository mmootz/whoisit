import 'package:flutter/material.dart';

class gameOver extends StatelessWidget {
//  const gameOver({Key? key}) : super(key: key);

  final Map answers;
  gameOver(this.answers);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView.builder(
      itemCount: answers.length,
      itemBuilder: (BuildContext context, int index) {
        String answer = answers[index]['answer']  == true  ? "✅" : "❌";
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(answers[index]['name']),
                  Text(answer)
                ],
              ),
            ],
          ),
        );
      },
    ));
  }
}
