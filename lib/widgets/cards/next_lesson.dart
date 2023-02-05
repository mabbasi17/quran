// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/main.dart';

class NextLesson extends StatelessWidget {
  const NextLesson({Key? key, required this.lessonData}) : super(key: key);
  final Map lessonData;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "${lessonData["titleDE"]} - ${lessonData["titleAR"]}",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors["izdbCardTextColor"]),
            textAlign: TextAlign.center,
          ),
          const Divider(thickness: 1),
          Text(
            "${lessonData["day"]?["de"]} ${lessonData["day"]?["ar"]}",
            style: TextStyle(fontSize: 18, color: colors["izdbCardTextColor"]),
            textAlign: TextAlign.center,
          ),
          Text(
            "${lessonData["subTitleDE"]} - ${lessonData["subTitleAR"]}",
            style: TextStyle(fontSize: 16, color: colors["izdbCardTextColor"]),
            textAlign: TextAlign.center,
          ),
          Text(
            lessonData["time"],
            style: TextStyle(fontSize: 28, color: colors["izdbCardTextColor"]),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
              onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: colors["izdbCardColor"],
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lessonData["titleDE"],
                              style: TextStyle(
                                  color: colors["izdbCardTextColor"],
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "${lessonData["day"]?["de"]} ${lessonData["time"]}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: colors["izdbCardTextColor"])),
                            Text(lessonData["subTitleDE"],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(lessonData["descriptionDE"],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: colors["izdbCardTextColor"])),
                            const Divider(thickness: 1, height: 40),
                            Text(
                              lessonData["titleAR"],
                              style: TextStyle(
                                  color: colors["izdbPrimaryColor"],
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "${lessonData["day"]?["ar"]} ${lessonData["time"]}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: colors["izdbCardTextColor"])),
                            Text(lessonData["subTitleAR"],
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(lessonData["descriptionAR"],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: colors["izdbCardTextColor"])),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
              child: Text("Details - التفاصيل",
                  style: TextStyle(color: colors["izdbButtonTextColor"])))
        ],
      ),
    );
  }
}

// class NextLesson extends StatefulWidget {
//   const NextLesson({Key? key, required this.lessonData}) : super(key: key);
//   final Map lessonData;
//   @override
//   State<NextLesson> createState() => _NextLessonState();
// }
//
// class _NextLessonState extends State<NextLesson> {
//   Map lessonData = {};
//
//   @override
//   void initState() {
//     lessonData = widget.lessonData;
//
//     initializeDateFormatting();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0.0, 2.0),
//               blurRadius: 4.0,
//             ),
//           ]),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             "${lessonData["titleDE"]} - ${lessonData["titleAR"]}",
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           const Divider(thickness: 1),
//           Text(
//             "${lessonData["day"]?["de"]} ${lessonData["day"]?["ar"]}",
//             style: const TextStyle(fontSize: 22),
//             textAlign: TextAlign.center,
//           ),
//           Text(
//             "${lessonData["subTitleDE"]} - ${lessonData["subTitleAR"]}",
//             style: const TextStyle(fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//           Text(
//             lessonData["time"],
//             style: const TextStyle(fontSize: 24),
//             textAlign: TextAlign.center,
//           ),
//           ElevatedButton(
//               onPressed: () => showDialog<String>(
//                     context: context,
//                     builder: (BuildContext context) => AlertDialog(
//                       insetPadding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 20),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                       backgroundColor: izdbCardColor,
//                       content: SingleChildScrollView(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               lessonData["titleDE"],
//                               style: const TextStyle(
//                                   color: izdbPrimaryColor,
//                                   fontSize: 26,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                                 "${lessonData["day"]?["de"]} ${lessonData["time"]}",
//                                 style: const TextStyle(
//                                     fontSize: 18, color: izdbCardTextColor)),
//                             Text(lessonData["subTitleDE"],
//                                 style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 10),
//                             Text(lessonData["descriptionDE"],
//                                 style: const TextStyle(
//                                     fontSize: 18, color: izdbCardTextColor)),
//                             const Divider(thickness: 1, height: 40),
//                             Text(
//                               lessonData["titleAR"],
//                               style: const TextStyle(
//                                   color: izdbPrimaryColor,
//                                   fontSize: 26,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                                 "${lessonData["day"]?["ar"]} ${lessonData["time"]}",
//                                 style: const TextStyle(
//                                     fontSize: 18, color: izdbCardTextColor)),
//                             Text(lessonData["subTitleAR"],
//                                 style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 10),
//                             Text(lessonData["descriptionAR"],
//                                 textAlign: TextAlign.right,
//                                 style: const TextStyle(
//                                     fontSize: 18, color: izdbCardTextColor)),
//                           ],
//                         ),
//                       ),
//                       actions: <Widget>[
//                         ElevatedButton(
//                           onPressed: () => Navigator.pop(context, 'OK'),
//                           child: const Text('OK'),
//                         ),
//                       ],
//                     ),
//                   ),
//               child: Text("Show details - عرض التفاصيل"))
//         ],
//       ),
//     );
//   }
// }
