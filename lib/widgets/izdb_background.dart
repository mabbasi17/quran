import 'package:flutter/material.dart';
import 'package:izdb/main.dart';

class IZDBBackground extends StatelessWidget {
  const IZDBBackground({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage("assets/images/background-footer.png"),
              fit: BoxFit.cover,
              opacity: 0.5,
              colorFilter: ColorFilter.mode(
                  colors["izdbBackgroundColor"], BlendMode.color))),
      child: child,
    );
  }
}
