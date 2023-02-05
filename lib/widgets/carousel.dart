// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Carousel extends StatefulWidget {
  final List<Widget> widgetsList;
  const Carousel({Key? key, required this.widgetsList}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<Carousel> {
  int _current = 0;
  List<Widget>? imageSliders;
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    imageSliders = widget.widgetsList
        .map((item) => Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: item,
                // child: ClipRRect(
                //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                //     child: Stack(
                //       children: <Widget>[
                //         item,
                //         Positioned(
                //           bottom: 0.0,
                //           left: 0.0,
                //           right: 0.0,
                //           child: Container(
                //             decoration: const BoxDecoration(
                //               gradient: LinearGradient(
                //                 colors: [
                //                   Color.fromARGB(200, 0, 0, 0),
                //                   Color.fromARGB(0, 0, 0, 0)
                //                 ],
                //                 begin: Alignment.bottomCenter,
                //                 end: Alignment.topCenter,
                //               ),
                //             ),
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 10.0, horizontal: 20.0),
                //             // child: Column(
                //             //   mainAxisAlignment: MainAxisAlignment.start,
                //             //   crossAxisAlignment: CrossAxisAlignment.stretch,
                //             //   children: [
                //             //     Text(
                //             //       item["title"],
                //             //       style: TextStyle(
                //             //         color: Colors.white,
                //             //         fontSize: 20.0,
                //             //         fontWeight: FontWeight.bold,
                //             //       ),
                //             //     ),
                //             //     Text(
                //             //       format.DateFormat('yyyy/MM/dd')
                //             //           .format(item["date"].toDate()),
                //             //       style: TextStyle(
                //             //         color: Colors.white,
                //             //         fontSize: 15.0,
                //             //         // fontWeight: FontWeight.bold,
                //             //       ),
                //             //     ),
                //             //   ],
                //             // ),
                //           ),
                //         ),
                //       ],
                //     )),
              ),
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              padEnds: false,
              // disableCenter: true,
              viewportFraction: 1,
              // aspectRatio: 2,
              height: 200,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.widgetsList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 6.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
