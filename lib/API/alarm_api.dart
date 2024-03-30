import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:http/http.dart' as http;

final MqttServerClient client =
    MqttServerClient('broker.hivemq.com', '35394593450');

// final client = MqttServerClient('broker.hivemq.com', '');
// var pongCount = 0; // Pong counter

class AlarmApi {
  Future<void> sendAlarm() async {
    String streamLink = "false";

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://115.79.196.171:6788/control_alarm'),
      );

      request.fields['state'] = streamLink;

      var response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> connect() async {
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('35394593450')
        .withWillTopic('vas-alarm-home')
        .withWillMessage('Connection Closed')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      log('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      log('Connected to the broker');
    } else {
      log('Failed to connect to the broker');
    }
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }
  // static void onDisconnected() {
  //   print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  //   if (client.connectionStatus!.disconnectionOrigin ==
  //       MqttDisconnectionOrigin.solicited) {
  //     print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
  //   } else {
  //     print(
  //         'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
  //     exit(-1);
  //   }
  //   if (pongCount == 3) {
  //     print('EXAMPLE:: Pong count is correct');
  //   } else {
  //     print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
  //   }
  // }

  // static void onConnected() {
  //   print(
  //       'EXAMPLE::OnConnected client callback - Client connection was successful');
  // }

  // static void publishMessage(String message) async {
  //   client.keepAlivePeriod = 20;
  //   client.connectTimeoutPeriod = 2000;

  //   /// Add the unsolicited disconnection callback
  //   client.onDisconnected = onDisconnected;

  //   /// Add the successful connection callback
  //   client.onConnected = onConnected;

  //   client.pongCallback = pong;
  //   try {
  //     await client.connect();
  //   } on NoConnectionException catch (e) {
  //     // Raised by the client when connection fails.
  //     print('EXAMPLE::client exception - $e');
  //     client.disconnect();
  //   } on SocketException catch (e) {
  //     // Raised by the socket layer
  //     print('EXAMPLE::socket exception - $e');
  //     client.disconnect();
  //   }

  //   /// Lets publish to our topic
  //   /// Use the payload builder rather than a raw buffer
  //   /// Our known topic to publish to
  //   const pubTopic = 'vas-alarm';
  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString('Hello from mqtt_client');

  //   /// Publish it
  //   print('EXAMPLE::Publishing our topic');
  //   client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

  //   client.disconnect();
  // }

  // static void pong() {
  //   print('EXAMPLE::Ping response client callback invoked');
  //   pongCount++;
  // }
}
