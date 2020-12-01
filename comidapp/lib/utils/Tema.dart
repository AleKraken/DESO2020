import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData temaPrincipal() {
  TextTheme _temaTextoPrincipal(TextTheme base) {
    return base.copyWith(
        headline1: base.headline1.copyWith(
          fontFamily: GoogleFonts.baiJamjuree().fontFamily,
          fontSize: 18.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        headline2: base.headline1.copyWith(
          fontFamily: GoogleFonts.baiJamjuree().fontFamily,
          fontSize: 16.0,
          color: Colors.black,
        ),
        subtitle1: base.headline1.copyWith(
          fontFamily: GoogleFonts.baiJamjuree().fontFamily,
          fontSize: 15.0,
          color: Colors.grey,
        ),
        subtitle2: base.headline1.copyWith(
          fontFamily: GoogleFonts.baiJamjuree().fontFamily,
          fontSize: 12.0,
          color: Colors.grey,
        ),
        bodyText2: base.bodyText2.copyWith(color: Colors.black),
        bodyText1: base.bodyText2.copyWith(color: Color(0xff21649B)));
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme: _temaTextoPrincipal(base.textTheme),
    backgroundColor: Colors.white,
    primaryColorLight: Colors.blue,
    primaryColorDark: Colors.blueAccent[900],
    iconTheme: IconThemeData(
      color: Color(0xFFFE7A66),
      size: 21,
    ),
    indicatorColor: Colors.blue,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(headline1: base.textTheme.headline1),
      color: Color(0xFF45AAB4),
    ),
  );
}
