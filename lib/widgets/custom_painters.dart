import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomPainters {
  static CustomPainter get sessionIllustration => _SessionIllustrationPainter();
  static CustomPainter get counsellingIllustration => _CounsellingIllustrationPainter();
  static CustomPainter get sapIllustration => _SapIllustrationPainter();
  static CustomPainter get doctorIllustration => _DoctorIllustrationPainter();
}

class _SessionIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final blobPath = Path()
      ..moveTo(w * 0.1, h * 0.5)
      ..quadraticBezierTo(w * 0.0, h * 0.1, w * 0.5, h * 0.05)
      ..quadraticBezierTo(w * 1.0, h * 0.0, w * 0.95, h * 0.5)
      ..quadraticBezierTo(w * 1.0, h * 0.95, w * 0.5, h * 1.0)
      ..quadraticBezierTo(w * 0.0, h * 1.05, w * 0.1, h * 0.5)
      ..close();
    canvas.drawPath(blobPath, Paint()..color = const Color(0xFFD6E8F7));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.2, h * 0.1, w * 0.6, h * 0.45),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF5B4FCF),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.24, h * 0.14, w * 0.52, h * 0.37),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFEEEEFF),
    );

    final barPaint = Paint()..color = const Color(0xFF7C6FF7);
    for (int i = 0; i < 4; i++) {
      final barH = [0.12, 0.20, 0.15, 0.25][i] * h;
      canvas.drawRect(
        Rect.fromLTWH(
          w * 0.28 + i * w * 0.10,
          h * 0.14 + (h * 0.37 - barH) - h * 0.04,
          w * 0.07,
          barH,
        ),
        barPaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(w * 0.46, h * 0.55, w * 0.08, h * 0.08),
      Paint()..color = const Color(0xFF5B4FCF),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.35, h * 0.63, w * 0.30, h * 0.04),
      Paint()..color = const Color(0xFF5B4FCF),
    );

    canvas.drawCircle(
      Offset(w * 0.18, h * 0.62),
      w * 0.065,
      Paint()..color = const Color(0xFFFFB347),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.11, h * 0.68, w * 0.14, h * 0.18),
      Paint()..color = const Color(0xFF7C6FF7),
    );

    canvas.drawCircle(
      Offset(w * 0.82, h * 0.62),
      w * 0.065,
      Paint()..color = const Color(0xFFFFB347),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.75, h * 0.68, w * 0.14, h * 0.15),
      Paint()..color = const Color(0xFFFF7043),
    );

    canvas.drawOval(
      Rect.fromLTWH(w * 0.0, h * 0.55, w * 0.14, h * 0.25),
      Paint()..color = const Color(0xFF66BB6A),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.86, h * 0.60, w * 0.14, h * 0.22),
      Paint()..color = const Color(0xFF66BB6A),
    );
    canvas.drawCircle(
      Offset(w * 0.82, h * 0.88),
      w * 0.06,
      Paint()..color = const Color(0xFFFF7043),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CounsellingIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final screenPaint = Paint()..color = AppColors.counsellingButton;
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.28, h * 0.04, w * 0.68, h * 0.50),
      const Radius.circular(5),
    );
    canvas.drawRRect(screenRect, screenPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.31, h * 0.08, w * 0.62, h * 0.41),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFEFF4FB),
    );

    final barColors = [
      AppColors.counsellingButton,
      AppColors.counsellingButton,
      AppColors.counsellingButton,
      const Color(0xFFFF8C42),
    ];
    final barHeights = [0.12, 0.19, 0.14, 0.22];
    for (int i = 0; i < 4; i++) {
      final bh = barHeights[i] * h;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            w * 0.35 + i * w * 0.13,
            h * 0.08 + (h * 0.41 - bh) - h * 0.04,
            w * 0.09,
            bh,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = barColors[i],
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(w * 0.56, h * 0.54, w * 0.08, h * 0.07),
      Paint()..color = AppColors.counsellingButton,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.46, h * 0.60, w * 0.28, h * 0.04),
        const Radius.circular(2),
      ),
      Paint()..color = AppColors.counsellingButton,
    );

    canvas.drawCircle(
      Offset(w * 0.88, h * 0.17),
      w * 0.09,
      Paint()..color = const Color(0xFFFFB347),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.78, h * 0.28, w * 0.20, h * 0.32),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF5B9BD5),
    );

    final armPath = Path()
      ..moveTo(w * 0.78, h * 0.34)
      ..quadraticBezierTo(w * 0.58, h * 0.30, w * 0.62, h * 0.28);
    canvas.drawPath(
      armPath,
      Paint()
        ..color = const Color(0xFF5B9BD5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.07
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.79, h * 0.59, w * 0.08, h * 0.24),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2D4A7A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.89, h * 0.59, w * 0.08, h * 0.24),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2D4A7A),
    );

    canvas.drawCircle(
      Offset(w * 0.14, h * 0.25),
      w * 0.09,
      Paint()..color = const Color(0xFFFFB347),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.36, w * 0.20, h * 0.26),
        const Radius.circular(4),
      ),
      Paint()..color = AppColors.counsellingButton,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.02, h * 0.58, w * 0.24, h * 0.07),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2D4A7A),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.00, h * 0.64, w * 0.28, h * 0.04),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF8BA8C8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * -0.02, h * 0.36, w * 0.04, h * 0.28),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF8BA8C8),
    );

    for (double x in [w * 0.02, w * 0.22]) {
      canvas.drawRect(
        Rect.fromLTWH(x, h * 0.68, w * 0.04, h * 0.18),
        Paint()..color = const Color(0xFF8BA8C8),
      );
    }

    canvas.drawCircle(
      Offset(w * 0.93, h * 0.06),
      w * 0.07,
      Paint()..color = AppColors.counsellingButton,
    );
    canvas.drawCircle(
      Offset(w * 0.93, h * 0.06),
      w * 0.04,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SapIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPath = Path()
      ..moveTo(w * 0.25, h * 0.52)
      ..lineTo(w * 0.15, h * 1.00)
      ..lineTo(w * 0.85, h * 1.00)
      ..lineTo(w * 0.75, h * 0.52)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFF7D4E2D));

    final shirtPath = Path()
      ..moveTo(w * 0.28, h * 0.48)
      ..lineTo(w * 0.20, h * 0.70)
      ..lineTo(w * 0.80, h * 0.70)
      ..lineTo(w * 0.72, h * 0.48)
      ..close();
    canvas.drawPath(shirtPath, Paint()..color = const Color(0xFFA0653A));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.30, w * 0.14, h * 0.10),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );

    canvas.drawOval(
      Rect.fromLTWH(w * 0.28, h * 0.04, w * 0.44, h * 0.30),
      Paint()..color = const Color(0xFFFFCC99),
    );

    final hairPath = Path()
      ..moveTo(w * 0.28, h * 0.16)
      ..quadraticBezierTo(w * 0.30, h * 0.02, w * 0.50, h * 0.02)
      ..quadraticBezierTo(w * 0.70, h * 0.02, w * 0.72, h * 0.16)
      ..quadraticBezierTo(w * 0.68, h * 0.08, w * 0.50, h * 0.07)
      ..quadraticBezierTo(w * 0.32, h * 0.08, w * 0.28, h * 0.16)
      ..close();
    canvas.drawPath(hairPath, Paint()..color = const Color(0xFF3E2000));

    canvas.drawOval(
      Rect.fromLTWH(w * 0.24, h * 0.10, w * 0.10, h * 0.18),
      Paint()..color = const Color(0xFF3E2000),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.66, h * 0.10, w * 0.10, h * 0.18),
      Paint()..color = const Color(0xFF3E2000),
    );

    final bookPath = Path()
      ..moveTo(w * 0.30, h * 0.50)
      ..lineTo(w * 0.50, h * 0.44)
      ..lineTo(w * 0.70, h * 0.50)
      ..lineTo(w * 0.70, h * 0.72)
      ..lineTo(w * 0.50, h * 0.66)
      ..lineTo(w * 0.30, h * 0.72)
      ..close();
    canvas.drawPath(bookPath, Paint()..color = const Color(0xFF4CAF50));

    canvas.drawLine(
      Offset(w * 0.50, h * 0.44),
      Offset(w * 0.50, h * 0.66),
      Paint()
        ..color = const Color(0xFF2E7D32)
        ..strokeWidth = 1.5,
    );

    for (double yFrac in [0.52, 0.57, 0.62]) {
      canvas.drawLine(
        Offset(w * 0.34, h * yFrac),
        Offset(w * 0.48, h * (yFrac - 0.02)),
        Paint()
          ..color = Colors.white.withAlpha(120)
          ..strokeWidth = 1.2,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.52, w * 0.20, h * 0.10),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.68, h * 0.52, w * 0.20, h * 0.10),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DoctorIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final blobPaint = Paint()..color = const Color(0xFF1A6B72);
    final blobPath = Path()
      ..moveTo(w * 0.0, h * 0.55)
      ..quadraticBezierTo(w * 0.0, h * 1.05, w * 0.50, h * 1.05)
      ..quadraticBezierTo(w * 1.0, h * 1.05, w * 1.0, h * 0.55)
      ..quadraticBezierTo(w * 1.0, h * 0.30, w * 0.50, h * 0.32)
      ..quadraticBezierTo(w * 0.0, h * 0.30, w * 0.0, h * 0.55)
      ..close();
    canvas.drawPath(blobPath, blobPaint);

    final scrubsPath = Path()
      ..moveTo(w * 0.20, h * 0.60)
      ..lineTo(w * 0.15, h * 1.00)
      ..lineTo(w * 0.85, h * 1.00)
      ..lineTo(w * 0.80, h * 0.60)
      ..quadraticBezierTo(w * 0.65, h * 0.52, w * 0.50, h * 0.52)
      ..quadraticBezierTo(w * 0.35, h * 0.52, w * 0.20, h * 0.60)
      ..close();
    canvas.drawPath(scrubsPath, Paint()..color = const Color(0xFF2E9E7A));

    final vNeckPath = Path()
      ..moveTo(w * 0.40, h * 0.52)
      ..lineTo(w * 0.50, h * 0.65)
      ..lineTo(w * 0.60, h * 0.52);
    canvas.drawPath(
      vNeckPath,
      Paint()
        ..color = const Color(0xFF1A7A5E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    final leftArm = Path()
      ..moveTo(w * 0.18, h * 0.65)
      ..quadraticBezierTo(w * 0.20, h * 0.80, w * 0.55, h * 0.82);
    canvas.drawPath(
      leftArm,
      Paint()
        ..color = const Color(0xFF2E9E7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.13
        ..strokeCap = StrokeCap.round,
    );

    final rightArm = Path()
      ..moveTo(w * 0.82, h * 0.65)
      ..quadraticBezierTo(w * 0.80, h * 0.80, w * 0.45, h * 0.82);
    canvas.drawPath(
      rightArm,
      Paint()
        ..color = const Color(0xFF2E9E7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.13
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawOval(
      Rect.fromLTWH(w * 0.44, h * 0.78, w * 0.22, h * 0.12),
      Paint()..color = const Color(0xFF80CBC4),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.42, h * 0.34, w * 0.16, h * 0.10),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );

    canvas.drawOval(
      Rect.fromLTWH(w * 0.28, h * 0.06, w * 0.44, h * 0.34),
      Paint()..color = const Color(0xFFFFCC99),
    );

    final capPath = Path()
      ..moveTo(w * 0.26, h * 0.20)
      ..quadraticBezierTo(w * 0.28, h * 0.02, w * 0.50, h * 0.01)
      ..quadraticBezierTo(w * 0.72, h * 0.02, w * 0.74, h * 0.20)
      ..quadraticBezierTo(w * 0.60, h * 0.16, w * 0.50, h * 0.16)
      ..quadraticBezierTo(w * 0.40, h * 0.16, w * 0.26, h * 0.20)
      ..close();
    canvas.drawPath(capPath, Paint()..color = const Color(0xFF2E9E7A));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.26, h * 0.17, w * 0.48, h * 0.05),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF1A7A5E),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.29, h * 0.24, w * 0.42, h * 0.16),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF80CBC4),
    );

    for (double yFrac in [0.28, 0.32, 0.36]) {
      canvas.drawLine(
        Offset(w * 0.32, h * yFrac),
        Offset(w * 0.68, h * yFrac),
        Paint()
          ..color = const Color(0xFF4DB6AC)
          ..strokeWidth = 1.0,
      );
    }

    canvas.drawOval(
      Rect.fromLTWH(w * 0.34, h * 0.17, w * 0.10, h * 0.06),
      Paint()..color = const Color(0xFF1A1A2E),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.56, h * 0.17, w * 0.10, h * 0.06),
      Paint()..color = const Color(0xFF1A1A2E),
    );

    final browPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.33, h * 0.155),
      Offset(w * 0.45, h * 0.150),
      browPaint,
    );
    canvas.drawLine(
      Offset(w * 0.55, h * 0.150),
      Offset(w * 0.67, h * 0.155),
      browPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
