// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izdb/screens/Quran/Slider/slider.dart';
import 'package:izdb/screens/Quran/quran_page.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:izdb/screens/Quran/quran_plugin/quran.dart' as quran;
import 'package:izdb/widgets/izdb_loading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quran extends StatefulWidget {
  const Quran({Key? key, required this.page}) : super(key: key);
  final int page;
  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List quranGerman = [];
  List verses = [];
  List recitations = [];
  Map? selectedRecitation;
  Map? selectedVerse;
  Map? selectedVerseTranslate;
  late int page;
  bool isPlaying = false;
  int? juz;
  String? surahName;
  bool loading = true;

  AudioPlayer? _audioPlayer;

  selectVerse(selected) {
    setState(() {
      selectedVerse = selected;
      selectedVerseTranslate = quranGerman.firstWhereOrNull((e) =>
          (e["SuraID"].toString() == selectedVerse?["surah"].toString() &&
              e["VerseID"].toString() == selectedVerse?["id"].toString()));
    });
  }

  getInitData() async {}

  @override
  void initState() {
    page = widget.page;
    _audioPlayer = AudioPlayer();
    Map pageData = quran.getPageData(page)[0];
    surahName = quran.getSurahNameArabic(pageData["surah"]);
    juz = quran.getJuzNumber(pageData["surah"], pageData["start"]);
    Future.wait([
      rootBundle
          .loadString('assets/json/quran_german.json')
          .then((str) => jsonDecode(str))
          .then((value) => quranGerman = value[2]["data"]),
      http
          .get(Uri.parse(
              "https://api.quran.com/api/v4/resources/recitations?language=ar"))
          .then((res) {
        setState(() {
          recitations = jsonDecode(res.body)["recitations"];
          selectedRecitation = recitations[0];
          // print(jsonDecode(res.body)["recitations"]);
        });
      })
    ]).then((v) => loading = false);
    super.initState();
  }

  @override
  void dispose() {
    _prefs.then((prefs) => prefs.setInt("page", page));
    _audioPlayer?.dispose();
    super.dispose();
  }

  List<Widget> getPages() {
    List<Widget> pages = [];
    for (int i = 0; i < 604; i++) {
      pages.add(QuranPage(
        pageNumber: i + 1,
        selectVerse: selectVerse,
        selectedVerse: selectedVerse,
      ));
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: page - 1);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: Colors.yellow.shade50),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: loading
            ? const IZDBLoading()
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                  titleTextStyle: const TextStyle(color: Colors.black),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("الجزء $juz")),
                      Expanded(
                          flex: 6,
                          child: SliderWidget(
                              value: page.toDouble(),
                              onChange: (v) {
                                setState(() {
                                  page = v.toInt();
                                  controller.jumpToPage(page - 1);
                                });
                              },
                              fullWidth: false,
                              max: 604,
                              min: 1,
                              sliderHeight: 50)),
                      Expanded(flex: 1, child: Text("$surahName")),
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: ExpansionTile(
                      backgroundColor: Colors.transparent,
                      collapsedBackgroundColor: Colors.transparent,
                      collapsedTextColor: Colors.white,
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      trailing: SizedBox(
                        width: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isPlaying
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (selectedVerse != null) {
                                        _audioPlayer?.pause().whenComplete(() {
                                          setState(() {
                                            isPlaying = false;
                                          });
                                        });
                                      }
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (selectedVerse != null) {
                                        setState(() {
                                          isPlaying = true;
                                        });
                                        http
                                            .get(Uri.parse(
                                                "https://api.quran.com/api/v4/recitations/${selectedRecitation?["id"] ?? 7}/by_ayah/${selectedVerse?["surah"]}:${selectedVerse?["id"]}"))
                                            .then((res) => _audioPlayer?.setUrl(
                                                "https://verses.quran.com/${jsonDecode(res.body)["audio_files"][0]["url"]}"))
                                            .then((v) => _audioPlayer?.stop())
                                            .then((v) => _audioPlayer
                                                    ?.play()
                                                    .whenComplete(() {
                                                  setState(() {
                                                    isPlaying = false;
                                                  });
                                                }));
                                      }
                                    },
                                  ),
                            SvgPicture.asset(
                              "assets/svg/website.svg",
                              color: Colors.white,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                      // tilePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      childrenPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      title: RotatedBox(
                        quarterTurns: 2,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: DropdownButton<Map>(
                            menuMaxHeight: 500,
                            alignment: Alignment.topCenter,
                            value: selectedRecitation,
                            onChanged: (Map? newValue) {
                              setState(() {
                                selectedRecitation = newValue!;
                              });
                            },
                            items:
                                recitations.map<DropdownMenuItem<Map>>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  '${value?["reciter_name"]}\n${value?["translated_name"]?["name"]}',
                                  textAlign: TextAlign.left,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      children: [
                        RotatedBox(
                          quarterTurns: 2,
                          child: Column(
                            children: [
                              Text(
                                selectedVerseTranslate?["AyahText"] ?? "",
                                textAlign: TextAlign.left,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                body: PageView(
                  controller: controller,
                  children: getPages(),
                  onPageChanged: (v) {
                    setState(() {
                      page = v + 1;
                      Map pageData = quran.getPageData(page)[0];
                      surahName = quran.getSurahNameArabic(pageData["surah"]);
                      juz = quran.getJuzNumber(
                          pageData["surah"], pageData["start"]);
                    });
                  },
                ),
              ),
      ),
    );
  }
}
