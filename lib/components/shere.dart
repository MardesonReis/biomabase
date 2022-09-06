import 'dart:io';

import 'package:biomaapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
