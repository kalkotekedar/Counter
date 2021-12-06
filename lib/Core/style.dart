import 'package:flutter/cupertino.dart';

import '../import.dart';

appText(
  String text, {
  bool isBold = false,
  bool isUnderline = false,
  Color color = Colors.grey,
  double size = 14,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}
