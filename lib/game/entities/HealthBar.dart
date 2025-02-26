import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class HealthBar extends PositionComponent {
  double currentHealth;
  double maxHealth;
  Color fillColor;
  Color borderColor;
  String label;

  HealthBar({
    required this.currentHealth,
    required this.maxHealth,
    this.fillColor = const Color(0xFFFF0000), // Standard: Rot
    this.borderColor = const Color(0xFF000000),
    this.label = 'Leben',
    Vector2? position,
    Vector2? size,
  }) : super(
    position: position ?? Vector2.zero(),
    size: size ?? Vector2(100, 10),
  );

  @override
  void render(Canvas canvas) {
    // Zeichne den gefüllten Bereich (Füllbreite basiert auf currentHealth / maxHealth)
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final fillWidth = (currentHealth / maxHealth) * size.x;
    final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.y);
    canvas.drawRect(fillRect, fillPaint);

    // Zeichne den Rahmen
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final borderRect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRect(borderRect, borderPaint);

    // Zeichne den Label-Text oberhalb der HealthBar (z.B. "Leben")
    final labelSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: Color(0xFF000000),
        fontSize: 24, // Schriftgröße passt sich an die Höhe der Bar an
        fontWeight: FontWeight.bold,
      ),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    // Zentriert oberhalb, z.B. 4 Pixel Abstand
    final labelPosition = Offset(
      (size.x - labelPainter.width) / 8,
      -labelPainter.height - 4,
    );
    labelPainter.paint(canvas, labelPosition);

    // Zeichne den dynamischen Text innerhalb der HealthBar (z.B. "80/100")
    final healthText = "${currentHealth.round()}/${maxHealth.round()}";
    final healthSpan = TextSpan(
      text: healthText,
      style: TextStyle(
        color: const Color(0xFF000000),
        fontSize: size.y * 0.8, // Etwas kleinere Schrift
        fontWeight: FontWeight.bold,
      ),
    );
    final healthPainter = TextPainter(
      text: healthSpan,
      textDirection: TextDirection.ltr,
    );
    healthPainter.layout();
    // Zentriere den Text in der HealthBar
    final healthPosition = Offset(
      (size.x - healthPainter.width) / 2,
      (size.y - healthPainter.height) / 2,
    );
    healthPainter.paint(canvas, healthPosition);
  }
}
