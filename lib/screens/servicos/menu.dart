import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/appointment/meusAgendamentos.dart';
import 'package:biomaapp/screens/appointment/minhasIndicacoes.dart';
import 'package:biomaapp/screens/auth/auth_page.dart';
import 'package:biomaapp/screens/home/components/available_doctors.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_screen.dart';
import 'package:biomaapp/screens/saude/minhasaudePage.dart';
import 'package:biomaapp/screens/user/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
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

    return ListView.builder(
      scrollDirection: Axis.vertical,
      // controller: scroll_controller,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Icon(
              Icons.monitor_heart_outlined,
              color: Colors.white,
            ),
            Text('Minha Saúde',
                style: TextStyle(
                  color: Colors.white,
                )),
          ],
        );
      },
    );
    Container(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Wrap(
            children: [
              Card(
                color: primaryColor,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: Column(
                        children: [
                          Icon(
                            Icons.monitor_heart_outlined,
                            color: Colors.white,
                          ),
                          Text('Minha Saúde',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () {
                    auth.isAuth
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MinhaSaudePage(),
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
              ),
              Card(
                color: primaryColor,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: Column(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          Text('Meus Amigos',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () {
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
              ),
              Card(
                color: primaryColor,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: Column(
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          Text('Links',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () {
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
              ),
              Card(
                color: primaryColor,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          Text('Agendamentos',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () {
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
              ),
              Card(
                color: primaryColor,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          Text('Indicações',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () {
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
              ),
            ],
          ),
          AvailableDoctors(),
        ],
      ),
    );
  }
}
