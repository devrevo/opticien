import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedConfirmationPasswordField extends StatefulWidget {
  final TextEditingController controller;
  RoundedConfirmationPasswordField({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _RoundedConfirmationPasswordFieldState createState() =>
      _RoundedConfirmationPasswordFieldState();
}

class _RoundedConfirmationPasswordFieldState
    extends State<RoundedConfirmationPasswordField> {
  var _isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (value) {
          if (value != widget.controller.text) {
            return 'Passwords do not match!';
          }
        },
        obscureText: _isVisible,
        decoration: InputDecoration(
          hintText: 'Confirm password',
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            icon: Icon(
              _isVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
