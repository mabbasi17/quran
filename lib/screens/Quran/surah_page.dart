import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/main.dart';
import 'package:izdb/screens/Quran/azkar_audio_player.dart';
import 'package:izdb/screens/Quran/quran.dart';
import 'package:izdb/screens/Quran/quran_plugin/quran.dart';
import 'package:izdb/widgets/izdb_background.dart';
import 'package:izdb/widgets/izdb_drawer.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:izdb/widgets/izdb_loading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({Key? key}) : super(key: key);

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String searchValue = "";
  List surahList = [];
  @override
  void initState() {
    for (int i = 1; i <= 114; i++) {
      surahList.add({
        "id": i,
        "nameAR": getSurahNameArabic(i),
        "nameDE": getSurahName(i),
        "pages": getSurahPages(i)
      });
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // appBar: const IZDBAppBar(title: "القرآن الكريم"),
        drawer: const IZDBDrawer(),
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Quran Al-Karem"),
              Tab(text: "Mathurat"),
              Tab(icon: Icon(Icons.search)),
            ],
          ),
          title: const Text('Quran Al-Karem / Mathurat'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  _prefs.then((prefs) => prefs.getInt("page")).then((value) =>
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  Quran(page: value ?? 293))));
                },
                icon: const Icon(Icons.book))
          ],
        ),
        body: IZDBBackground(
          child: TabBarView(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                primary: false,
                children: [
                  ...surahList
                      .map((e) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              Quran(page: e["pages"][0])));
                                },
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(e["id"].toString(),
                                      style: TextStyle(
                                          color: colors["izdbCardTextColor"])),
                                ),
                                trailing: Text(e["pages"][0].toString()),
                                title: Text(e["nameDE"],
                                    style: const TextStyle(fontSize: 20)),
                                subtitle: Text(e["nameAR"],
                                    style: const TextStyle(fontSize: 20)),
                              ),
                              const Divider(thickness: 1)
                            ],
                          ))
                      .toList()
                ],
              ),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    title: AzkarAudioPlayer(),
                  ),
                  body: FutureBuilder(
                    future: rootBundle.loadString('assets/json/dua.json').then(
                        (str) => jsonDecode(str)[2]["data"]), // async work
                    builder: (BuildContext context, dynamic snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const IZDBLoading();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            // Expanded(child: AzkarAudioPlayer()),
                            Expanded(
                                child: ListView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              primary: false,
                              children: snapshot.data
                                  .map<Widget>((e) => Column(
                                        children: [
                                          Container(
                                            height: 35,
                                            width: double.infinity,
                                            color: colors["izdbPrimaryColor"],
                                            child: Center(
                                              child: Text(e["dua_title"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: colors[
                                                          "izdbButtonTextColor"])),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(e["dua_arabic"],
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                          const SizedBox(height: 20),
                                          Text(e["dua_german"],
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                          const Divider(
                                              thickness: 2, height: 30),
                                        ],
                                      ))
                                  .toList(),
                            ))
                          ],
                        );
                      }
                    },
                  )),
              ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                primary: false,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      style: const TextStyle(fontSize: 20, height: 1.3),
                      controller: TextEditingController(text: searchValue),
                      decoration: izdbTextFieldDecoration.copyWith(
                          label: const Text("ابحث Suche"),
                          suffix: const Icon(Icons.search, color: Colors.grey)),
                      onSubmitted: (v) {
                        setState(() {
                          searchValue = v;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: http
                        .get(Uri.parse(
                            "https://api.quran.com/api/v4/search?q=$searchValue"))
                        .then(
                            (res) => jsonDecode(res.body)["search"]["results"]),
                    builder: (context, dynamic snapshot) {
                      if (snapshot.data != null) {
                        return Column(
                            children: snapshot.data
                                .map<Widget>((e) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ListTile(
                                          title: Text(e["text"],
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              textAlign: TextAlign.right),
                                          subtitle: Text(e["verse_key"]),
                                        ),
                                        const Divider(thickness: 1)
                                      ],
                                    ))
                                .toList());
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
