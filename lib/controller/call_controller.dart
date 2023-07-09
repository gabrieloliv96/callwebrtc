import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../services/signaling.dart';
import '../widgets/screen_select_dialog.dart';

class CallController with ChangeNotifier {
  Signaling? _signaling;
  String host = 'demo.cloudwebrtc.com';
  Session? _session;
  String? _selfId;
  bool _inCalling = false;
  bool _waitAccept = false;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  List<dynamic> _peers = [];

  Signaling? get signaling => _signaling;
  Session? get session => _session;
  String? get selfId => _selfId;
  bool get inCalling => _inCalling;
  bool get waitAccept => _waitAccept;
  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
  List<dynamic> get peers => _peers;

  void connect(BuildContext context) async {
    _signaling ??= Signaling(host, context)..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };

    initRenderers();

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      switch (state) {
        case CallState.CallStateNew:
          _session = session;
          notifyListeners();
          break;
        case CallState.CallStateRinging:
          bool? acept = await _showAcceptDialog(context);
          if (acept!) {
            accept();
            _inCalling = true;
            notifyListeners();
          } else {
            reject();
            notifyListeners();
          }
          break;
        case CallState.CallStateBye:
          if (_waitAccept) {
            print('peer reject');
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          _localRenderer.srcObject = null;
          _remoteRenderer.srcObject = null;
          _inCalling = false;
          _session = null;
          notifyListeners();
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          notifyListeners();
          _showInvateDialog(context);
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          _inCalling = true;
          notifyListeners();

          break;
      }
    };

    _signaling?.onPeersUpdate = ((event) {
      _selfId = event['self'];
      _peers = event['peers'];
      notifyListeners();
    });

    _signaling?.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
      notifyListeners();
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = stream;
      notifyListeners();
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = null;
      notifyListeners();
    });
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    notifyListeners();
  }

  Future<bool?> _showAcceptDialog(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("title"),
          content: const Text("accept?"),
          actions: <Widget>[
            MaterialButton(
              child: const Text(
                'Reject',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            MaterialButton(
              child: const Text(
                'Accept',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showInvateDialog(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("title"),
          content: const Text("waiting"),
          actions: <Widget>[
            TextButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
                hangUp();
              },
            ),
          ],
        );
      },
    );
  }

  invitePeer(BuildContext context, String peerId, bool useScreen) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId, 'video', useScreen);
    }
  }

  accept() {
    if (_session != null) {
      _signaling?.accept(_session!.sid, 'video');
      notifyListeners();
    }
  }

  reject() {
    if (_session != null) {
      _signaling?.reject(_session!.sid);
      notifyListeners();
    }
  }

  hangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid);
      notifyListeners();
    }
  }

  switchCamera() {
    _signaling?.switchCamera();
    notifyListeners();
  }

  muteMic() {
    _signaling?.muteMic();
    notifyListeners();
  }

  _invitePeer(BuildContext context, String peerId, bool useScreen) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId, 'video', useScreen);
    }
  }

  Future<void> selectScreenSourceDialog(BuildContext context) async {
    MediaStream? screenStream;
    if (WebRTC.platformIsDesktop) {
      final source = await showDialog<DesktopCapturerSource>(
        context: context,
        builder: (context) => ScreenSelectDialog(),
      );
      if (source != null) {
        try {
          var stream =
              await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
            'video': {
              'deviceId': {'exact': source.id},
              'mandatory': {'frameRate': 30.0}
            }
          });
          stream.getVideoTracks()[0].onEnded = () {
            print(
                'By adding a listener on onEnded you can: 1) catch stop video sharing on Web');
          };
          screenStream = stream;
        } catch (e) {
          print(e);
        }
      }
    } else if (WebRTC.platformIsWeb) {
      screenStream =
          await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
        'audio': false,
        'video': true,
      });
    }
    if (screenStream != null) _signaling?.switchToScreenSharing(screenStream);
  }

  buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? peer['name'] + ', ID: ${peer['id']} ' + ' [Your self]'
            : peer['name'] + ', ID: ${peer['id']} '),
        onTap: null,
        trailing: SizedBox(
            width: 100.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(self ? Icons.close : Icons.videocam,
                        color: self ? Colors.grey : Colors.black),
                    onPressed: () => _invitePeer(context, peer['id'], false),
                    tooltip: 'Video calling',
                  ),
                  IconButton(
                    icon: Icon(self ? Icons.close : Icons.screen_share,
                        color: self ? Colors.grey : Colors.black),
                    onPressed: () => _invitePeer(context, peer['id'], true),
                    tooltip: 'Screen sharing',
                  )
                ])),
        subtitle: Text('[' + peer['user_agent'] + ']'),
      ),
      Divider()
    ]);
  }
}
