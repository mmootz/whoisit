import 'package:flutter/material.dart';
import 'package:tmdb_game/widgets/confetti.dart';

class winScreen extends StatefulWidget {
  const winScreen({Key? key}) : super(key: key);
  static const routeName = 'winScreen';

  @override
  State<winScreen> createState() => _winScreenState();
}

class _winScreenState extends State<winScreen> {
  // animate this with text widget
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text('Who is it?'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Congratulations!", style: TextStyle(fontSize: 32)),
          Text(
            "Final score:$args",
            style: TextStyle(fontSize: 28),
          ),
        confettiBlast(true)
        ],
          
          )),
    );
  }
}
