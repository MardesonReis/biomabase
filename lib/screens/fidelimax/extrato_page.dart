import 'package:biomaapp/screens/fidelimax/ExtratoWidget.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/extrato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExtratoPage extends StatefulWidget {
  @override
  State<ExtratoPage> createState() => _ExtratoPageState();
}

class _ExtratoPageState extends State<ExtratoPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<Auth>(
      context,
      listen: false,
    ).fidelimax.ExtratoConsumidor().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context).fidelimax;
    //final es = provider.ExtratoConsumidor();
    final List<Extrato> loadedExtrato = provider.extrato;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Extrato'),
      ),
      //drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: loadedExtrato.length,
              itemBuilder: (ctx, i) => ExtratoWidget(extrato: loadedExtrato[i]),
            ),
    );
  }
}
