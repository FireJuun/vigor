import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container flagContainer(String country, Size size) => Container(
      height: size.height * .3,
      width: size.width * .5,
      child: getFlag(country),
    );

Image getFlag(String country) => Image(
      image: AssetImage('lib/presentation/img/flags/$country.png'),
      fit: BoxFit.contain,
    );

Text splashText(String country) => Text(
      loginTitle(country),
      textAlign: TextAlign.center,
      style: getStyle(country),
    );

String loginTitle(String country) {
  switch (country) {
    case 'botswana':
      return 'Mpepu';
    case 'dominican_republic':
      return 'Salud\nDominicana';
    default:
      return null;
  }
}

TextStyle getStyle(String country) {
  switch (country) {
    case 'botswana':
      return GoogleFonts.archivoBlack(
          textStyle: TextStyle(color: Colors.blue[600], fontSize: 40));
    case 'dominican_republic':
      return GoogleFonts.courgette(
          textStyle: TextStyle(color: Colors.red, fontSize: 40));
    default:
      return null;
  }
}
