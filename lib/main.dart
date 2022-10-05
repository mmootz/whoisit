import 'package:flutter/material.dart';
import 'screens/quiz.dart';
import 'screens/endScreen.dart';
import 'screens/mainmenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Who is it?',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who is it?',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.lightBlueAccent)),
      home: mainMenu(),
      initialRoute: 'mainMenu',
      routes: {
        'mainMenu': (ctx) => mainMenu(),
        'quiz': (ctx) => quiz(),
        'endScreen': (ctx) => endScreen()

      },
    );
  }
}
