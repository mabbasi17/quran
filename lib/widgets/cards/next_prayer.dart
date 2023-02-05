import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/main.dart';
import 'package:izdb/screens/PrayerTimes/prayer_times.dart';
import 'package:collection/collection.dart';

class NextPrayer extends StatefulWidget {
  const NextPrayer({Key? key}) : super(key: key);

  @override
  State<NextPrayer> createState() => _NextPrayerState();
}

class _NextPrayerState extends State<NextPrayer> {
  Timer? _timer;
  DateTime now = DateTime.now();
  HijriCalendar todayInHijri = HijriCalendar.now();
  List? prayerTimes;
  late Map todayPrayerTimes;
  MapEntry nextPrayer = const MapEntry("Fajr", "00:00");
  Duration remainingTime = const Duration(seconds: 0);
  int dayIndex = DateTime.now()
      .difference(DateTime(DateTime.now().year, 1, 1, 0, 0))
      .inDays;

  DateTime prayerDay = DateTime.now();

  void _getTime() {
    final DateTime current = DateTime.now();
    todayPrayerTimes =
        prayerTimes?[int.parse(DateFormat("D").format(prayerDay)) - 1];
    todayPrayerTimes.remove("day");
    todayPrayerTimes.remove("month_id");

    setState(() {
      now = current;
      DateTime prayerDateTime = now;
      var nextPrayerOrNull = todayPrayerTimes.entries
          .sorted((a, b) => a.value.compareTo(b.value))
          .firstWhereOrNull((entry) {
        prayerDateTime = DateTime.parse(
            DateFormat("yyyy-MM-dd ").format(prayerDay) + entry.value);
        return prayerDateTime.isAfter(now);
      });
      if (nextPrayerOrNull == null) {
        prayerDay = prayerDay.add(const Duration(days: 1));
      } else {
        nextPrayer = nextPrayerOrNull;
      }
      remainingTime = prayerDateTime.difference(now);
    });
  }

  @override
  void initState() {
    HijriCalendar.setLocal("ar");
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    FirebaseFirestore.instance
        .collection("content")
        .doc("prayerTimes")
        .get(const GetOptions(source: Source.serverAndCache))
        .then((value) {
      prayerTimes = value.data()?["prayerTimesList"];
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: colors["izdbCardColor"],
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 2.0),
              blurRadius: 4.0,
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat("dd.MM.yyyy").format(now),
                  style: TextStyle(color: colors["izdbCardTextColor"])),
              Text(todayInHijri.fullDate(),
                  style: TextStyle(color: colors["izdbCardTextColor"])),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Nächtes Gebet • الصلاة القادمة",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors["izdbCardTextColor"]),
            textAlign: TextAlign.center,
          ),
          Text(
            "${prayerKeys[nextPrayer.key]?["de"]} ◊ ${prayerKeys[nextPrayer.key]?["ar"]}",
            style: TextStyle(
                fontSize: 28,
                color: colors["izdbPrimaryColor"],
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Divider(thickness: 1),
          nextPrayer.key == "iqama"
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              todayPrayerTimes["Fajr"].toString(),
                              style: TextStyle(
                                  fontSize: 28,
                                  color: colors["izdbCardTextColor"]),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "AZAN • الأذان",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: colors["izdbCardTextColor"]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 15),
                        Column(
                          children: [
                            Text(
                              nextPrayer.value.toString(),
                              style: TextStyle(
                                  fontSize: 28,
                                  color: colors["izdbCardTextColor"]),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "IQAMA • الإقامة",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: colors["izdbCardTextColor"]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text(
                      nextPrayer.value.toString(),
                      style: TextStyle(
                          fontSize: 28, color: colors["izdbCardTextColor"]),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "AZAN • الأذان",
                      style: TextStyle(
                          fontSize: 13, color: colors["izdbCardTextColor"]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
          const Divider(thickness: 1),
          Text(
            nextPrayer.key == "iqama"
                ? "Zeit bis zum IQAMA • الوقت المتبقي للإقامة"
                : "Zeit bis zum AZAN • الوقت المتبقي للأذان",
            style: TextStyle(fontSize: 13, color: colors["izdbCardTextColor"]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                remainingTime.inHours.toString().padLeft(2, "0"),
                style:
                    TextStyle(fontSize: 20, color: colors["izdbCardTextColor"]),
              ),
              Text(
                remainingTime.inMinutes
                    .remainder(60)
                    .toString()
                    .padLeft(2, "0"),
                style:
                    TextStyle(fontSize: 20, color: colors["izdbCardTextColor"]),
              ),
              Text(
                remainingTime.inSeconds
                    .remainder(60)
                    .toString()
                    .padLeft(2, "0"),
                style:
                    TextStyle(fontSize: 20, color: colors["izdbCardTextColor"]),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "STUNDEN - ساعات",
                style:
                    TextStyle(fontSize: 12, color: colors["izdbCardTextColor"]),
              ),
              Text(
                "MINUTEN - دقائق",
                style:
                    TextStyle(fontSize: 12, color: colors["izdbCardTextColor"]),
              ),
              Text(
                "SEKUNDEN - ثواني",
                style:
                    TextStyle(fontSize: 12, color: colors["izdbCardTextColor"]),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const PrayerTimes()));
              },
              child: Text("Gebetszeiten * مواقيت الصلاة",
                  style: TextStyle(color: colors["izdbButtonTextColor"])))
        ],
      ),
    );
  }
}
