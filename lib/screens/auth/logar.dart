import 'package:biomaapp/constants.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Logar extends StatefulWidget {
  VoidCallback fun;
  Widget widAtual;
  Logar({Key? key, required this.fun, required this.widAtual})
      : super(key: key);

  @override
  State<Logar> createState() => _LogarState();
}

class _LogarState extends State<Logar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: destColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              textResp('Login Necessário'),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthPage(
                          func: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  //  setState(() {});
                                  return widget.widAtual;
                                },
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }
}
