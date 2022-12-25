// ignore_for_file: file_names, unnecessary_null_comparison, duplicate_ignore, unused_import

import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_application_5/models/TouchPoints.dart';

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({required this.pointsList});
  List<TouchPoints> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    // Paint background = Paint()..color = Colors.white;
    // Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // canvas.drawRect(rect, background);
    // canvas.clipRect(rect);

    for (int i = 0; i < pointsList.length - 1; i++) {
      // ignore: unnecessary_null_comparison
      if (pointsList[i].points != null && pointsList[i + 1].points != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i + 1].points == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        // offsetPoints.add(Offset(
        //     pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
