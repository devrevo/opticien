import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 20),
        ),
        textTheme: Typography.blackCupertino,
        backgroundColor: Colors.white,
        shadowColor: Colors.purple[400],
      ),
      body: Container(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              width: double.infinity,
              child: Text(
                'Theme Settings ',
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            color: Colors.deepPurple,
            width: MediaQuery.of(context).size.width - 40,
            height: 0.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _darkMode
                          ? Icon(Icons.brightness_2)
                          : Icon(Icons.wb_sunny),
                      SizedBox(
                        width: 20,
                      ),
                      _darkMode
                          ? Text(
                              'Dark Mode',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16),
                            )
                          : Text(
                              'Light Mode',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16),
                            ),
                    ],
                  ),
                  Platform.isIOS
                      ? CupertinoSwitch(
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() {
                              _darkMode = !_darkMode;
                              if (_darkMode) {
                                final newTextTheme =
                                    Theme.of(context).textTheme.apply(
                                          bodyColor: Colors.white,
                                          displayColor: Colors.grey[400],
                                        );
                              }
                            });
                          })
                      : Switch(
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() {
                              _darkMode = !_darkMode;
                            });
                          })
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
