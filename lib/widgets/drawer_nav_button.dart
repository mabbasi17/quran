import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izdb/main.dart';

class DrawerNavButton extends StatelessWidget {
  const DrawerNavButton(
      {Key? key,
      required this.title,
      required this.imgPath,
      required this.onPressed})
      : super(key: key);
  final String title;
  final String imgPath;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ))),
        child: Image.asset("assets/images/$imgPath",
            color: colors["izdbButtonTextColor"]));
  }
}

// class DrawerNavButton extends StatelessWidget {
//   const DrawerNavButton(
//       {Key? key,
//         required this.title,
//         required this.svgPath,
//         required this.onPressed})
//       : super(key: key);
//   final String title;
//   final String svgPath;
//   final Function() onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SvgPicture.asset("assets/svg/$svgPath",
//               color: colors["izdbButtonTextColor"], width: 60, height: 60),
//           const SizedBox(height: 15),
//           Text(title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: colors["izdbButtonTextColor"],
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20)),
//         ],
//       ),
//     );
//   }
// }
