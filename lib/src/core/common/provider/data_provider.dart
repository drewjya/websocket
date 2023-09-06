import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:websocket/src/core/common/model/data_model.dart';
import 'package:websocket/src/core/config/websocket_config.dart';

part 'data_provider.g.dart';

@riverpod
class DataC extends _$DataC {
  late WebSocketConfig<Datas> websocket;
  @override
  Stream<Datas> build() async* {
    websocket = WebSocketConfigImpl(
        url: "ws://192.168.0.29:3000/ws/123", fromMap: Datas.fromMap);
    websocket.connect();
    ref.onDispose(() {
      websocket.disconnect();
    });
    websocket.connect();
    yield* websocket.getData();
  }

  payload({required String message}) {
    websocket.sendPayload(message: message);
  }
}
