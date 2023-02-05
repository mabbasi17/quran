import 'package:flutter/material.dart';
import 'package:izdb/widgets/izdb_app_bar.dart';
import 'package:izdb/widgets/izdb_background.dart';

class TimesImagesViewer extends StatelessWidget {
  const TimesImagesViewer({Key? key}) : super(key: key);
  getPages() {
    return List.generate(
        12,
        (i) => Image.asset("assets/images/prayer_times/${i + 1}.jpeg",
            fit: BoxFit.contain));
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller =
        PageController(initialPage: DateTime.now().month - 1);
    return Scaffold(
      appBar: AppBar(title: Text("Gebetszeiten أوقات الصلاة")),
      body: IZDBBackground(
        child: PageView(
          controller: controller,
          children: getPages(),
          onPageChanged: (v) {},
        ),
      ),
    );
  }
}
