import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _Page1State();
}

class _Page1State extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          "Page1",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}