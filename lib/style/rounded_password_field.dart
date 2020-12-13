import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onSaved;
  final TextEditingController controller;
  RoundedPasswordField({
    Key key,
    this.onSaved,
    this.controller,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  var _isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value.isEmpty || value.length < 5) {
            return 'Password is too short!';
          }
        },
        onSaved: widget.onSaved,
        obscureText: _isVisible,
        decoration: InputDecoration(
          hintText: 'Your password',
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
