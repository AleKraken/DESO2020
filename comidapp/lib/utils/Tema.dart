import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData temaPrincipal() {
  TextTheme _temaTextoPrincipal(TextTheme base) {
    return base.copyWith(
        headline1: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        headline2: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 16.0,
          color: Color(0xFF515151),
          fontWeight: FontWeight.bold,
        ),
        headline3: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 20.0,
          color: Color(0xFF515151),
          fontWeight: FontWeight.w900,
        ),
        subtitle1: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 15.0,
          color: Colors.grey,
        ),
        subtitle2: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 12.0,
          color: Colors.grey,
        ),
        headline4: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 14.4,
          color: Color(0xFF515151).withOpacity(.7),
          fontWeight: FontWeight.bold,
        ),
        headline5: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headline6: base.headline1.copyWith(
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: 16.0,
          color: Color(0xFF515151),
          fontWeight: FontWeight.bold,
        ),
        bodyText2: base.bodyText2.copyWith(color: Colors.black),
        bodyText1: base.bodyText2.copyWith(color: Color(0xff21649B)));
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme: _temaTextoPrincipal(base.textTheme),
    backgroundColor: Color(0xFFF4F4F4),
    primaryColor: Color(0xFF45AAB4),
    primaryColorLight: Colors.blue,
    primaryColorDark: Colors.blueAccent[900],
    iconTheme: IconThemeData(
      color: Color(0xFFFE7A66),
      size: 21,
    ),
    buttonColor: Color(0xFF45AAB4),
    shadowColor: Colors.grey,
    cardColor: Color(0xFFE3E4E5),
    indicatorColor: Color(0xFF45AAB4),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(headline1: base.textTheme.headline1),
      color: Color(0xFF45AAB4),
    ),
    accentColor: Color(0xFFFE7A66),
  );
}
