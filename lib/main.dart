import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/loadingPage.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:musicplayer/music_methods/controller.dart';
import 'package:musicplayer/music_methods/musicProvider.dart';


void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: loadingPage(),
    );
  }
}

