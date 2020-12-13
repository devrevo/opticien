import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.width * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: [
          buildDivider(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'OR',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          buildDivider(context),
        ],
      ),
    );
  }

  Expanded buildDivider(BuildContext context) {
    return Expanded(
      child: Divider(
        color: Theme.of(context).accentColor,
        height: 1.5,
      ),
    );
  }
}
