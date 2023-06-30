import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/constants.dart';
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
import 'package:biomaapp/screens/profile/profile_screen.dart';
import 'package:biomaapp/screens/saude/minhasaudePage.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/screens/user/user_page.dart';
import 'package:biomaapp/screens/vouches/VoucherViwer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';

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
    var regraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    auth.atualizaAcesso(context, () {
      setState(() {});
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    Paginas pages = auth.paginas;

    logar(Widget w) async {
      var lg = await AlertShowDialog('Login necessário', Text(''), context);
      if (lg) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      //  setState(() {});
                      return w;
                    },
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
            ),
          ),
        ).then((value) {
          setState(() {});
        });
      }
    }

    return _isLoading
        ? Center(child: ProgressIndicatorBioma())
        : SafeArea(
            child: Drawer(
              // backgroundColor: primaryColor,
              child: Column(
                children: [
                  if (!auth.isAuth)
                    Logar(
                        fun: () {
                          setState(() {});
                        },
                        widAtual: AuthOrHomePage()),
                  if (auth.isAuth)
                    UserCard(user: auth.fidelimax.usuario, press: () {}),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: primaryColor,
                    ),
                    title: Text('Home'),
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
                  if (auth.isAuth)
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: redColor,
                      ),
                      title: Text('Gerar Voucher'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VoucherViwer(),
                          ),
                        ).whenComplete(() {
                          setState(() {});
                        });
                        ;
                      },
                    ),

                  if (true)
                    ListTile(
                      leading: Icon(Icons.search, color: primaryColor),
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
                            : logar(AgendaMedicoScreen(
                                press: () {}, refreshPage: () {}));
                        ;
                      },
                    ),

                  // Divider(),

                  ListTile(
                    leading:
                        Icon(Icons.monitor_heart_outlined, color: primaryColor),
                    title: Text('Minha Saúde'),
                    onTap: () {
                      auth.isAuth
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MinhaSaudePage(),
                              ),
                            ).whenComplete(() {
                              setState(() {});
                            })
                          : logar(MinhaSaudePage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: primaryColor),
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
                          : logar(UsersPage(press: () {
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
                            }));
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.share, color: primaryColor),
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
                          : logar(IndicacoesScreen());
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
                    leading: Icon(Icons.calendar_month, color: primaryColor),
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
                          : logar(MeusAgendamentos());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: primaryColor),
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
                          : logar(MinhasIndicacoes());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: primaryColor),
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
                          : logar(ProfileScreen());
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
                      leading: Icon(Icons.exit_to_app, color: primaryColor),
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
            ),
          );
  }
}
