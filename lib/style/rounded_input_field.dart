import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onSaved;
  final TextEditingController controller;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onSaved,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty || !value.contains('@')) {
            return 'Invalid email!';
          }
        },
        controller: controller,
        onSaved: onSaved,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
