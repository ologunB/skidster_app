import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget regularText(
  String text, {
  Color color,
  double fontSize,
  double letterSpacing,
  TextAlign textAlign,
  int maxLines,
  TextOverflow overflow,
  TextDecoration decoration,
  FontWeight fontWeight,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: true,
    style: GoogleFonts.inter(
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration),
  );
}
