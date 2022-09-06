import 'package:biomaapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class CalendarioInfor extends StatefulWidget {
  String data;
  String Hora;
  CalendarioInfor({Key? key, required this.data, required this.Hora})
      : super(key: key);

  @override
  State<CalendarioInfor> createState() => _CalendarioInforState();
}

class _CalendarioInforState extends State<CalendarioInfor> {
  @override
  Widget build(BuildContext context) {
    String dtDescritiva = DateFormat("EEEE',\n 'd 'de' MMMM 'de' y", "pt_BR")
        .format(DateTime.parse(widget.data));
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat("d", "pt_BR").format(DateTime.parse(widget.data)),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                color: primaryColor,
                child: SizedBox(
                  width: 20,
                  height: 3,
                ),
              ),
              Text(DateFormat("M", "pt_BR").format(DateTime.parse(widget.data)),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          trailing: Text(widget.Hora + 'h'),
          title: Center(
              child: Text(
            dtDescritiva,
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }
}
