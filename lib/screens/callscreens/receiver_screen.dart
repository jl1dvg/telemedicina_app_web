import 'package:Skype_clone/models/call.dart';
import 'package:Skype_clone/provider/user_provider.dart';
import 'package:Skype_clone/resources/call_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ReceiverScreen extends StatefulWidget {
  final Call call;

  ReceiverScreen({
    @required this.call,
  });

  @override
  _ReceiverScreenState createState() => _ReceiverScreenState();
}

typedef OnLocalStream(MediaStream stream);
typedef OnRemoteStream(MediaStream stream);
typedef OnConnected();
typedef OnJoined(bool isOk);

class _ReceiverScreenState extends State<ReceiverScreen> {
  final CallMethods callMethods = CallMethods();

  RTCPeerConnection _pc;
  OnLocalStream onLocalStream;
  OnRemoteStream onRemoteStream;
  OnConnected onConnected;
  OnJoined onJoined;

  String _me, _him;
  MediaStream _localStream;

  set me(String me) {
    this._me = me;
  }

  IO.Socket _socket;

  final sdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  var _username = '';

  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    init();
    onConnected = () {};
    onLocalStream = (MediaStream stream) {
      _localRenderer.srcObject = stream;
      _localRenderer.mirror = true;
    };
    onRemoteStream = (MediaStream stream) {
      _remoteRenderer.srcObject = stream;
      _remoteRenderer.mirror = true;
    };
    onJoined = (bool isOk) {
      if (isOk) {
        me = _username;
        setState(() {
          _me = _username;
        });
      }
    };
  }

  init() async {
    final stream = await navigator.getUserMedia({
      "audio": true,
      "video": {
        "mandatory": {
          "minWidth": '480',
          "minHeight": '640',
          "minFrameRate": '30',
        },
        "facingMode": "user",
        "optional": [],
      }
    });

    onLocalStream(stream);
    _localStream = stream;

    _connect();

    sendMesage('join', 'Andres');
  }

  _connect() {
    _socket =
        IO.io('https://backend-simple-webrtc.herokuapp.com', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });

    _socket.on('connect', (_) {
      print('connected');
      onConnected();
    });

    _socket.on('on-join', (isOk) {
      print("on-join $isOk");
      onJoined(isOk);
    });

    _socket.on('on-call', (data) async {
      print("on-call $data");
      await _createPeer();
      _him = data['username'];
      final offer = data['offer'];
      final desc = RTCSessionDescription(offer['sdp'], offer['type']);
      await _pc.setRemoteDescription(desc);
      final RTCSessionDescription answer =
          await _pc.createAnswer(sdpConstraints);
      await _pc.setLocalDescription(answer);
      sendMesage("answer", {
        "username": _him,
        "answer": answer.toMap() //{"type": answer.type, "sdp": answer.sdp}
      });
    });

    _socket.on('on-answer', (answer) async {
      print("on answer $answer");
      final desc = RTCSessionDescription(answer['sdp'], answer['type']);
      await _pc.setRemoteDescription(desc);
    });

    _socket.on('on-candidate', (data) async {
      print("on-candidate $data");
      RTCIceCandidate candidate = new RTCIceCandidate(
          data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
      await _pc.addCandidate(candidate);
    });
  }

  _createPeer() async {
    _pc = await createPeerConnection({
      "iceServers": [
        {
          "urls": [
            "stun:stun1.l.google.com:19302",
          ]
        },
      ]
    }, {});
    _pc.addStream(_localStream);
    _pc.onAddStream = (MediaStream remoteStream) {
      onRemoteStream(remoteStream);
    };
    _pc.onIceCandidate = (RTCIceCandidate candidate) {
      print(
          "onIceCandidate onIceCandidate onIceCandidate onIceCandidate onIceCandidate");
      if (_him != null && candidate != null) {
        print("sending candidate");
        this.sendMesage(
            'candidate', {"username": _him, "candidate": candidate.toMap()});
      }
    };
  }

  call(String username) async {
    this._him = username;
    await _createPeer();
    final RTCSessionDescription desc = await _pc.createOffer(sdpConstraints);
    await _pc.setLocalDescription(desc);
    sendMesage("call", {"username": username, "offer": desc.toMap()});
  }

  sendMesage(String eventName, dynamic data) {
    _socket?.emit(eventName, data);
    print(eventName + ' llamada de ' + data);
  }

  _initRenderers() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
  }

  @override
  _setMyUserName(String _username) {
    print('username ' + _username);
    sendMesage('join', _username);
  }

  @override
  void dispose() {
    dispose();
    _localRenderer?.dispose();
    _remoteRenderer?.dispose();
    _socket?.close();
    _socket = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(alignment: Alignment.center, children: <Widget>[
          if (_me != null)
            Positioned(
              left: 10,
              bottom: 20,
              child: Transform.scale(
                scale: 0.3,
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 480,
                  height: 640,
                  child: RTCVideoView(_localRenderer),
                ),
              ),
            ),
          if (_me != null)
            Positioned.fill(
              child: RTCVideoView(_remoteRenderer),
            ),
          Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      callMethods.endCall(call: widget.call);
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15.0),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
