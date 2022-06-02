// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, annotate_overrides, override_on_non_overriding_member, curly_braces_in_flow_control_structures, prefer_contains, prefer_const_literals_to_create_immutables
//********************unfeniched task*/
// 1) need to set rearch  ##complet
// 2) need to decorate confirm delete ##complet
// 3) need to decorate add/edit ##complet
// 4) neet to add notification ##complet
// 5) neet to set languege and setting ##coplet

import 'package:app/screen/loading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:flutter/material.dart';

void main() {
//  translation.languege_symbol = prefs.getString("languege") ==null?"en":"ar";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/loading",
      routes: {
        "/loading": (_) => loading(),
        
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      //  home: const loading(),
    );
  }
}
