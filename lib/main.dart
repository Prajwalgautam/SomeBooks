import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(SpinningGame());
}

class SpinningGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Casino Spinning Game'),
        ),
        body: SpinningWheel(),
      ),
    );
  }
}

class SpinningWheel extends StatefulWidget {
  @override
  _SpinningWheelState createState() => _SpinningWheelState();
}

class _SpinningWheelState extends State<SpinningWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<String> prizes = [
    'Prize 1',
    'Prize 2',
    'Prize 3',
    'Prize 4',
    'Prize 5',
    'Prize 6'
  ];
  int selectedPrizeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showPrizeDialog(prizes[selectedPrizeIndex]);
      }
    });
  }

  void _spinWheel() {
    setState(() {
      selectedPrizeIndex = Random().nextInt(prizes.length);
      double targetAngle = 2 * pi * 5 + // Spin around multiple times
          (2 * pi * selectedPrizeIndex / prizes.length);

      _controller.reset();
      _animation = Tween<double>(
        begin: _animation.value,
        end: targetAngle,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );

      _controller.forward();
    });
  }

  void _showPrizeDialog(String prize) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Congratulations!"),
        content: Text("You won $prize!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _animation.value,
                child: CustomPaint(
                  size: Size(300, 300),
                  painter: WheelPainter(prizes),
                ),
              ),
              Positioned(
                child: CustomPaint(
                  size: Size(20, 20),
                  painter: TrianglePainter(color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _spinWheel,
            child: Text('Spin the Wheel!'),
          ),
        ],
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<String> prizes;

  WheelPainter(this.prizes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final double sweepAngle = 2 * pi / prizes.length;
    final double radius = size.width / 2;

    final List<Color> segmentColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];

    for (int i = 0; i < prizes.length; i++) {
      paint.color = segmentColors[i % segmentColors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        i * sweepAngle,
        sweepAngle,
        true,
        paint,
      );

      final textSpan = TextSpan(
        text: prizes[i],
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.text = textSpan;
      textPainter.layout();

      final angle = i * sweepAngle + sweepAngle / 2;
      final textOffset = Offset(
        radius + radius * 0.7 * cos(angle),
        radius + radius * 0.7 * sin(angle),
      );

      canvas.save();
      canvas.translate(textOffset.dx, textOffset.dy);
      canvas.rotate(angle + pi / 2);
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
