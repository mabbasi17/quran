// ignore_for_file: unused_import

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/main.dart';
import 'package:izdb/screens/notification_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class IZDBAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IZDBAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      flexibleSpace: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('assets/images/zakhrafa.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              opacity: 0.5,
              colorFilter: ColorFilter.mode(
                  colors["izdbBackgroundColor"], BlendMode.srcATop)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    height: 130,
                    left: 0,
                    right: 0,
                    bottom: 5,
                    child: Image.asset(
                      "assets/images/appbar.png",
                      fit: BoxFit.contain,
                      color: colors["izdbButtonTextColor"],
                    )),
                Positioned(
                    height: 10,
                    left: 0,
                    right: 0,
                    bottom: -15,
                    child: Image.asset(
                      "assets/images/bar.png",
                      fit: BoxFit.fitWidth,
                      color: colors["izdbButtonTextColor"],
                    )),
                Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu),
                        color: colors["izdbButtonTextColor"])),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("content")
                            .doc("livestream")
                            .snapshots(),
                        builder: (_,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          var url = snapshot.data?.data()?["url"];
                          return Visibility(
                            visible: url != null && url != "",
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, top: 8),
                              child: Badge(
                                shape: BadgeShape.square,
                                badgeContent: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: const Text("LIVE",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                borderRadius: BorderRadius.circular(15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: IconButton(
                                    onPressed: () async =>
                                        await launchUrl(Uri.parse(url)),
                                    icon: Icon(Icons.live_tv,
                                        color: colors["izdbButtonTextColor"])),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(width: 10),
                    const NotificationsIcon(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
