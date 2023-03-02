import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProgressIndicatorBioma extends StatelessWidget {
  const ProgressIndicatorBioma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/imagens/carregando.gif', // Put your gif into the assets folder
            width: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
      ),
    );
  }
}
