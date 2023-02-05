import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/widgets/cards/next_lesson.dart';
import 'package:izdb/widgets/carousel.dart';
import 'package:collection/collection.dart';

class ComingLessons extends StatefulWidget {
  const ComingLessons({Key? key}) : super(key: key);

  @override
  State<ComingLessons> createState() => _ComingLessonsState();
}

class _ComingLessonsState extends State<ComingLessons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        width: double.infinity,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("content")
              .doc("lessons")
              .get(), // async work
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: const CupertinoActivityIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data?.data()?["lessonsList"] != null &&
                  snapshot.data?.data()?["lessonsList"].length > 0) {
                return Carousel(
                    widgetsList: snapshot.data
                        ?.data()?["lessonsList"]
                        .where((e) => e["hidden"] != false)
                        .map<Widget>((e) => NextLesson(lessonData: {
                              ...e,
                              "day": daysKeys[daysKeys.keys
                                  .firstWhereOrNull((el) => el == e["day"])]
                            }))
                        .toList());
              } else {
                // TOD: remove button
                // return TextButton(
                //     onPressed: () {
                //       FirebaseFirestore.instance
                //           .collection("content")
                //           .doc("lessons")
                //           .set({"lessonsList": lessonsListFb});
                //     },
                //     child: Text("Test"));
                return Container();
              }
            }
          },
        ));
  }
}
