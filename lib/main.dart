import 'package:admin_store/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(AdminStore());

class AdminStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Admin Store",
      home: LoginScreen(),
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
      ),
    );
  }
}
