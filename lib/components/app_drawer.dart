import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/appointment/meusAgendamentos.dart';
import 'package:biomaapp/screens/appointment/minhasIndicacoes.dart';
import 'package:biomaapp/screens/atendimento/AgendaMedicoScren.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:biomaapp/screens/auth/logar.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_screen.dart';
import 'package:biomaapp/screens/pedidos/navaIndicacao.dart';
import 'package:biomaapp/screens/profile/profile_screen.dart';
import 'package:biomaapp/screens/servicos/ServicosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/localizacaoScreen.dart';
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

    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    if (auth.fidelimax.cpf.isEmpty && auth.isAuth) {
      auth.fidelimax.ConsultaConsumidor().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    Paginas pages = auth.paginas;

    var logar = Logar(fun: () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthOrHomePage(),
        ),
      ).whenComplete(() {
        // setState(() {});
      });
    });

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Drawer(
            // backgroundColor: primaryColor,
            child: Column(
              children: [
                AppBar(
                  title: Column(
                    children: [
                      if (!auth.isAuth)
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Entrar'),
                          onTap: () {
                            Navigator.pop(context);
                            callbackLogin(context, () {
                              //setState(() {});
                            });
                          },
                        ),
                      if (auth.isAuth)
                        Text(
                            'Olá, ${auth.fidelimax.nome.toString().split(' ')[0]}'),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Buscar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthOrHomePage(),
                      ),
                    ).whenComplete(() {
                      setState(() {});
                    });
                    ;
                  },
                ),
                if (false)
                  ListTile(
                    leading: Icon(Icons.search),
                    title: Text('Atendimento'),
                    onTap: () {
                      auth.isAuth
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AgendaMedicoScreen(
                                    press: () {}, refreshPage: () {}),
                              ),
                            ).whenComplete(() {
                              setState(() {});
                            })
                          : showSnackBar(logar, context);
                      ;
                    },
                  ),

                // Divider(),

                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Meus Amigos'),
                  onTap: () {
                    auth.isAuth
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsersPage(press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentScreen(
                                      press: () {},
                                    ),
                                  ),
                                ).whenComplete(() {
                                  setState(() {});
                                });
                              }),
                            ),
                          ).whenComplete(() {
                            setState(() {});
                          })
                        : showSnackBar(logar, context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Links de Indicações'),
                  onTap: () {
                    auth.isAuth
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndicacoesScreen(),
                            ),
                          ).whenComplete(() {
                            setState(() {});
                          })
                        : showSnackBar(logar, context);
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
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Meus Agendamentos'),
                  onTap: () {
                    auth.isAuth
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeusAgendamentos(),
                            ),
                          ).whenComplete(() {
                            setState(() {});
                          })
                        : showSnackBar(logar, context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Minhas Indicações'),
                  onTap: () {
                    auth.isAuth
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MinhasIndicacoes(),
                            ),
                          ).whenComplete(() {
                            setState(() {});
                          })
                        : showSnackBar(logar, context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Meu Perfil'),
                  onTap: () {
                    auth.isAuth
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          ).whenComplete(() {
                            setState(() {});
                          })
                        : showSnackBar(logar, context);
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
                if (auth.isAuth)
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Sair'),
                    onTap: () async {
                      var au = Provider.of<Auth>(
                        context,
                        listen: false,
                      );
                      au.logout().then((value) async {
                        await auth.filtrosativos.LimparTodosFiltros();

                        var regraList = await Provider.of<RegrasList>(
                          context,
                          listen: false,
                        ).limparDados();
                        var dados = await Provider.of<RegrasList>(
                          context,
                          listen: false,
                        ).limparDados();

                        await isLogin(context, () {
                          setState(() {});
                        });
                      });
                    },
                  ),
              ],
            ),
          );
  }
}
