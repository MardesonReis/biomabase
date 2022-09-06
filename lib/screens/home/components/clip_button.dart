import 'package:flutter/material.dart';

class myclip extends StatefulWidget {
  myclip({this.title = ''});

  final String title;

  @override
  _myclip createState() => _myclip();
}

class _myclip extends State<myclip> {
  List<String> programmingList = [
    "Fluuter Tutorial",
    "Java",
    "PHP",
    "C++",
    "Fluuter Tutorial",
    "Java",
    "PHP",
    "C++",
    "Fluuter Tutorial",
    "Java",
    "PHP",
    "C++",
    "Fluuter Tutorial",
    "Java",
    "PHP",
    "C++",
    "Fluuter Tutorial",
    "Java",
    "PHP",
    "C++",
    "Fluuter Tutorial",
    "Java",
    "PHP",
    "C++",
    "Fluuter Tutorial",
    "Java",
    "PHP",
    "C++",
    "C"
  ];

  List<String> selectedProgrammingList = [];

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Flutter Choice Chip"),
            content: MultiSelectChip(
              programmingList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedProgrammingList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Report"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("Multi Select Chip Click"),
            onPressed: () => _showDialog(),
          ),
          Text(selectedProgrammingList.join(", ")),
        ],
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      clipBehavior: Clip.none,
      children: _buildChoiceList(),
    );
  }
}
