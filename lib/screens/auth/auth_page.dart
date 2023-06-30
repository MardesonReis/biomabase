import 'dart:math';

import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/auth/components/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  VoidCallback func;
  AuthPage({Key? key, required this.func}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    // if (!mounted) return;

    super.initState();

    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    if (auth.isAuth) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            //  setState(() {});
            return AuthOrHomePage();
          },
        ),
      ).then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return Container(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: CustomAppBar('Acesso ao \n', ' Bioma', () {}, []),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  Colors.white,
                  // Colors.white,
                  destColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        // cascade operator

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          child: new Image.asset(
                            'assets/imagens/bioma_logo.png',
                            fit: BoxFit.contain,
                          ),
                          width: 200,
                        ),
                      ),
                      AuthForm(func: () {
                        widget.func.call();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

