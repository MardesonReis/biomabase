import 'package:biomaapp/components/ReadMoreText.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/rating.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/redebioma.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/home/components/LogoImg.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants.dart';
import '../../../models/RecommendDoctor.dart';

class RedeBiomaDetalhes extends StatefulWidget {
  const RedeBiomaDetalhes({
    Key? key,
    required this.Redeitem,
  }) : super(key: key);

  final RedeBioma Redeitem;

  @override
  State<RedeBiomaDetalhes> createState() => _RedeBiomaDetalhesState();
}

class _RedeBiomaDetalhesState extends State<RedeBiomaDetalhes> {
  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    //  final ImageLoadingBuilder? loadingBuilder;

    Auth auth = Provider.of(context);

    return Scaffold(
      appBar: CustomAppBar(
          widget.Redeitem.parceiro + '\n', widget.Redeitem.destaque, () {}, []),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: LogoImage(
                  logoUrl: 'https://bioma.app.br/imagens/redebioma/' +
                      widget.Redeitem.img_logo,
                  imageUrl: 'https://bioma.app.br/imagens/redebioma/' +
                      widget.Redeitem.img_promo),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: destColor,
                elevation: 8,
                child: ListTile(
                  title: Text(
                    widget.Redeitem.destaque,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.green[300],
                elevation: 8,
                child: ListTile(
                  onTap: () {
                    abrirWhatsApp(
                        widget.Redeitem.whatsapp,
                        'Oi, quero sober mais sobre ' +
                            widget.Redeitem.descricao);
                  },
                  title: Text(
                    'Conversar com ' + widget.Redeitem.parceiro,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.chat),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: primaryColor,
                elevation: 8,
                child: ListTile(
                  onTap: () {
                    abrirUrl(widget.Redeitem.link);
                  },
                  title: Text(
                    'Página na WEB',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.link),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.green[300],
                elevation: 8,
                child: ListTile(
                  onTap: () async {
                    final box = context.findRenderObject() as RenderBox?;
                    var link =
                        'http://bioma.app.br?id_promo=' + widget.Redeitem.id;

                    ShareResult result;
                    result = await Share.shareWithResult(link,
                        subject: widget.Redeitem.descricao,
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size);
                  },
                  title: Text(
                    'Compartilhar',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.share),
                ),
              ),
            ),
            ListTile(
              title: SectionTitle(
                  title: 'Descrição', pressOnSeeAll: () {}, OnSeeAll: false),
              subtitle:
                  ReadMoreText(text: widget.Redeitem.descricao, maxLength: 300),
            ),
            ListTile(
              title: SectionTitle(
                  title: 'Instrução para uso',
                  pressOnSeeAll: () {},
                  OnSeeAll: false),
              subtitle: ReadMoreText(
                  text: widget.Redeitem.instrucoes, maxLength: 300),
            ),
            ListTile(
              title: SectionTitle(
                  title: 'Mais informações',
                  pressOnSeeAll: () {},
                  OnSeeAll: false),
              subtitle: ReadMoreText(
                  text: widget.Redeitem.m_instrucoes, maxLength: 200),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: ListTile(
                  tileColor: primaryColor[50],
                  title: SectionTitle(
                      title: 'Termos de uso',
                      pressOnSeeAll: () {},
                      OnSeeAll: false),
                  trailing: Icon(Icons.link),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: tela(context).height * 0.9,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: ListTile(
                                    title: Text('Termos de Uso'),
                                    subtitle: Text(widget.Redeitem.termos),
                                  ),
                                ),
                                ElevatedButton(
                                  child: const Text('Fechar'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
