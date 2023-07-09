import 'package:callwebrtc/controller/call_controller.dart';
import 'package:callwebrtc/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/call_page.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CallController()),
      ],
      child: const MyAPP(),
    ),
  );
}

class MyAPP extends StatefulWidget {
  const MyAPP({Key? key}) : super(key: key);

  @override
  State<MyAPP> createState() => _MyApp();
}

class _MyApp extends State<MyAPP> {
  @override
  Widget build(BuildContext context) {
    // FirebaseNotification().Configure(context);

    return MaterialApp(
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [Locale('pt', 'BR')],
      // debugShowCheckedModeBanner: ENV != "producao.env" ? true : false,
      home: const HomePage(),
      routes: {
        AppRoutes.CALLPAGE: (context) => const CallPage(),
        // AppRoutes.LOADING: (context) => LoadingPage(),
        // AppRoutes.OPCOESLOGIN: (context) => OpcoesLogin(),
        // AppRoutes.LOGIN: (context) => LoginPage(),
        // AppRoutes.PERMISSOES: (context) => DevicePermissionsPage(),
        // AppRoutes.RENOVAR: (context) => RenovarSenha(),
        // AppRoutes.HOME: (context) => HomePage(),
        // AppRoutes.OPERATIONS: (context) => OperationsPage(),
        // AppRoutes.ACIONAMENTOS: (context) => AcionamentosPage(),
        // AppRoutes.CAMERAS: (context) => CamerasPage(),
        // AppRoutes.CHAVE: (context) => ChavesPage(),
        // AppRoutes.CADASTROS: (context) => CadastrosPage(),
        // AppRoutes.MORADORES: (context) => MoradoresPage(),
        // AppRoutes.ADDMORADOR: (context) => MoradorFormAdd(),
        // AppRoutes.EDITMORADOR: (context) => MoradorFormEdit(),
        // AppRoutes.PETS: (context) => PetsPage(),
        // AppRoutes.ADDPET: (context) => PetFormAdd(),
        // AppRoutes.EDITPET: (context) => PetFormEdit(),
        // AppRoutes.VEICULOS: (context) => VeiculosPage(),
        // AppRoutes.ADDVEICULO: (context) => VeiculoFormAdd(),
        // AppRoutes.EDITVEICULO: (context) => VeiculoFormEdit(),
        // AppRoutes.VISITANTE: (context) => VisitantesPage(),
        // AppRoutes.ADDVISITANTE: (context) => VisitanteFormAdd(),
        // AppRoutes.EDITVISITANTE: (context) => VisitanteFormEdit(),
        // AppRoutes.ADDCHAVE: (context) => ChavesAdd(),
        // AppRoutes.EDITCHAVE: (context) => ChaveCardEditar(),
        // AppRoutes.CHAT: (context) => ChatPageNew(),
        // AppRoutes.AGENDAEMERGENCIAL: (context) => AgendaEmergencialPage(),
        // AppRoutes.ADDAGENDA: (context) => AgendaFormAdd(),
        // AppRoutes.EDITAGENDA: (context) => AgendaFormEdit(),
        // AppRoutes.QRCODE: (context) => ScannerPage(),
        // AppRoutes.AJUSTES: (context) => AjustesPage(),
        // AppRoutes.NOTIFICACOES: (context) => NotificacoesPage(),
        // AppRoutes.RELATORIOS: (context) => RelatoriosPage(),
        // AppRoutes.CAMERACELULARPET: (context) => CameraCelularPetPage()
      },
    );
  }
}
