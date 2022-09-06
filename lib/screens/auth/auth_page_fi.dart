import 'dart:math';

import 'package:biomaapp/screens/auth/components/auth_form_fi.dart';
import 'package:flutter/material.dart';

class AuthPageFi extends StatelessWidget {
  const AuthPageFi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 0.5),
                      Color.fromRGBO(255, 188, 117, 0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Text(
                        'Continuação do Cadastro',
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'Anton',
                          color: Theme.of(context).textTheme.headline6?.color,
                        ),
                      ),
                    ),
                    Container(child: AuthFormFi()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

// Exemplo usado para explicar o cascade operator
// void main() {
//   List<int> a = [1, 2, 3];
//   a.add(4);
//   a.add(5);
//   a.add(6);
  
//   // cascade operator!
//   a..add(7)..add(8)..add(9);
  
//   print(a);
// }

