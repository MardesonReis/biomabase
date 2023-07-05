import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Voucher.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/voucher_list.dart';
import 'package:biomaapp/screens/vouches/ListaVoucherViwer.dart';
import 'package:biomaapp/screens/vouches/VoucherCriador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

class VouchersPage extends StatefulWidget {
  @override
  State<VouchersPage> createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage>
    with RouteAware, RouteObserverMixin {
  bool isloading = true;

  void initState() {
    CarregarVocuhes().then((value) {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  void didPopNext() {
    CarregarVocuhes().then((value) {
      setState(() {
        isloading = false;
      });
    });
  }

  /// Chamado quando a rota atual foi enviada.
  @override
  void didPush() {
    CarregarVocuhes().then((value) {
      setState(() {
        isloading = false;
      });
    });
  }

  /// Chamado quando a rota atual foi retirada.
  @override
  void didPop() {}

  /// Chamado quando uma nova rota foi enviada e a rota atual não é
  /// longer visible.
  @override
  void didPushNext() {
    CarregarVocuhes().then((value) {
      setState(() {
        isloading = false;
      });
    });
  }

  Future<void> CarregarVocuhes() async {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var GestorDeVoucher = Provider.of<VoucherList>(
      context,
      listen: false,
    );
    setState(() {
      isloading = true;
    });
    if (GestorDeVoucher.items.isEmpty) {
    } else {}
    GestorDeVoucher.loadDados(auth.fidelimax.usuario).then((value) {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Group vouchers by status
    Auth auth = Provider.of(context);
    VoucherList vouchersLista = Provider.of(context);
    List<Voucher> vouchers = vouchersLista.items;
    Map<String, List<Voucher>> groupedVouchers = {};
    vouchers.forEach((voucher) {
      if (groupedVouchers.containsKey(voucher.status)) {
        groupedVouchers[voucher.code]!.add(voucher);
      } else {
        groupedVouchers[voucher.code] = [voucher];
      }
    });

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            size: 32, //change size on your need
            color: destColor,

            //change color on your need
            shadows: [
              Shadow(blurRadius: 3.0, color: Colors.grey, offset: Offset.zero)
            ]),
        title: Text('Vouchers'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VocuherCriador(),
                  ),
                ).whenComplete(() {
                  setState(() {});
                });
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupedVouchers.length,
              itemBuilder: (BuildContext context, int index) {
                String status = groupedVouchers.keys.elementAt(index);
                List<Voucher> vouchersByStatus = groupedVouchers[status]!;

                return ExpansionTile(
                  title: Text('Voucher: $status'),
                  //   subtitle: Text('Status:'+vouchersByStatus[index].servicos.length.toString()),
                  children: vouchersByStatus.map((voucher) {
                    return ListTile(
                      title: Text('ID: ${voucher.id}'),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: voucher.servicos
                              .map((e) => Text(e.des_procedimento))
                              .toList()),
                      onTap: () {
                        // Handle voucher selection
                        print('Selected voucher: ${voucher.id}');
                      },
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              isloading = true;
                            });
                            Navigator.of(context)
                                .push(new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      bool isloading = false;
                                      return ListVoucheViwer(
                                        vouchers: vouchers
                                            .where((element) =>
                                                element.code == voucher.code)
                                            .toList(),
                                        salvar: false,
                                      );
                                    },
                                    fullscreenDialog: true))
                                .then((value) {
                              setState(() {});
                            });
                          },
                          icon: Icon(Icons.picture_as_pdf)),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
