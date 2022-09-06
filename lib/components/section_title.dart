import 'package:flutter/material.dart';

import '../constants.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final VoidCallback pressOnSeeAll;
  final bool OnSeeAll;

  const SectionTitle({
    Key? key,
    required this.title,
    required this.pressOnSeeAll,
    required this.OnSeeAll,
  }) : super(key: key);

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: primaryColor[100],
      title: Text(widget.title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      trailing: widget.OnSeeAll
          ? TextButton(
              child: Text(
                'Ver todos',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                setState(() {
                  widget.pressOnSeeAll.call();
                });
              })
          : Text(''),
    );
  }
}
