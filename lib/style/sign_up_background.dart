import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpBackground extends StatelessWidget {
  final Widget child;
  const SignUpBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: -10,
            child: SvgPicture.asset(
              'assets/images/shapes/shape-gradient-signup-1.svg',
              width: size.width * 0.4,
            ),
          ),
          Positioned(
            bottom: -80,
            child: Image.asset(
              'assets/images/shapes/shape-gradient-signup.jpg',
              width: size.width,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
