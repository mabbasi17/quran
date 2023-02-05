import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:izdb/screens/Quran/quran_plugin/quran.dart' as quran;

class QuranPage extends StatefulWidget {
  const QuranPage(
      {Key? key,
      required this.pageNumber,
      required this.selectVerse,
      this.selectedVerse})
      : super(key: key);
  final int pageNumber;
  final Function selectVerse;
  final Map? selectedVerse;

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  int juz = 0;
  List pageVerses = [];
  Map? selectedVerse;

  @override
  void initState() {
    pageVerses = quran.getVersesTextByPage(widget.pageNumber,
        verseEndSymbol: true,
        surahSeperator: quran.SurahSeperator.surahNameWithBasmala);
    List pageData = quran.getPageData(widget.pageNumber);
    juz = quran.getJuzNumber(pageData[0]["surah"], pageData[0]["start"]);
    // print(quran.getVerseURL(pageData[0]["surah"], pageData[0]["start"]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            children: pageVerses.mapIndexed((i, e) {
              if (e["surahSeperator"] != null) {
                return WidgetSpan(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 2, top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/sura-name-cover.png"),
                                fit: BoxFit.fitWidth)),
                        height: 40,
                        child: Center(
                          child: Text(
                            e["surahSeperator"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: ''),
                          ),
                        ),
                      ),
                      e["surahSeperator"] != "التوبة"
                          ? Image.asset(
                              "assets/images/basmala.png",
                              fit: BoxFit.contain,
                              height: 40,
                            )
                          : const SizedBox(height: 10),
                    ],
                  ),
                ));
              } else {
                return TextSpan(
                  text: e["verse"],
                  style: TextStyle(
                      backgroundColor:
                          (e["surah"] == widget.selectedVerse?["surah"] &&
                                  e["id"] == widget.selectedVerse?["id"])
                              ? Colors.blue.shade100
                              : null),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.selectVerse(e);
                    },
                );
              }
            }).toList(),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 21,
                fontFamily: 'Amiri',
                height: 1.8),
          ),
        ),
      ),
    );
  }
}
