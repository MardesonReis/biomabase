import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/search_form.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Busque um",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              Text(
                "Especialista",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: defaultPadding),
              SearchForm(),
            ],
          ),
        ),
      ),
    );
  }
}
