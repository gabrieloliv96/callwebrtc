import 'package:callwebrtc/controller/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';
import '../utils/route_item.dart';
import '../services/signaling.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // RouteItem item =
  //     RouteItem(title: '', subtitle: '', push: (BuildContext context) {});
  // Signaling? _signaling;
  // String host = 'demo.cloudwebrtc.com';
  // Session? _session;

  @override
  void initState() {
    super.initState();
    context.read<CallController>().connect(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bem-vindo'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CALLPAGE);
              },
              child: const Text('Ligar')),
        ],
      )),
    );
  }
}
