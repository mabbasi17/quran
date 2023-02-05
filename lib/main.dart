import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/screens/home.dart';
import 'package:izdb/widgets/izdb_loading.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

Map colors = {
  "izdbPrimaryColor": const Color(0xff5d0d00),
  "izdbCardColor": const Color(0xffffffff),
  "izdbCardTextColor": const Color(0xff000000),
  "izdbButtonTextColor": const Color(0xfffff8f1),
  "izdbBackgroundColor": const Color(0xfffff1dc),
};

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
late AndroidNotificationChannel azanChannel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Set the background messaging handler early on, as a named top-level function
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      // sound: RawResourceAndroidNotificationSound('azan_sound')
    );
    azanChannel = const AndroidNotificationChannel(
        'azan_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('azan_sound'));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(azanChannel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        bool isAzan = prayerKeys.values
            .map((v) => "${v["ar"]} ${v["de"]}")
            .toList()
            .contains(message.notification?.title);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          isAzan
              ? NotificationDetails(
                  android: AndroidNotificationDetails(
                    azanChannel.id,
                    azanChannel.name,
                    channelDescription: azanChannel.description,
                    icon: 'izdb_logo',
                  ),
                )
              : NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    icon: 'izdb_logo',
                  ),
                ),
        );
      }
    });

    FirebaseFirestore.instance
        .collection("content")
        .doc("config")
        .get()
        .then((res) {
      List entries = res.data()?["colors"].entries.toList();
      for (MapEntry entry in entries) {
        if (entry.value != null || entry.value != "") {
          setState(() {
            if (entry.key == "izdbPrimaryColor") {
              colors["izdbPrimaryColor"] =
                  generateMaterialColor(color: hexToColor(entry.value));
            } else {
              colors[entry.key] = hexToColor(entry.value);
            }
          });
        }
        if (entries.last == entry) {
          FlutterNativeSplash.remove();
          setState(() {
            loading = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const IZDBLoading()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'IZDB',
            initialRoute: '/home',
            routes: {
              '/home': (context) => MyHomePage(title: 'IZDB'),
            },
            theme: ThemeData(
                fontFamily: 'Tajawal',
                primaryColor: colors["izdbPrimaryColor"],
                primarySwatch:
                    generateMaterialColor(color: colors["izdbPrimaryColor"]),
                scaffoldBackgroundColor: colors["izdbBackgroundColor"]),
            home: const MyHomePage(title: 'IZDB'),
          );
  }
}
