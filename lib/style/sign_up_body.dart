import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/modals/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/login_screen.dart';
import 'package:shop_app/screens/products_overview.dart';
import 'package:shop_app/style/rounded_button.dart';
import 'package:shop_app/style/rounded_confirmation_password.dart';
import 'package:shop_app/style/rounded_input_field.dart';
import 'package:shop_app/style/rounded_password_field.dart';
import 'package:shop_app/style/sign_up_background.dart';
import 'package:shop_app/style/social_icon.dart';

import 'or_divider.dart';

class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _isLoading = true;
    Map<String, String> _authData = {
      'email': '',
      'password': '',
    };

    Future<void> _showErrorDialog(String message) async {
      showDialog(
          context: context,
          builder: (ctx) {
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    content: Text(message),
                    title: Text('An error occured!'),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text('Okey'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                      ),
                    ],
                  )
                : AlertDialog(
                    content: Text(message),
                    title: Text('An error occured!'),
                    actions: [
                      FlatButton(
                        child: Text('Okey'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                      ),
                    ],
                  );
          });
    }

    Future<void> _submit() async {
      if (!_formKey.currentState.validate()) {
        // Invalid!
        return;
      }
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final prov = Provider.of<Auth>(context);

        await prov.signup(_authData['email'], _authData['password']);
      } on HttpException catch (error) {
        print(error.toString());
        var message = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          message = "This email address is already used";
        } else if (error.toString().contains('INVALID_EMAIL')) {
          message = "This email address is invalid";
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          message = "This password is too weak";
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          message = "Could not find a user with this email";
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          message = "Invalid password";
        }
        await _showErrorDialog(message);
      } catch (error) {
        print(error.toString());
        const message = 'Could not authentitcate you';
        await _showErrorDialog(message);
      }
      setState(() {
        _isLoading = false;
      });
    }

    Size size = MediaQuery.of(context).size;
    return Container(
      child: SignUpBackground(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: PageScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SIGN UP',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/shapes/shop-logo-3.png',
                  width: size.width * 0.7,
                ),
                RoundedInputField(
                  controller: _emailController,
                  hintText: 'Your email',
                  icon: Icons.person,
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                RoundedPasswordField(
                  controller: _passwordController,
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                RoundedConfirmationPasswordField(
                  controller: _passwordController,
                ),
                SizedBox(
                  height: 5,
                ),
                RoundedButton(label: 'SIGN UP', route: _submit),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (_) {
                          return LoginScreen();
                        }));
                      },
                      child: Text(
                        'Log in.',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIcon(
                      imageAsset: 'assets/images/socialmedia/facebook.png',
                      onTap: () {},
                    ),
                    SocialIcon(
                      imageAsset: 'assets/images/socialmedia/twitter.png',
                      onTap: () {},
                    ),
                    SocialIcon(
                      imageAsset: 'assets/images/socialmedia/google-plus.png',
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
