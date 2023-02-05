import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izdb/widgets/izdb_background.dart';

class IZDBLoading extends StatelessWidget {
  const IZDBLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IZDBBackground(
      child: Center(
          child: CupertinoActivityIndicator(
        radius: 50,
        color: Colors.black,
      )),
    );
  }
}
