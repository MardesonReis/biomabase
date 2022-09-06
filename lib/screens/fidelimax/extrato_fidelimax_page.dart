import 'package:biomaapp/screens/fidelimax/extrato_fidelimax.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/extrato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/components/product_grid_item.dart';
import 'package:biomaapp/models/product.dart';
import 'package:biomaapp/models/product_list.dart';

class ExtratoFidelimax extends StatefulWidget {
  @override
  State<ExtratoFidelimax> createState() => _ExtratoFidelimaxState();
}

class _ExtratoFidelimaxState extends State<ExtratoFidelimax> {
  bool _showFavoriteOnly = false;

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

  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context).fidelimax;
    final List<Extrato> loadedProducts = provider.extrato;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: loadedProducts.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: loadedProducts[i],
              child: ExtartoListItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
