import 'package:flutter/material.dart';

// Had problems with it filling the whole screen
// so set the height on the image
class posterCard extends StatelessWidget {
  //const posterCard({Key? key}) : super(key: key);
  final dynamic moviePoster;

  const posterCard(this.moviePoster);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: Image.network(moviePoster,
          fit: BoxFit.fitHeight,
          height: MediaQuery.of(context).size.height * 0.3),
    );
  }
}
