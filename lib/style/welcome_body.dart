import 'package:flutter/material.dart';
import 'package:shop_app/screens/login_screen.dart';
import 'package:shop_app/screens/sign_up_screen.dart';
import 'package:shop_app/style/welcome_background.dart';
import 'package:shop_app/style/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir Next',
                  ),
                ),
                Text(
                  'Revo Store',
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bright Sunshine',
                      fontSize: 40),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/images/shapes/shop-logo.jpg',
            width: size.width * 0.8,
          ),
          SizedBox(
            height: 30,
          ),
          RoundedButton(
            label: 'LOGIN',
            route: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return LoginScreen();
              }));
            },
          ),
          SizedBox(
            height: 10,
          ),
          RoundedButton(
            label: 'SIGNUP',
            color: Theme.of(context).accentColor,
            route: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SignUpScreen();
              }));
            },
          ),
        ],
      ),
    );
  }
}
