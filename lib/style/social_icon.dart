import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialIcon extends StatelessWidget {
  final String imageAsset;
  final Function onTap;
  const SocialIcon({
    Key key,
    @required this.imageAsset,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).primaryColor,
          ),
          shape: BoxShape.circle,
        ),
        child: imageProvider(),
      ),
    );
  }

  Widget imageProvider() {
    if (imageAsset.endsWith('png') || imageAsset.endsWith('jpg')) {
      return Image.asset(
        imageAsset,
        height: 20,
        width: 20,
      );
    } else {
      return SvgPicture.asset(
        imageAsset,
        height: 15,
        width: 15,
      );
    }
  }
}
