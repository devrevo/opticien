import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: -80,
            right: -80,
            child: Image.asset(
              'assets/images/shapes/shape-gradient-3.jpg',
              width: size.width * 0.8,
            ),
          ),
          Positioned(
            top: -80,
            left: -80,
            child: Image.asset(
              'assets/images/shapes/shape-gradient-7.jpg',
              width: size.width * 0.8,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
