import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izdb/main.dart';
import 'package:izdb/screens/Qibla/qibla.dart';
import 'package:izdb/screens/Quran/surah_page.dart';
import 'package:izdb/screens/Settings/settings_page.dart';
import 'package:izdb/screens/about_us.dart';
import 'package:izdb/screens/contact_us.dart';
import 'package:izdb/screens/PrayerTimes/prayer_times.dart';
import 'package:izdb/widgets/drawer_nav_button.dart';
import 'package:izdb/widgets/izdb_background.dart';

class IZDBDrawer extends StatelessWidget {
  const IZDBDrawer({Key? key}) : super(key: key);

  navigateTo(Widget page, context) {
    Navigator.pop(context);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors["izdbBackgroundColor"],
      width: double.infinity,
      semanticLabel: "القائمة",
      child: IZDBBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  primary: false,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 40,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    DrawerNavButton(
                      title: "Gebetszeiten\nأوقات الصلاة",
                      imgPath: "gebetszeiten.png",
                      onPressed: () => navigateTo(const PrayerTimes(), context),
                    ),
                    DrawerNavButton(
                      title: "Qibla\nالقبلة",
                      imgPath: "qibla.png",
                      onPressed: () => navigateTo(Qibla(), context),
                    ),
                    DrawerNavButton(
                      title: "Koran\nالقرآن الكريم",
                      imgPath: "koran.png",
                      onPressed: () => navigateTo(const SurahPage(), context),
                    ),
                    DrawerNavButton(
                      title: "Über uns\nمن نحن",
                      imgPath: "uberuns.png",
                      onPressed: () => navigateTo(const AboutUs(), context),
                    ),
                    DrawerNavButton(
                      title: "Kontakt\nتواصل معنا",
                      imgPath: "kontakt.png",
                      onPressed: () => navigateTo(const ContactUs(), context),
                    ),
                    DrawerNavButton(
                      title: "Einstellungen\nالإعدادات",
                      imgPath: "einstellung.png",
                      onPressed: () =>
                          navigateTo(const SettingsPage(), context),
                    ),
                    // DrawerNavButton(
                    //   title: "Gebetszeiten\nأوقات الصلاة",
                    //   svgPath: "mosque.svg",
                    //   onPressed: () => navigateTo(const PrayerTimes(), context),
                    // ),
                    // DrawerNavButton(
                    //   title: "Qibla\nالقبلة",
                    //   svgPath: "qibla.svg",
                    //   onPressed: () => navigateTo(Qibla(), context),
                    // ),
                    // DrawerNavButton(
                    //   title: "Koran\nالقرآن الكريم",
                    //   svgPath: "quran.svg",
                    //   onPressed: () => navigateTo(const SurahPage(), context),
                    // ),
                    // DrawerNavButton(
                    //   title: "Über uns\nمن نحن",
                    //   svgPath: "info.svg",
                    //   onPressed: () => navigateTo(const AboutUs(), context),
                    // ),
                    // DrawerNavButton(
                    //   title: "Kontakt\nتواصل معنا",
                    //   svgPath: "message.svg",
                    //   onPressed: () => navigateTo(const ContactUs(), context),
                    // ),
                    // DrawerNavButton(
                    //   title: "Einstellungen\nالإعدادات",
                    //   svgPath: "setting.svg",
                    //   onPressed: () =>
                    //       navigateTo(const SettingsPage(), context),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
