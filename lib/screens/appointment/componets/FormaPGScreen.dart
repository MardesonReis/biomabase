import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/formaPG_list.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/home/components/card_especialidades.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class FormaPGScreen extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  FormaPGScreen({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<FormaPGScreen> createState() => _FormaPGScreenState();
}

class _FormaPGScreenState extends State<FormaPGScreen> {
  bool _isLoading = true;
  double sliderValue = 0;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    if (!mounted) return;
    FormaPgList pgList = Provider.of<FormaPgList>(
      context,
      listen: false,
    );
    pgList.loadFormasPg().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FormaPgList pgList = Provider.of(context, listen: false);
    Auth auth = Provider.of(context, listen: false);

    final dados = pgList.items;
    var isError;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('', 'Pagamento', () {}, [])),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.only(top: 100, bottom: 1, left: 1, right: 1),
              child: Container(
                //  height: MediaQuery.of(context).size.height - 200,
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    pgList.loadFormasPg().then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Você pode trocar seu Bions e usar como quiser',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                  'Saldo em Bions',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  (auth.fidelimax.saldo - sliderValue)
                                      .toStringAsFixed(0),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Spacer(),
                            Divider(height: 100, color: primaryColor),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                  'Saldo em R\$',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    'R\$ ' +
                                        (sliderValue * BiosTaxa)
                                            .toStringAsFixed(0),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                        Slider(
                          value: sliderValue,
                          min: 0,
                          thumbColor: Colors.yellow,
                          activeColor: Colors.yellow,
                          divisions: (auth.fidelimax.saldo * BiosTaxa).toInt(),
                          max: auth.fidelimax.saldo,
                          onChanged: (double value) {
                            setState(() {
                              sliderValue = value;
                            });
                          },
                          //         divisions: 1800,

                          label: '$sliderValue',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SectionTitle(
                            title: "Formas de Pagamento",
                            pressOnSeeAll: () {},
                            OnSeeAll: false,
                          ),
                        ),
                        if (dados.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: List.generate(
                                dados.length,
                                (index) => ListTile(
                                  selected: auth.filtrosativos.FormaPg
                                      .contains(dados[index]),
                                  onTap: () {
                                    auth.filtrosativos.LimparFormaPg();
                                    auth.filtrosativos.addFormaPg(dados[index]);
                                    setState(() {
                                      widget.press.call();
                                    });
                                  },
                                  leading: CircleAvatar(
                                    radius: 15,
                                    onBackgroundImageError: (_, __) {
                                      setState(() {
                                        isError = true;
                                      });
                                    },
                                    child: isError == true
                                        ? Text(dados[index].formapgto[0])
                                        : SizedBox(),
                                    backgroundImage: NetworkImage(
                                      Constants.IMG_FORMA_PG +
                                          dados[index].codforma +
                                          '.png',
                                      scale: 15,
                                    ),
                                  ),
                                  title: Text(dados[index].formapgto),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
