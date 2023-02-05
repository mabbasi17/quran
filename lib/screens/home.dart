import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:izdb/widgets/coming_lessons.dart';
import 'package:izdb/widgets/izdb_app_bar.dart';
import 'package:izdb/widgets/izdb_background.dart';
import 'package:izdb/widgets/izdb_drawer.dart';
import 'package:izdb/widgets/cards/next_prayer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Erneut drücken, um zu beenden");

      SystemNavigator.pop();
      return Future.value(false);
    }
    Navigator.pushNamed(context, '/home');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const IZDBDrawer(),
      appBar: const IZDBAppBar(title: "الرئيسية"),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: IZDBBackground(
          child: ListView(
            primary: false,
            children: const [
              SizedBox(height: 10),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: NextPrayer()),
              // const SizedBox(height: 15),
              ComingLessons(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FirebaseMessaging.instance.subscribeToTopic("fcm_test");
          showDialog<String>(
            context: context,
            builder: (BuildContext alertContext) => AlertDialog(
              title: Text(
                "Spenden - التبرع",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colors["izdbPrimaryColor"],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: colors["izdbCardColor"],
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "قُلْ إِنَّ رَبِّي يَبْسُطُ الرِّزْقَ لِمَنْ يَشَاءُ مِنْ عِبَادِهِ وَيَقْدِرُ لَهُ ۚ وَمَا أَنْفَقْتُمْ مِنْ شَيْءٍ فَهُوَ يُخْلِفُهُ ۖ وَهُوَ خَيْرُ الرَّازِقِينَ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: colors["izdbCardTextColor"], fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Sag: Gewiß, mein Herr gewährt die Versorgung großzügig, wem von Seinen Dienern Er will, und bemißt auch. Und was immer ihr auch ausgebt, so wird Er es euch ersetzen, und Er ist der Beste der Versorger.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: colors["izdbCardTextColor"], fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: SvgPicture.asset("assets/svg/Sparkasse.svg",
                          width: 30),
                      title: const Text("IBAN: DE73 1005 0000 0190 3490 18"),
                      subtitle: const Text("BIC: BELADEBEXXX"),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => Clipboard.setData(const ClipboardData(
                                text:
                                    "https://www.paypal.com/paypalme/spendenfuermoschee?locale.x=de_DE"))
                            .then((value) => ScaffoldMessenger.of(alertContext)
                                .showSnackBar(const SnackBar(
                                    content: Text('تم النسخ إلى الحافظة')))),
                      ),
                    ),
                    ListTile(
                      leading:
                          SvgPicture.asset("assets/svg/paypal.svg", width: 30),
                      title: ElevatedButton(
                          onPressed: () => launchUrl(Uri.parse(
                              "https://www.paypal.com/paypalme/spendenfuermoschee?locale.x=de_DE")),
                          child: const Text('Jetzt Spenden')),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.pop(alertContext, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        tooltip: 'Donate',
        child: SvgPicture.asset(
          "assets/svg/donation.svg",
          width: 30,
          color: colors["izdbButtonTextColor"],
        ),
      ),
    );
  }
}
