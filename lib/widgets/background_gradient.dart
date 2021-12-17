import 'package:flutter/material.dart';
class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF004e92),
            Color(0xFF0C1674),
            Color(0xFF000428),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
    );
  }
}
