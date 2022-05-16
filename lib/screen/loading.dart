// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import "package:app/models/translation.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loading extends StatefulWidget {
  loading({Key? key}) : super(key: key);
  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  bool loading = false;

  Future<void> fetch() async {
    var prefs = await SharedPreferences.getInstance();
    translation.languege_symbol = prefs.getString("languege") ?? "en";
    Get.offAll(MyHomePage(title: "home"));
  }

  @override
  void initState() {
    super.initState();
MobileAds.instance.initialize();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "asset/1024.png",
                width: 230,
                height: 230,
              ),
              SizedBox(
                height: 50,
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text("Loading..")
            ],
          ),
        ),
      ),
    );
  }
}
