import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {

  final String tag;
  final AssetImage backImage;
  final Widget child;
  final Size cardSize;

  CardWidget({this.tag, this.backImage, this.child, this.cardSize});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          width: cardSize.width,
          height: cardSize.height,
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
      ),
    );
  }
}
