import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

// Had problems with it filling the whole screen
// so set the height on the image
class posterCard extends StatelessWidget {
  //const posterCard({Key? key}) : super(key: key);
  final dynamic moviePoster;

  posterCard(this.moviePoster);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        // child: ImageNetwork(debugPrint: true,
        //   image: moviePoster,
        //   fitAndroidIos: BoxFit.fitHeight,
        //   fitWeb: BoxFitWeb.contain,
        //   height: MediaQuery.of(context).size.height * 0.3,
        //   width: MediaQuery.of(context).size.width * 0.3,
        // )
        //
        child: Image.network(moviePoster,
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * 0.3 ),
        );
  }
}
