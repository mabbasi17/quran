import 'package:flutter/material.dart';

// const izdbCardColor = Color(0xffffffff);
// const izdbCardTextColor = Color(0xff000000);
//
// const izdbPrimaryColor = Color(0xff5d0d00);
// const izdbButtonTextColor = Color(0xfffff8f1);
//
// const izdbIconColor = Color(0xfffff8f1);
//
// const izdbBackgroundColor = Color(0xfffff1dc);

const izdbTextFieldDecoration = InputDecoration(
  //hintText: 'Enter a value',
  filled: true,
  // fillColor: Color(0xffeaeeef),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

const prayerKeys = {
  "Fajr": {"ar": "الفجر", "de": "Fajr", "icon": "sun-middle.svg"},
  "iqama": {"ar": "الإقامة", "de": "Iqama", "icon": "taraweeh-prayer.svg"},
  "Sonnenaufgang": {"ar": "الشروق", "de": "Shuruk", "icon": "sunrise.svg"},
  "Dhuhr": {"ar": "الظهر", "de": "Duhur", "icon": "sun.svg"},
  "Asr": {"ar": "العصر", "de": "Asr", "icon": "cloud-sun.svg"},
  "Maghrib": {"ar": "المغرب", "de": "Maghrib", "icon": "sunset.svg"},
  "Isha": {"ar": "العشاء", "de": "Isha", "icon": "night-time.svg"}
};
const daysKeys = {
  "Mon": {"de": "Montag", "ar": "الاثنين"},
  "Tue": {"de": "Dienstag", "ar": "الثلاثاء"},
  "Wed": {"de": "Mittwoch", "ar": "الأربعاء"},
  "Thu": {"de": "Donnerstag", "ar": "الخميس"},
  "Fri": {"de": "Freitag", "ar": "الجمعة"},
  "Sat": {"de": "Samstag", "ar": "السبت"},
  "Sun": {"de": "Sonntag", "ar": "الأحد"},
};
