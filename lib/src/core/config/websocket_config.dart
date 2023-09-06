// ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'websocket_config.g.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract class WebSocketConfig<T> {
  const WebSocketConfig();
  bool get isConnected;
  Future connect();
  Future disconnect();
  Stream<T> getData();
  sendPayload({required dynamic message});
}

class WebSocketConfigImpl<T> extends WebSocketConfig<T> {
  late WebSocket _webSocket;
  late StreamController<T> _dataStreamController;
  Stream<T>? _dataStream;
  bool _isConnected = false;
  final String url;
  final T Function(Map<String, dynamic> caster) fromMap;
  WebSocketConfigImpl({
    required this.url,
    required this.fromMap,
  });

  @override
  bool get isConnected => _isConnected;

  @override
  Future connect() async {
    try {
      if (_isConnected) return;
      _webSocket = await WebSocket.connect(url);
      _isConnected = true;

      _dataStreamController = StreamController<T>();
      _dataStream = _dataStreamController.stream.asBroadcastStream();

      _webSocket.listen(
        (dynamic data) {
          if (data is String) {
            final jsonData = json.decode(data) as Map<String, dynamic>;
            final payload = fromMap(jsonData);

            _dataStreamController.add(payload);
          }
        },
      );

      _webSocket.done.then((_) {
        _isConnected = false;
        _dataStreamController.close();
      });
    } catch (e, s) {
      _dataStreamController.addError(e, s);
      rethrow;
    }
  }

  @override
  Future disconnect() async {
    _isConnected = false;
    await _webSocket.close();
    await _dataStreamController.close();
  }

  @override
  Stream<T> getData() async* {
    if (!_isConnected) {
      await connect();
    }
    yield* _dataStream!;
  }

  @override
  sendPayload({required dynamic message}) {
    final jsonMessage = json.encode(message);
    _webSocket.add(jsonMessage);
  }
}
