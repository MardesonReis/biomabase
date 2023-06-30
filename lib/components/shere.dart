import 'package:flutter/material.dart';

class Shere extends StatefulWidget {
  @override
  _ShereState createState() => _ShereState();
}

class _ShereState extends State<Shere> {
  @override
  void initState() {
    super.initState();
  }

  var list = [];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(list.length, (index) => list[index]),
    );
  }
}
