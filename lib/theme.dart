import 'package:flutter/material.dart';

var themeData = ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'FutilePro',
  textTheme: ThemeData.light().textTheme.copyWith(
        titleLarge: const TextStyle(
          fontSize: 48.0,
        ),
        titleMedium: const TextStyle(
          fontSize: 36,
          color: Color.fromARGB(255, 55, 110, 149),
        ),
      ),
);
