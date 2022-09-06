import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/procedimento_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/cart.dart';
import 'package:biomaapp/models/product.dart';
import 'package:biomaapp/utils/app_routes.dart';

class ProcedimentoGridGrupo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProcedimentoList>(context, listen: false);
    final grupos = Provider.of<Grupo>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Column(
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/1273/1273943.png',
                fit: BoxFit.cover,
              ),
              Text(grupos.descricao),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: grupos.descricao,
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Grupo>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () {
                //    product.toggleFavorite(
                //      auth.token ?? '',
                //       auth.userId ?? '',
                //     );
              },
              icon: Icon(Icons.favorite_border),
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            grupos.descricao,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              //  cart.addItem();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Produto adicionado com sucesso!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      cart.removeSingleItem(grupos.descricao);
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
