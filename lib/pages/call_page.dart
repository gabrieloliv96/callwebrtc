import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../controller/call_controller.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void initState() {
    super.initState();
    context.read<CallController>().connect(context);
  }

  @override
  Widget build(BuildContext context) {
    final callController = Provider.of<CallController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text((callController.selfId != null
            ? ' Your ID (${callController.selfId}) '
            : '')),
        actions: const <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: null,
            tooltip: 'setup',
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: callController.inCalling
          ? SizedBox(
              width: 240.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      tooltip: 'Camera',
                      onPressed: callController.switchCamera(),
                      child: const Icon(Icons.switch_camera),
                    ),
                    FloatingActionButton(
                      tooltip: 'Screen Sharing',
                      onPressed: () =>
                          callController.selectScreenSourceDialog(context),
                      child: const Icon(Icons.desktop_mac),
                    ),
                    FloatingActionButton(
                      // onPressed: callController.hangUp(),
                      onPressed: () {},
                      tooltip: 'Hangup',
                      backgroundColor: Colors.pink,
                      child: Icon(Icons.call_end),
                    ),
                    FloatingActionButton(
                      tooltip: 'Mute Mic',
                      onPressed: callController.muteMic(),
                      child: const Icon(Icons.mic_off),
                    )
                  ]))
          : null,
      body: callController.inCalling
          ? OrientationBuilder(builder: (context, orientation) {
              return Stack(children: <Widget>[
                Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(color: Colors.black54),
                      child: RTCVideoView(callController.remoteRenderer),
                    )),
                Positioned(
                  left: 20.0,
                  top: 20.0,
                  child: Container(
                    width: orientation == Orientation.portrait ? 90.0 : 120.0,
                    height: orientation == Orientation.portrait ? 120.0 : 90.0,
                    decoration: const BoxDecoration(color: Colors.black54),
                    child: RTCVideoView(
                      callController.localRenderer,
                      mirror: true,
                    ),
                  ),
                ),
              ]);
            })
          : ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: (callController.peers != null
                  ? callController.peers.length
                  : 0),
              itemBuilder: (context, i) {
                return callController.buildRow(
                    context, callController.peers[i]);
              }),
    );
  }
}
