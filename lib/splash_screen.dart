import 'package:flutter/material.dart';
import 'package:movie_app/home_page.dart';
import 'dart:async';
import 'dart:math';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  SplashScreenPageState createState() =>
      SplashScreenPageState();
}

class SplashScreenPageState
    extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700), // Total duration for the rotation
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _progress = _animation.value;
        });
      });

    _controller.repeat();

     // Set a timer to navigate to the HomePage after 10 seconds
    _timer = Timer(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(200, 200),
              painter: CircularProgressPainter(_progress),
            ),
            const Text(
              'wework',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;

  CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double outerStrokeWidth = 2.0;
    double innerStrokeWidth = 6.0;

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = innerStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    double innerRadius = (size.width / 2) - innerStrokeWidth / 2;
    double outerRadius = (size.width / 2) - outerStrokeWidth / 2;
    double angle = 2 * pi * progress;


    // Draw the full background circle
    Paint backgroundPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = outerStrokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), outerRadius, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: innerRadius),
      0,
      angle,
      false,
      paint,
    );


  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}