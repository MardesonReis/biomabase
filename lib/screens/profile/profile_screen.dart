import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/fidelimax/card_fidelimax.dart';
import 'package:biomaapp/screens/home/components/meu_bioma.dart';
import 'package:biomaapp/screens/profile/componets/dadosPerfil.dart';
import 'package:biomaapp/screens/profile/permicoes_screen.dart';
import 'package:biomaapp/screens/settings/settings_screen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;

  @override
  initState() {
    isLogin(context, () {
      setState(() {});
    });
    //fidelimax.ConsultaConsumidor(fidelimax.cpf);
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    auth.fidelimax.RetornaDadosCliente(auth.fidelimax.cpf).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;

    filtrosAtivos filtros = auth.filtrosativos;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Meu\n', 'Perfil', () {}, [])),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: ProgressIndicatorBioma(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: defaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                          AppRoutes.ImageUpload,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 8,
                          child: Padding(
                              padding: EdgeInsets.all(3),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    Constants.IMG_USUARIO +
                                        fidelimax.cpf +
                                        '.jpg'),
                              )),
                        ),
                      ),
                      SizedBox(width: defaultPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fidelimax.nome,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            auth.email.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            auth.fidelimax.cpf.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.62),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PermicoesScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.more_vert)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: defaultPadding),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DadosInfor(),
                  )),
                  SizedBox(height: defaultPadding),
                  SectionTitle(
                    title: ('Amigos').capitalize(),
                    pressOnSeeAll: () {},
                    OnSeeAll: true,
                  ),
                  SizedBox(height: defaultPadding),
                  SectionTitle(
                    title: ('Meu Bioma').capitalize(),
                    pressOnSeeAll: () {},
                    OnSeeAll: true,
                  ),
                  MeuBioma(),
                  SizedBox(height: defaultPadding),
                ],
              ),
            ),
    );
  }
}

const InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(borderSide: BorderSide.none),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
);
