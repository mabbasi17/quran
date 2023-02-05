// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:izdb/screens/Quran/Slider/custom_slider_thumb_rect.dart';
import 'custom_slider_thumb_circle.dart';

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;
  final double value;
  final Function(double) onChange;

  SliderWidget(
      {this.sliderHeight = 48,
      this.max = 10,
      this.min = 0,
      this.fullWidth = false,
      required this.onChange,
      required this.value});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  // double _value = 0;

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (widget.fullWidth) paddingFactor = .3;

    return Container(
      width: widget.fullWidth
          ? double.infinity
          : (widget.sliderHeight) * 5.5,
      height: (widget.sliderHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((widget.sliderHeight * .3)),
        ),
        // gradient: new LinearGradient(
        //     colors: [
        //       const Color(0xFF00c6ff),
        //       const Color(0xFF0072ff),
        //     ],
        //     begin: const FractionalOffset(0.0, 0.0),
        //     end: const FractionalOffset(1.0, 1.00),
        //     stops: [0.0, 1.0],
        //     tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(widget.sliderHeight * paddingFactor,
            2, widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            // Text(
            //   '${this.widget.min}',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: this.widget.sliderHeight * .3,
            //     fontWeight: FontWeight.w700,
            //     color: Colors.white,
            //   ),
            // ),
            // SizedBox(
            //   width: this.widget.sliderHeight * .1,
            // ),
            Expanded(
              child: Center(
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      // activeTrackColor: Colors.white.withOpacity(1),
                      // inactiveTrackColor: Colors.white.withOpacity(.5),
                      activeTrackColor: Colors.grey.withOpacity(.5),
                      inactiveTrackColor: Colors.grey.withOpacity(.5),
                      thumbColor: Colors.grey,
                      trackHeight: 4.0,
                      thumbShape: CustomSliderThumbRect(
                        thumbHeight: 40,
                        thumbRadius: widget.sliderHeight * .4,
                        min: widget.min,
                        max: widget.max,
                      ),
                      // overlayColor: Colors.white.withOpacity(.4),
                      // valueIndicatorColor: Colors.white,
                      // activeTickMarkColor: Colors.white,
                      // inactiveTickMarkColor: Colors.red.withOpacity(.7),
                    ),
                    child: Slider(
                      value: widget.value,
                      onChanged: widget.onChange,
                      max: widget.max.toDouble(),
                      min: widget.min.toDouble(),
                    )),
              ),
            ),
            // SizedBox(
            //   width: this.widget.sliderHeight * .1,
            // ),
            // Text(
            //   '${this.widget.max}',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: this.widget.sliderHeight * .3,
            //     fontWeight: FontWeight.w700,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
