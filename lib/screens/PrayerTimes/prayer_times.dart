import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/main.dart';
import 'package:izdb/screens/PrayerTimes/times_images_viewer.dart';
import 'package:izdb/widgets/izdb_app_bar.dart';
import 'package:izdb/widgets/izdb_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/izdb_background.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({Key? key}) : super(key: key);

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  DateTime date = DateTime.now();
  List prayerTimes = [];
  Map todayPrayerTimes = {};
  Map notification = {};

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
    for (var e in todayPrayerTimes.keys
        .where((e) => !["Sonnenaufgang", "iqama"].contains(e))) {
      setState(() {
        notification[e] = prefs.getBool(e) ?? false;
      });
    }
  }

  getPrayerTimes() {
    final dayIndex = date.difference(DateTime(date.year, 1, 1, 0, 0)).inDays;
    prayerKeys.forEach((key, value) {
      setState(() {
        todayPrayerTimes[key] = prayerTimes[dayIndex][key];
      });
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("content")
        .doc("prayerTimes")
        .get(const GetOptions(source: Source.serverAndCache))
        .then((value) {
      prayerTimes = value.data()?["prayerTimesList"];
      getPrayerTimes();
      getNotification();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const IZDBDrawer(),
      appBar: const IZDBAppBar(title: "أوقات الصلاة"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => TimesImagesViewer()));
        },
        child: const Icon(Icons.date_range),
      ),
      body: IZDBBackground(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          primary: false,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: colors["izdbCardColor"],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0), //(x,y)
                      blurRadius: 4.0,
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          color: colors["izdbCardTextColor"],
                          onPressed: () {
                            setState(() {
                              date = date.add(const Duration(days: -1));
                            });
                            getPrayerTimes();
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      Row(
                        children: [
                          Text(
                            DateFormat("dd.MM.yyyy").format(date),
                            style: TextStyle(
                                fontSize: 20,
                                color: colors["izdbCardTextColor"]),
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                              color: colors["izdbCardTextColor"],
                              onPressed: () async {
                                final newDate = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate:
                                      DateTime(DateTime.now().year - 100),
                                  lastDate: DateTime(DateTime.now().year + 5),
                                );
                                if (newDate != null) {
                                  setState(() {
                                    date = newDate;
                                  });
                                  getPrayerTimes();
                                }
                              },
                              icon: const Icon(Icons.today)),
                        ],
                      ),
                      // IconButton(
                      //     onPressed: () {
                      //       List prayerTimes = [];
                      //       rootBundle
                      //           .loadString('assets/json/prayer_times.json')
                      //           .then((str) => jsonDecode(str))
                      //           .then((value) => value[2]["data"])
                      //           .then((value) {
                      //         setState(() {
                      //           prayerTimes = value!;
                      //         });
                      //         FirebaseFirestore.instance
                      //             .collection("content")
                      //             .doc("prayerTimes")
                      //             .set({
                      //           "prayerTimesList": prayerTimes
                      //               .mapIndexed((i, e) => ({...e, "day": i + 1}))
                      //               .toList()
                      //         }).then((value) => {print("done")});
                      //       });
                      //     },
                      //     icon: Icon(Icons.add)),
                      IconButton(
                          color: colors["izdbCardTextColor"],
                          onPressed: () {
                            setState(() {
                              date = date.add(const Duration(days: 1));
                            });
                            getPrayerTimes();
                          },
                          icon: const Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                  const Divider(),
                  Table(
                    columnWidths: const {1: FractionColumnWidth(0.4)},
                    children: todayPrayerTimes.entries
                        .map((entry) => TableRow(
                              children: <Widget>[
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: SvgPicture.asset(
                                      "assets/svg/${prayerKeys[entry.key]?["icon"]}",
                                      width: 30,
                                      height: 30,
                                      color: colors["izdbCardTextColor"],
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    "${prayerKeys[entry.key]?["de"]} ${prayerKeys[entry.key]?["ar"]}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: colors["izdbCardTextColor"]),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colors["izdbCardTextColor"]),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: ["iqama", "Sonnenaufgang"]
                                          .contains(entry.key)
                                      ? IconButton(
                                          color: colors["izdbCardTextColor"],
                                          onPressed: null,
                                          icon: Icon(
                                              Icons.notifications_off_outlined),
                                        )
                                      : IconButton(
                                          color: colors["izdbCardTextColor"],
                                          onPressed: () {
                                            setNotification(entry.key);
                                          },
                                          icon: Icon(
                                              notification[entry.key] == true
                                                  ? Icons.notifications_active
                                                  : Icons.notifications_off),
                                        ),
                                ),
                              ],
                            ))
                        .toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
