import 'package:biomaapp/models/extrato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/cart.dart';
import 'package:biomaapp/models/product.dart';
import 'package:biomaapp/utils/app_routes.dart';

class ExtartoListItem extends StatefulWidget {
  @override
  State<ExtartoListItem> createState() => _ExtartoListItemState();
}

class _ExtartoListItemState extends State<ExtartoListItem> {
  //  final product = Provider.of<Extrato>(context, listen: false);
  // final cart = Provider.of<Cart>(context, listen: false);
  //final auth = Provider.of<Auth>(context, listen: false);

  Widget build(BuildContext context) {
    bool _showFavoriteOnly = false;

    bool _isLoading = false;
    final product = Provider.of<Extrato>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
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

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              child: GestureDetector(
                child: Image.network(
                  product.credito.toString(),
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PRODUCT_DETAIL,
                    arguments: product,
                  );
                },
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black87,
                leading: Consumer<Product>(
                  builder: (ctx, product, _) => IconButton(
                    onPressed: () {
                      product.toggleFavorite(
                        auth.token ?? '',
                        auth.userId ?? '',
                      );
                    },
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).accentColor,
                  ),
                ),
                title: Text(
                  product.credito.toString(),
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    // cart.addItem(product);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Produto adicionado com sucesso!'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'DESFAZER',
                          onPressed: () {
                            cart.removeSingleItem(product.credito.toString());
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
