import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starwiki/app/controllers/character_controller.dart';
import 'package:starwiki/app/views/home_page.dart';

main() {
  runApp(ChangeNotifierProvider(
      create: (_) => CharacterController(),
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark, 
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
    home: HomePage(),
      ),
  ));
}