import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page3State();
}

class _Page3State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 3, 189, 3),
      child: Center(
        child: Text(
          "Page2",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}