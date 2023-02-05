import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/main.dart';

class NotificationsIcon extends StatefulWidget {
  const NotificationsIcon({Key? key}) : super(key: key);

  @override
  State<NotificationsIcon> createState() => _NotificationsIconState();
}

class _NotificationsIconState extends State<NotificationsIcon> {
  List<RemoteMessage> _messages = [];

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      bool isAzan = prayerKeys.values
          .map((v) => "${v["ar"]} ${v["de"]}")
          .toList()
          .contains(message.notification?.title);
      if (mounted && !isAzan) {
        setState(() {
          _messages = [..._messages, message];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _messages.isNotEmpty,
      child: Badge(
        showBadge: _messages.isNotEmpty,
        badgeContent: Text(_messages.length.toString(),
            style: const TextStyle(color: Colors.white)),
        shape: BadgeShape.circle,
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        child: IconButton(
            onPressed: () async {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: colors["izdbCardColor"],
                  content: SingleChildScrollView(
                    child: _messages.isNotEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _messages
                                .map((m) => Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                              m.notification?.title ?? " "),
                                          subtitle:
                                              Text(m.notification?.body ?? " "),
                                          trailing: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                                DateFormat("MM.dd\nHH:mm")
                                                    .format(m.sentTime!),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                                textAlign: TextAlign.end),
                                          ),
                                          leading: const Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child:
                                                Icon(Icons.notifications_none),
                                          ),
                                        ),
                                        const Divider(thickness: 1),
                                      ],
                                    ))
                                .toList(),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("لايوجد إشعارات",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey)),
                          ),
                  ),
                  title: Text("Benachrichtigungen - الإشعارات",
                      style: TextStyle(
                          color: colors["izdbPrimaryColor"],
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              setState(() {
                _messages = [];
              });
            },
            icon: Icon(Icons.notifications,
                color: colors["izdbButtonTextColor"])),
      ),
    );
  }
}
