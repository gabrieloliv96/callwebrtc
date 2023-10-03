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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('pt', 'BR')],
      // debugShowCheckedModeBanner: ENV != "producao.env" ? true : false,
      home: const HomePage(),
      routes: {
        AppRoutes.CALLPAGE: (context) => const CallPage(),
      },
    );
  }
}
