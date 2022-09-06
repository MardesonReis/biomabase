import 'package:badges/badges.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fila_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/appointment/componets/FilaDeAgendamentos.dart';
import 'package:biomaapp/screens/appointment/componets/FilaDeSolicitacoes.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/pedidos/components/agendar_list.dart';
import 'package:biomaapp/screens/pedidos/components/indicacar_list.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/screens/user/components/user_screen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/order.dart';
import 'package:biomaapp/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  Clips menu;
  OrdersPage(this.menu);
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _expanded = false;
  var msg = '';
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    FilaList filaList = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    var isError;

    filtros.BuscarFiltrosAtivos();
    Paginas pages = auth.paginas;
    var menu = [
      Clips(titulo: 'Agendar', subtitulo: '', keyId: 'A'),
      Clips(titulo: 'Solicitar', subtitulo: '', keyId: 'S'),
    ];

    var agendados = auth.filtrosativos.fila
        .where((element) => element.status == widget.menu.keyId)
        .toList();

    double total = 0;
    agendados
        .map((e) =>
            e.procedimento.quantidade == '2' && e.procedimento.olho == 'A'
                ? total += 2 * e.procedimento.valor
                : total += e.procedimento.valor)
        .toList();

    return Scaffold(
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: agendados.isNotEmpty && widget.menu.keyId == 'S',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  focusColor: redColor,
                  splashColor: redColor,
                  extendedIconLabelSpacing: 1,
                  label: const Text('Gerar Indicação:',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  icon: widget.menu.keyId == 'A'
                      ? Icon(Icons.person)
                      : Icon(Icons.share),
                  backgroundColor: Colors.green,
                  elevation: 8,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndicarList(
                          fila: agendados,
                        ),
                      ),
                    ).then((value) => {
                          setState(() {}),
                        });
                    // Add your onPressed code here!
                  },
                ),
              ),
            ),
            Visibility(
              visible: agendados.isNotEmpty && widget.menu.keyId == 'A',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  focusColor: redColor,
                  splashColor: redColor,
                  extendedIconLabelSpacing: 1,
                  label: const Text('Finalizar',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  icon: widget.menu.keyId == 'A'
                      ? Icon(Icons.calendar_month)
                      : Icon(Icons.share),
                  backgroundColor: primaryColor,
                  elevation: 8,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgendarList(
                          fila: agendados,
                        ),
                      ),
                    ).then((value) => {
                          setState(() {}),
                        });
                    // Add your onPressed code here!
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: true,
                child: FloatingActionButton.extended(
                  focusColor: redColor,
                  splashColor: redColor,
                  extendedIconLabelSpacing: 1,
                  label: const Text('Adicionar',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  icon: const Icon(Icons.add_circle_outline),
                  backgroundColor: primaryColor,
                  elevation: 8,
                  onPressed: () {
                    filtros.medicos.isNotEmpty
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailsScreen(
                                doctor: filtros.medicos.first,
                                press: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          ).then((value) => {
                              setState(() {}),
                            })
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthOrHomePage(),
                              ),
                            );
                          }.call();
                    // Add your onPressed code here!
                  },
                ),
              ),
            ),
          ],
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: CustomAppBar('Fila de \n', 'Procedimentos', () {}, [])),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: List.generate(
                  menu.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(15),
                    child: Badge(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                widget.menu = menu[index];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Text(menu[index].titulo,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: menu[index] == widget.menu
                                          ? primaryColor
                                          : Colors.black)),
                            ),
                          ),
                          Container(
                            color: menu[index] == widget.menu
                                ? primaryColor
                                : Colors.white,
                            width: 50,
                            height: 2,
                          )
                        ],
                      ),
                      showBadge: filtros.fila
                          .where(
                              (element) => element.status == menu[index].keyId)
                          .toList()
                          .isNotEmpty,
                      toAnimate: true,
                      shape: BadgeShape.square,
                      //   ignorePointer: true,
                      badgeColor: redColor,
                      borderRadius: BorderRadius.circular(100),
                      position: BadgePosition.topEnd(top: -10, end: -20),
                      badgeContent: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(filtros.fila
                            .where((element) =>
                                element.status == menu[index].keyId)
                            .toList()
                            .length
                            .toString()),
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        label: Text(
                          'R\$ ${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                ?.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  //  physics: NeverScrollableScrollPhysics(),
                  child: agendados.isNotEmpty
                      ? Column(
                          children: [
                            widget.menu.keyId == 'A'
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    //  physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: agendados.length,
                                    itemBuilder: (ctx, i) => FilaAgendamentos(
                                      fila: agendados[i],
                                      press: () {
                                        setState(() {
                                          filtros.removerFila(
                                              auth.filtrosativos.fila[i]);
                                        });
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            widget.menu.keyId == 'S'
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: agendados.length,
                                    itemBuilder: (ctx, i) => FilaSolicitacaoes(
                                      fila: agendados[i],
                                      press: () {
                                        setState(() {
                                          filtros.removerFila(
                                              auth.filtrosativos.fila[i]);
                                        });
                                      },
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildInfoPage(
                              'Fila está vazia!',
                              'Para adicionar procedimentos clique no botão adicionar abaixo',
                              Icon(
                                Icons.clear,
                                color: redColor,
                                size: 30,
                              )),
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}
