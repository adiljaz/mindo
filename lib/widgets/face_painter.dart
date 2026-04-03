import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  final FaceType faceType;

  const FacePainter(this.faceType);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Eyes
    canvas.drawCircle(
      Offset(w * 0.35, h * 0.38),
      w * 0.075,
      Paint()..color = const Color(0xFF1A1A2E),
    );
    canvas.drawCircle(
      Offset(w * 0.65, h * 0.38),
      w * 0.075,
      Paint()..color = const Color(0xFF1A1A2E),
    );

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    switch (faceType) {
      case FaceType.veryLow:
      case FaceType.low:
        mouthPath.moveTo(w * 0.28, h * 0.70);
        mouthPath.quadraticBezierTo(w * 0.50, h * 0.56, w * 0.72, h * 0.70);
        break;
      case FaceType.neutral:
        mouthPath.moveTo(w * 0.28, h * 0.66);
        mouthPath.lineTo(w * 0.72, h * 0.66);
        break;
      case FaceType.good:
      case FaceType.great:
        mouthPath.moveTo(w * 0.28, h * 0.58);
        mouthPath.quadraticBezierTo(w * 0.50, h * 0.78, w * 0.72, h * 0.58);
        break;
    }
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) =>
      oldDelegate.faceType != faceType;
}

enum FaceType { veryLow, low, neutral, good, great }
