import 'package:biomaapp/components/shere.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/agedaMedicoList.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/convenios_list.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidades_list.dart';
import 'package:biomaapp/models/extrato_list.dart';
import 'package:biomaapp/models/fila_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/indicacoes_list.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/usuarios.list.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/especialidades_screen.dart';
import 'package:biomaapp/screens/fidelimax/extrato_page.dart';
import 'package:biomaapp/screens/home/components/busca_Parceiro.dart';
import 'package:biomaapp/screens/pedidos/orders_page.dart';
import 'package:biomaapp/screens/procedimentos/filtroProcedimentos.dart';
import 'package:biomaapp/screens/profile/componets/up_img.dart';
import 'package:biomaapp/screens/profile/profile_screen.dart';
import 'package:biomaapp/screens/search/buscaRapida.dart';
import 'package:biomaapp/screens/search/search_screen.dart';
import 'package:biomaapp/screens/user/add_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/cart.dart';
import 'package:biomaapp/models/order_list.dart';
import 'package:biomaapp/models/product_list.dart';
import 'package:biomaapp/models/procedimento_list.dart';

import 'package:biomaapp/utils/app_routes.dart';

//void main() {  runApp(MyApp());}
void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, DataList>(
          create: (_) => DataList(),
          update: (ctx, auth, previous) {
            return DataList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, AgendamentosList>(
          create: (_) => AgendamentosList(),
          update: (ctx, auth, previous) {
            return AgendamentosList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, agendaMedicoList>(
          create: (_) => agendaMedicoList(),
          update: (ctx, auth, previous) {
            return agendaMedicoList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, EspecialidadesList>(
          create: (_) => EspecialidadesList(),
          update: (ctx, auth, previous) {
            return EspecialidadesList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ConveniosList>(
          create: (_) => ConveniosList(),
          update: (ctx, auth, previous) {
            return ConveniosList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ProcedimentoList>(
          create: (_) => ProcedimentoList(),
          update: (ctx, auth, previous) {
            return ProcedimentoList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, UnidadesList>(
          create: (_) => UnidadesList(),
          update: (ctx, auth, previous) {
            return UnidadesList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, MedicosList>(
          create: (_) => MedicosList(),
          update: (ctx, auth, previous) {
            return MedicosList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, UsuariosList>(
          create: (_) => UsuariosList(),
          update: (ctx, auth, previous) {
            return UsuariosList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, filtrosAtivos>(
          create: (_) => filtrosAtivos(),
          update: (ctx, auth, previous) {
            return previous ?? filtrosAtivos();
          },
        ),
        ChangeNotifierProxyProvider<Auth, FilaList>(
          create: (_) => FilaList(),
          update: (ctx, auth, previous) {
            return FilaList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, EstratoList>(
          create: (_) => EstratoList(),
          update: (ctx, auth, previous) {
            return EstratoList(auth.token ?? '', auth.userId ?? '',
                previous?.items ?? [], auth.fidelimax);
          },
        ),
        ChangeNotifierProxyProvider<Auth, IndicacoesList>(
          create: (_) => IndicacoesList(),
          update: (ctx, auth, previous) {
            return IndicacoesList(
                auth.token ?? '', auth.userId ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Paginas>(
          create: (_) => Paginas(),
          update: (ctx, auth, previous) {
            Paginas p = Paginas();
            p.pages = previous?.pages ?? [];
            p.selectedPage = previous?.selectedPage ?? 0;
            return p;
          },
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('pt', 'BR')],
        title: 'Bioma - Saúde Integral',
        theme: ThemeData(
          primarySwatch: primaryColor,
          accentColor: redColor,
          fontFamily: 'Lato',
        ),
        //home: ProductsOverviewPage(),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.SearchScreen: (ctx) => SearchScreen(),
          //   AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(
              Clips(titulo: 'Agendamentos', subtitulo: '', keyId: 'A')),
          AppRoutes.EXTRATO_FIDELIMAX: (ctx) => ExtratoPage(),
          AppRoutes.BuscaRapida: (ctx) => BuscaRapida(),
          AppRoutes.MenuBarGrupos: (ctx) => FiltrosProcedimentos(),
          AppRoutes.DoctorsScreen: (ctx) => DoctorsScreen(),
          AppRoutes.BuscaParceiro: (ctx) => BuscaParceiro(),
          AppRoutes.AddUser: (ctx) => AddUser(),
          AppRoutes.ImageUpload: (ctx) => ImageUpload(),
          AppRoutes.ProfileScreen: (ctx) => ProfileScreen(),
          AppRoutes.ProfileScreen: (ctx) => Shere(),
          AppRoutes.EspecialidadesScreen: (ctx) => EspecialidadesScreen(),
          //  AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
          //     AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
