import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  final Widget child;
  const WelcomeBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: -60,
            top: -60.0,
            child: Image.asset(
              'assets/images/shapes/shape-gradient-1.png',
              width: size.width * 0.6,
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60.0,
            child: Image.asset(
              'assets/images/shapes/shape-gradient-2.png',
              width: size.width * 0.7,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
