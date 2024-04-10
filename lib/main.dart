// ignore_for_file: unused_element, avoid_print, deprecated_member_use, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:app/features/app/splash_screen/splash_screen.dart';
import 'package:app/features/user_auth/presentation/pages/add_objetivo_page.dart';
import 'package:app/features/user_auth/presentation/pages/form_objetivo.dart';
import 'package:app/features/user_auth/presentation/pages/home_page.dart';
import 'package:app/features/user_auth/presentation/pages/login_page.dart';
import 'package:app/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:app/firebase_options.dart';
import 'package:app/global/common/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


Future<MqttClient> setupMqtt(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const String serverUri = '192.168.137.241'; 
  const String clientId = 'flutter_client'; 
  const String topic = 'Tema'; 
  const String username = 'rasp'; 
  const String password = 'rasp';
  late MqttServerClient client = MqttServerClient(serverUri, clientId);
  client.logging(on: false);

  final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .keepAliveFor(60)
        .authenticateAs(username, password);

  client.connectionMessage = connMess;

  client.onDisconnected = () {
    print('Disconnected');
  };

  void showNotification(String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('mqtt_channel_id', 'MQTT Channel',
            importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Nuevo mensaje MQTT',
      payload,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  try {
    await client.connect();
    print('Connected to MQTT server');
    showToast(message: "Connected to MQTT server");
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        showNotification(payload); 
      });
    }
  } catch (e) {
    print('Exception: $e');
  }
  return client;
}

Future main() async {
  //Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //MQTT
  Future<MqttClient> mqttClientFuture = setupMqtt(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMART COIN',
      routes: {
      '/': (context) => const SplashScreen(
          child: Login(),
        ),
        '/login': (context) => const Login(),
        '/signUp': (context) => const InicioR(),
        '/home': (context) => const HomePage(),
        '/objetivo': (context) => const Objetivo(),
        '/formObjetivo': (context) => const FormObjetivo(),
      },
    );
  }
}