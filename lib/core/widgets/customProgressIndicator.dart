import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../functions.dart';


startLoading(){
  Get.dialog(showLoader(), barrierDismissible: false,);
}
stopLoading(){
  Get.back();
}
class RoundCapCircularProgressIndicator extends StatelessWidget {
  final double value;
  final String title;
  final Color backgroundColor;
  final Color valueColor;
  final double strokeWidth;

  const RoundCapCircularProgressIndicator({super.key,
    this.value = 0.0,
    this.backgroundColor = const Color(0xFFE9E9E9),
    this.valueColor = kPrimaryColor,
    this.strokeWidth = 4.0,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(),
        CustomPaint(
          painter: _RoundCapCircularProgressIndicatorPainter(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
          ),
        ),
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundCapCircularProgressIndicatorPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;
  final Color valueColor;
  final double strokeWidth;

  _RoundCapCircularProgressIndicatorPainter({
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var rect = const Offset(0, 0) & size;
    var startAngle = -math.pi / 2;
    var sweepAngle = 2 * math.pi * value;
    var useRoundCap = true;

    var backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    var valuePaint = Paint()
      ..color = valueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = useRoundCap ? StrokeCap.round : StrokeCap.butt;

    canvas.drawArc(rect, startAngle, 2 * math.pi, false, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, valuePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class RoundCapCircularProgressIndicatorStream extends StatefulWidget {
  @override
  _RoundCapCircularProgressIndicatorStreamState createState() => _RoundCapCircularProgressIndicatorStreamState();
}

class _RoundCapCircularProgressIndicatorStreamState extends State<RoundCapCircularProgressIndicatorStream> {
  double _progressValue = 0;
  late StreamController<double> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<double>();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_progressValue < 1) {
        _progressValue += 0.01;
        _streamController.sink.add(_progressValue);
      } else {
        timer.cancel();
        _streamController.close();
      }
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Generating..."),
            if (snapshot.hasData)
              RoundCapCircularProgressIndicator(
                value: snapshot.data!,
              ),
          ],
        );
      },
    );
  }
}