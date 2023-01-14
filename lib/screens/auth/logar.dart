import 'package:biomaapp/constants.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Logar extends StatefulWidget {
  VoidCallback fun;
  Logar({Key? key, required this.fun}) : super(key: key);

  @override
  State<Logar> createState() => _LogarState();
}

class _LogarState extends State<Logar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: redColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Login Necessário'),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    callbackLogin(context, () {
                      //  setState(() {});
                    });
                  },
                  child: Text(
                    'Logar',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }
}
