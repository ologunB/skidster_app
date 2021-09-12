import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class NotificationManager {
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    show(message);

    if (message != null) {}
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'chat_status_notification_id', // id
    'chat Status Notification', // title
    'This channel is used for important notifications about chat',
    // description
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> show(RemoteMessage message) async {
    if (message != null) {
      final RemoteNotification notification = message.notification;
      final AndroidNotification android = message.notification?.android;

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        channel.id,
        channel.name,
        channel.description,
        importance: Importance.max,
        icon: null,
      );
      const IOSNotificationDetails iSODetails = IOSNotificationDetails();
      final NotificationDetails generalNotificationDetails =
          NotificationDetails(android: androidDetails, iOS: iSODetails);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(message.data['id'].hashCode,
            notification.title, notification.body, generalNotificationDetails,
            payload: jsonEncode(message.data));
      }
    }
  }

  String a = '';

  static Logger log = Logger();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static void configureFirebaseNotificationListeners() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.d(message.data);
      log.d(message.notification);
      if (message.notification.title != null) {
        show(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await Firebase?.initializeApp();
      log.d(message);
      if (message.notification.title != null) {
        show(message);
      }
    });
  }

  static Future<String> messagingToken() async {
    return _firebaseMessaging.getToken();
  }

  static Future<void> cancelNotification(int id) async {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> initialize() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
      print('received: ' + title.toString());
    });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    configureFirebaseNotificationListeners();
  }

  static Future<dynamic> selectNotification(String payload) async {
    if (payload != null) {
      final dynamic data = jsonDecode(payload);
      log.d('payload is: ' + data.toString());
      handleData(data);
    } else {
      log.d('payload is: null');
    }
  }

  static Future<void> handleData(dynamic data, [bool isAppOpen = false]) async {
/*  if (data['isGroup'].toString() == 'false') {
      Navigator.push<void>(
          locator<NavigationService>().navigationKey.currentContext,
          CupertinoPageRoute<dynamic>(
              builder: (BuildContext context) => PersonalChatDetailScreen(
                    contact: UserModel(
                        fullname: data['fromName'].toString(),
                        imgUrl: data['fromImg'].toString(),
                        phoneNumber: data['id'].toString()),
                  )));
    } else {
      Navigator.push<void>(
          locator<NavigationService>().navigationKey.currentContext,
          CupertinoPageRoute<dynamic>(
              builder: (BuildContext context) => GroupChatDetailsScreen(
                    groupModel: UserModel(
                        fullname: data['fromName'].toString(),
                        imgUrl: data['fromImg'].toString(),
                        phoneNumber: data['id'].toString()),
                  )));
    }*/
  }
}
