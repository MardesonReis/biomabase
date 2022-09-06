import 'dart:math';

import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/screens/auth/components/auth_form_fi.dart';
import 'package:biomaapp/screens/user/components/form_indicar_user.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text('Indique um amigo'),
        )),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Stack(
                children: [
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
                            'Nosso Bioma fica melhor com amigos',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(child: FormIndicaUser()),
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

