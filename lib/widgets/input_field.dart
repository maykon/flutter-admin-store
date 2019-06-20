import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  const InputField(
      {Key key,
      @required this.hint,
      this.icon,
      this.obscure = false,
      @required this.stream,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.white),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pinkAccent),
            ),
            contentPadding: EdgeInsets.only(
              left: 5,
              right: 15,
              bottom: 15,
              top: 15,
            ),
            errorText: snapshot.hasError ? snapshot.error : null,
          ),
          style: TextStyle(color: Colors.white),
          obscureText: obscure,
        );
      },
    );
  }
}
