import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {

  final AssetImage backImage;
  final Widget child;

  CardWidget({this.backImage, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backImage,
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.5,
                0.8,
                0.95,
              ],
              colors: [
                Colors.white12,
                Colors.white54,
                Colors.white70,
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
