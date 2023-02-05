import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izdb/widgets/izdb_app_bar.dart';
import 'package:izdb/widgets/izdb_background.dart';
import 'package:izdb/widgets/izdb_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:izdb/widgets/izdb_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  void _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  Map<String, Widget> linksIcons = {
    "phone": const Icon(Icons.call, size: 30),
    "location": const Icon(Icons.location_on, size: 30),
    "website": SvgPicture.asset("assets/svg/website.svg", width: 25),
    "instagram": SvgPicture.asset("assets/svg/instagram.svg", width: 25),
    "youtube": SvgPicture.asset("assets/svg/youtube.svg", width: 30),
    "facebook": SvgPicture.asset("assets/svg/facebook.svg", width: 30),
    "twitter": SvgPicture.asset("assets/svg/twitter.svg", width: 30),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const IZDBDrawer(),
        appBar: const IZDBAppBar(title: "تواصل معنا"),
        body: IZDBBackground(
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("content")
                .doc("aboutUs")
                .get(), // async work
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const IZDBLoading();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  primary: false,
                  children: [
                    Text(
                      snapshot.data?["aboutUsText"] ?? "",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: snapshot.data?["links"].entries
                          .where((e) => e.value != "" && e.value != null)
                          .map<Widget>((e) => IconButton(
                              onPressed: () => _launchUrl(e.value),
                              icon: linksIcons[e.key]!))
                          .toList(),
                    ),
                    const SizedBox(height: 100),
                  ],
                );
              }
            },
          ),
        ));
  }
}
