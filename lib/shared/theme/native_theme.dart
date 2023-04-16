import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NativeThemeData {
  ThemeData nativeLightTheme() {
    return ThemeData.light().copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
        },
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      primaryColor: const Color.fromRGBO(177, 7, 37, 1),
      primaryColorDark: const Color.fromRGBO(11, 10, 7, 1),
      primaryColorLight: const Color.fromRGBO(0, 0, 0, 1),
      primaryTextTheme: const TextTheme(),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color.fromRGBO(177, 7, 37, 1),
        width: 300,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.outfit(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.aBeeZee(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const MaterialStatePropertyAll(
            Size(276, 49),
          ),
          backgroundColor: const MaterialStatePropertyAll(
            Color.fromRGBO(92, 176, 254, 1),
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          fontSize: 30,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: const Color.fromRGBO(0, 0, 0, 1),
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
      ),
      dialogBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(92, 176, 254, 1),
        actionsIconTheme: const IconThemeData(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        titleTextStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(
            GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(253, 165, 43, 1),
            ),
          ),
          iconColor: const MaterialStatePropertyAll(
            Color.fromRGBO(253, 165, 43, 1),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          fixedSize: const MaterialStatePropertyAll(
            Size(150, 38),
          ),
          side: const MaterialStatePropertyAll(
            BorderSide(
              color: Color.fromRGBO(253, 165, 43, 1),
              width: 2,
            ),
          ),
          backgroundColor: const MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          iconColor: MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        prefixIconColor: const Color.fromRGBO(122, 122, 122, 1),
        suffixIconColor: const Color.fromRGBO(122, 122, 122, 1),
        hintStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
        labelStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
        helperStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
        errorStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
        prefixStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
        suffixStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
        counterStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(109, 106, 106, 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: Color.fromRGBO(108, 106, 106, 1),
            width: 0.6,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: Color.fromRGBO(108, 106, 106, 1),
            width: 0.6,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: Color.fromRGBO(108, 106, 106, 1),
            width: 0.6,
          ),
        ),
      ),
    );
  }

  ThemeData nativeDarkTheme() {
    return ThemeData.dark().copyWith();
  }
}
