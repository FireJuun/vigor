import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vigor/1_presentation/localization/localization.dart';
import 'package:vigor/1_presentation/theme/theme.dart';

import 'screens/login/login.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // theme: ThemeClass.light(),
      theme: ThemeClass.dark(),
      translations: MyTranslations(),
      locale: Locale(Platform.localeName.split('_')[0]),
      title: 'Vigor',
      home: const LoginScreen(),
    );
  }
}