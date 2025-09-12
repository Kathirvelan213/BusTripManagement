import 'package:signalr_netcore/signalr_client.dart';

class HubService {
  late HubConnection _hubConnection;

  HubService(String hubUrl) {
    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.WebSockets,
            ))
        .withAutomaticReconnect(
      retryDelays: [0, 2000, 5000, 10000], // in milliseconds
    ).build();

    _hubConnection.serverTimeoutInMilliseconds = 30000; // 30s
    _hubConnection.keepAliveIntervalInMilliseconds = 15000;

    _hubConnection.onreconnecting(({Exception? error}) {
      print('Connection lost. Reconnecting... Error: $error');
    });

    _hubConnection.onreconnected(({String? connectionId}) {
      print('Reconnected. ConnectionId: $connectionId');
    });

    _hubConnection.onclose(({Exception? error}) {
      print('Connection closed. Error: $error');
    });
  }

  Future<void> start() async {
    if (_hubConnection.state != HubConnectionState.Disconnected) {
      await _hubConnection.stop();
    }
    await _hubConnection.start();
    print('Connected to hub at $_hubConnection');
  }

  Future<void> stop() async {
    await _hubConnection.stop();
    print('Disconnected from hub');
  }

  void on(String eventName, MethodInvocationFunc callback) {
    _hubConnection.on(eventName, callback);
  }

  void off(String eventName) {
    _hubConnection.off(eventName);
  }

  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    try {
      final result = await _hubConnection.invoke(methodName, args: args);
      return result;
    } catch (e) {
      print("Invoke error [$methodName]: $e");
      return null;
    }
  }

  bool get isConnected => _hubConnection.state == HubConnectionState.Connected;
}
