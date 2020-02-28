import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({this.backImage, this.child, this.onTap});

  final AssetImage backImage;
  final Widget child;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
      ),
    );
  }
}
