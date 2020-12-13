import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/products_overview.dart';
import 'package:shop_app/screens/sign_up_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/style/login_background.dart';
import 'package:shop_app/style/rounded_button.dart';

import 'rounded_input_field.dart';
import 'rounded_password_field.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({
    Key key,
  }) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _emailcontroller = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
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
      await prov.login(_authData['email'], _authData['password']);
      Navigator.of(context)
          .pushReplacementNamed(ProductOverViewScreen.routeName);
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

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LOGIN',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SvgPicture.asset(
                'assets/images/shapes/login-1.svg',
                width: size.width * 0.7,
              ),
              RoundedInputField(
                controller: _emailcontroller,
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
              SizedBox(
                height: 5,
              ),
              RoundedButton(label: 'LOGIN', route: _submit),
              SizedBox(
                height: size.height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account ?',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (_) {
                        return FutureBuilder(builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SplashScreen();
                          }
                          return SignUpScreen();
                        });
                      }));
                    },
                    child: Text(
                      'Sign up.',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
