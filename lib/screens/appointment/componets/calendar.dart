import 'package:biomaapp/constants.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();
  String selectedMes = '';

  int currentDateSelectedIndex = 0;
  int currentDateSelectedIMes = 0;

  List<String> listOfMonths = [
    "Jan",
    "Fev",
    "Mar",
    "Abr",
    "Mai",
    "Jun",
    "Jul",
    "Aug",
    "Set",
    "Out",
    "Nov",
    "Dez"
  ];

  List<String> listOfDays = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: defaultPadding);
              },
              itemCount: listOfMonths.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentDateSelectedIMes = index;
                      selectedMes = listOfMonths[index];
                      debugPrint(selectedMes);
                    });
                  },
                  child: Container(
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentDateSelectedIMes == index
                          ? primaryColor
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          listOfMonths[index],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 80,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: defaultPadding);
              },
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentDateSelectedIndex = index;
                      selectedDate = DateTime.now().add(Duration(days: index));
                    });
                  },
                  child: Container(
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentDateSelectedIndex == index
                          ? primaryColor
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateTime.now()
                              .add(Duration(days: index))
                              .day
                              .toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: currentDateSelectedIndex == index
                                ? Colors.white
                                : textColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          listOfDays[DateTime.now()
                                      .add(Duration(days: index))
                                      .weekday -
                                  1]
                              .toString(),
                          style: TextStyle(
                            color: currentDateSelectedIndex == index
                                ? Colors.white
                                : textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
