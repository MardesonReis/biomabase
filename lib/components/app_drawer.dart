import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/pedidos/navaIndicacao.dart';
import 'package:biomaapp/screens/user/components/user_screen.dart';
import 'package:biomaapp/screens/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/utils/app_routes.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isLoading = true;
  void initState() {
    super.initState();

    Provider.of<Auth>(
      context,
      listen: false,
    ).fidelimax.ConsultaConsumidor().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    Paginas pages = auth.paginas;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Drawer(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                      'Olá, ${auth.fidelimax.nome.toString().split(' ')[0]}'),
                  automaticallyImplyLeading: false,
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Buscar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthOrHomePage(),
                      ),
                    );
                  },
                ),

                // Divider(),

                Divider(),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Meus Amigos'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersPage(),
                      ),
                    );
                  },
                ),
                // Divider(),
                // ListTile(
                //   leading: Icon(Icons.search),
                //   title: Text('Buaca Rápida'),
                //   onTap: () {
                //     Navigator.of(context).pushReplacementNamed(
                //       AppRoutes.BuscaRapida,
                //     );
                //   },
                // ),
                // Divider(),
                // ListTile(
                //   leading: Icon(Icons.search),
                //   title: Text('Especialistas'),
                //   onTap: () {
                //     Navigator.of(context).pushReplacementNamed(
                //       AppRoutes.DoctorsScreen,
                //     );
                //   },
                // ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Agendamentos'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.ORDERS,
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Shere'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.Shere,
                    );
                  },
                ),
                // Divider(),
                // ListTile(
                //   leading: Icon(Icons.edit),
                //   title: Text('Gerenciar Produtos'),
                //   onTap: () {
                //     Navigator.of(context).pushReplacementNamed(
                //       AppRoutes.PRODUCTS,
                //     );
                //   },
                // ),

                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sair'),
                  onTap: () {
                    Provider.of<Auth>(
                      context,
                      listen: false,
                    ).logout();

                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.AUTH_OR_HOME,
                    );
                  },
                ),
              ],
            ),
          );
  }
}
