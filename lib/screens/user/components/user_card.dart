import 'package:biomaapp/models/AvailableDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../constants.dart';

class UserCard extends StatefulWidget {
  UserCard({
    Key? key,
    required this.user,
    required this.press,
  }) : super(key: key);

  Usuario user;
  VoidCallback press;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isError = false;
  bool isLoading = true;
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var UserList = Provider.of<UsuariosList>(
      context,
      listen: false,
    );

    if (widget.user.nome.isEmpty && widget.user.cpf.isNotEmpty) {
      UserList.loadPacientes(widget.user.cpf).then((value) {
        setState(() {
          widget.user = UserList.items.first;
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return Card(
      elevation: 8,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          onBackgroundImageError: (_, __) {
            setState(() {
              isError = true;
            });
          },
          child: isError == true ? Text(' -') : SizedBox(),
          backgroundImage: NetworkImage(
            Constants.IMG_USUARIO + widget.user.cpf + '.jpg',
          ),
        ),
        title: textResp(widget.user.nome),
        subtitle: UtilBrasilFields.isCPFValido(widget.user.cpf)
            ? Text(UtilBrasilFields.obterCpf(widget.user.cpf))
            : Text('Cpf Não localizado'),
        onTap: () {
          setState(() {
            widget.press.call();
          });
          // await pages.selecionarPaginaHome(1);
          //  await filtros.LimparUsuarios();
          //  await filtros.addUsuarios(agendados.first.indicando);
          // Navigator.of(context).pushReplacementNamed(
          //   AppRoutes.AUTH_OR_HOME,
          // );
        },
      ),
    );
  }
}
