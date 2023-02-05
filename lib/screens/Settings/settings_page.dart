import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:izdb/widgets/izdb_app_bar.dart';
import 'package:izdb/widgets/izdb_background.dart';
import 'package:izdb/widgets/izdb_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Map notification = {
    "lessons": false,
    "stayUpToDate": false,
    "azkarAlSabah": false,
    "azkarAlMasaa": false,
  };

  Future<void> setNotification(key) async {
    final SharedPreferences prefs = await _prefs;
    if (notification[key] == true) {
      FirebaseMessaging.instance.unsubscribeFromTopic(key).then((res) {
        prefs.setBool(key, false);
      });
      setState(() {
        notification[key] = false;
      });
    } else {
      FirebaseMessaging.instance.subscribeToTopic(key).then((res) {
        prefs.setBool(key, true);
      });
      setState(() {
        notification[key] = true;
      });
    }
  }

  Future<void> getNotification() async {
    final SharedPreferences prefs = await _prefs;
    for (var e in notification.keys) {
      setState(() {
        notification[e] = prefs.getBool(e) ?? false;
      });
    }
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IZDBAppBar(title: "الإعدادات"),
      drawer: const IZDBDrawer(),
      body: IZDBBackground(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          primary: false,
          children: [
            ListTile(
              title: const Text("Auf dem Neusten Stand bleiben!",
                  style: TextStyle(fontSize: 18)),
              subtitle:
                  const Text("Livestream, Veranstaltungen, Neuigkeiten.."),
              trailing: Switch(
                  onChanged: (v) => setNotification("stayUpToDate"),
                  value: notification["stayUpToDate"]),
            ),
            ListTile(
              title: const Text("Unterrichtsbenachrichtigung!",
                  style: TextStyle(fontSize: 18)),
              trailing: Switch(
                  onChanged: (v) => setNotification("lessons"),
                  value: notification["lessons"]),
            ),
            ListTile(
              title: const Text("Tägliche Ma'thurat-Erinnerung!",
                  style: TextStyle(fontSize: 18)),
              subtitle: const Text("Täglich um 07:00 Uhr.."),
              trailing: Switch(
                  onChanged: (v) => setNotification("azkarAlSabah"),
                  value: notification["azkarAlSabah"]),
            ),
            ListTile(
              title: const Text("Tägliche Ma'thurat-Erinnerung!",
                  style: TextStyle(fontSize: 18)),
              subtitle: const Text("Täglich um 19:00 Uhr.."),
              trailing: Switch(
                  onChanged: (v) => setNotification("azkarAlMasaa"),
                  value: notification["azkarAlMasaa"]),
            ),
          ],
        ),
      ),
    );
  }
}
