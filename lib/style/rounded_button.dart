import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.label,
    this.color = Colors.purple,
    @required this.route,
  }) : super(key: key);
  final String label;
  final Color color;
  final Function route;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 40,
          ),
          color: color,
          onPressed: route,
          child: Text(
            label,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
