import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'dart:io';

class HubService {
  late HubConnection hubConnection;

  HubService(String hubUrl) {
    Logger.root.level = Level.ALL; // Show all log levels
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.loggerName}: ${record.message}');
    });
    hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.WebSockets,
            ))
        .withAutomaticReconnect(
      retryDelays: [0, 2000, 5000, 10000],
    ).build();

    hubConnection.serverTimeoutInMilliseconds = 30000; // 30s
    hubConnection.keepAliveIntervalInMilliseconds = 15000;

    hubConnection.onreconnecting(({Exception? error}) {
      print('Connection lost. Reconnecting... Error: $error');
    });

    hubConnection.onreconnected(({String? connectionId}) {
      print('Reconnected. ConnectionId: $connectionId');
    });

    hubConnection.onclose(({Exception? error}) {
      print('Connection closed. Error: $error');
    });
  }

  Future<void> start() async {
    if (hubConnection.state != HubConnectionState.Disconnected) {
      await hubConnection.stop();
    }
    await hubConnection.start();
    print('Connected to hub at $hubConnection');
  }

  Future<void> stop() async {
    await hubConnection.stop();
    print('Disconnected from hub');
  }

  void on(String eventName, MethodInvocationFunc callback) {
    hubConnection.on(eventName, callback);
  }

  void off(String eventName) {
    hubConnection.off(eventName);
  }

  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    try {
      final result = await hubConnection.invoke(methodName, args: args);
      return result;
    } catch (e) {
      print("Invoke error [$methodName]: $e");
      return null;
    }
  }

  bool get isConnected => hubConnection.state == HubConnectionState.Connected;
}
