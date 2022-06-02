// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_contains, non_constant_identifier_names, prefer_final_fields

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import "loading.dart";
import 'package:get/get.dart';
import 'package:app/models/component.dart';
import 'package:app/models/db_manager.dart';
import 'package:app/models/notify.dart';
import "package:app/models/translation.dart";
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String languege_symbol = translation.languege_symbol;
  var helper_ = db_helpeer();
  List list_of_task = [];
  List copy_list_of_task = [];
  List selected = [];
  List<String> remember_list_of_task = [];
  bool select = false;
  var object_controller = TextEditingController();
  var content_controller = TextEditingController();
  bool _isValidate = true;
  late SharedPreferences prefs;
  late NativeAd _ad;
  bool isLoaded = false;
  var localeType;
  getpref() async {
    prefs = await SharedPreferences.getInstance();
    remember_list_of_task = prefs.getStringList("remenber") ?? [];
    if (remember_list_of_task.isEmpty) return;
    List<String> temp_remember_list_of_task = [...remember_list_of_task];
    print(temp_remember_list_of_task);
    for (int i = 0; i < temp_remember_list_of_task.length; i = i + 2) {
      if (int.parse(temp_remember_list_of_task[i + 1]) <
          DateTime.now().millisecondsSinceEpoch) {
        remember_list_of_task.remove(temp_remember_list_of_task[i + 1]);
        remember_list_of_task.remove(temp_remember_list_of_task[i]);
      }
    }
    prefs.setStringList("remenber", remember_list_of_task);
  }

  void loadNativeAd() {
    _ad = NativeAd(
        request: const AdRequest(),
        //my own
        adUnitId: 'ca-app-pub-7724036445612282/9536276721',
        // test
        //  adUnitId: "ca-app-pub-3940256099942544/2247696110",
        factoryId: 'listTile',
        listener: NativeAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('failed to load the ad ${error.message}, ${error.code}');
          Future.delayed(Duration(minutes: 10), () => loadNativeAd());
        }));

    _ad.load();
  }

  @override
  void dispose() {
    super.dispose();
    _ad.dispose();
  }

  @override
  void initState() {
    super.initState();
    Nontify.init();
    getpref();
    get_tasks();
    loadNativeAd();
    switch (languege_symbol) {
      case "en":
        localeType = LocaleType.en;
        break;
      case "ar":
        localeType = LocaleType.ar;
        break;
      case "fr":
        localeType = LocaleType.fr;
        break;
      case "ru":
        localeType = LocaleType.ru;
        break;
      case "es":
        localeType = LocaleType.es;
        break;
    }
    myContoller.searchController.addListener(() {
      List search_list_of_task = [...copy_list_of_task];
      print(myContoller.searchController.text);
      for (int i = copy_list_of_task.length - 1; i >= 0; i--) {
        if (!search_list_of_task[i]["object"]
            .toString()
            .contains(myContoller.searchController.text)) {
          search_list_of_task.removeAt(i);
        }
      }
      list_of_task = search_list_of_task;
      setState(() {});
    });
  }

  void add_task() async {
    int resualt = await helper_.add_task(
        object: object_controller.text,
        content: content_controller.text,
        date: DateTime.now().toString());
    if (resualt > 0) {
      //setState(() {});
      get_tasks();
    }
    //   print(DateTime.now().toString()+" "+object_controller.text+" "+content_controller.text);
  }

  void get_tasks() async {
    list_of_task = await helper_.get_tasks();
    copy_list_of_task = [...list_of_task];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text(widget.title)),
        actions: [
          PopupMenuButton(itemBuilder: (_) {
            return [
              PopupMenuItem(
                  child: Text("our privacy"),
                  onTap: () async {
                    // if (!await canLaunch("https://flutter.dev"))
                    launch(
                        "https://github.com/benzidane027/privacy/blob/main/privacy-policy.md");
                  }),
              PopupMenuItem(child: Text("app v: 1.0"))
            ];
          })
        ],
      ),*/
      body: DoubleBackToCloseApp(
        snackBar:  SnackBar(
          content: Text(translation.write('Tap back again to leave', languege_symbol)!),
        ),
        child: SafeArea(
          child: Directionality(
            textDirection:
                languege_symbol == "ar" ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: Colors.grey.withOpacity(0.7),
                  child: Row(
                    children: [
                      Expanded(
                          child: searchBar(
                              context,
                              translation.write(
                                  "Search anything.....", languege_symbol)!,
                              () => showDialog(
                                  context: context,
                                  builder: (con) => Directionality(
                                        textDirection: languege_symbol == "ar"
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        child: AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.settings,
                                                color: Colors.blue,
                                                size: 27,
                                              ),
                                              Text(translation.write(" Setting",
                                                  languege_symbol)!),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.phone_android,
                                                        color: Colors.green),
                                                    Text(
                                                        translation.write(
                                                            "  Version:  1.1.0",
                                                            translation
                                                                .languege_symbol)!,
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8)))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.book,
                                                      color: Colors.blue,
                                                    ),
                                                    Text(
                                                        translation.write(
                                                            "  Terms",
                                                            translation
                                                                .languege_symbol)!,
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8))),
                                                    IconButton(
                                                        onPressed: () async {
                                                          if (await canLaunch(
                                                              "https://github.com/benzidane027/privacy/blob/main/privacy-policy.md"))
                                                            launch(
                                                                "https://github.com/benzidane027/privacy/blob/main/privacy-policy.md");
                                                        },
                                                        icon: Icon(
                                                          Icons.link,
                                                          color: Colors.blue
                                                              .withOpacity(0.7),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.language,
                                                        color: Colors.orange),
                                                    Text(
                                                      translation.write(
                                                          "  language:",
                                                          languege_symbol)!,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.8)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Wrap(
                                                children: [
                                                  Chip(
                                                      elevation: 5,
                                                      labelPadding:
                                                          EdgeInsets.all(4),
                                                      backgroundColor:
                                                          Color(0xffEE5253),
                                                      label: GestureDetector(
                                                        onTap: () {
                                                          print("object");
                                                          prefs.setString(
                                                              "languege", "fr");
                                                          languege_symbol =
                                                              "fr";
                                                          Get.to(loading());
                                                        },
                                                        child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child:
                                                                Text("French")),
                                                      ),
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xffFC7E7E),
                                                        child: const Text('fr'),
                                                      )),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  Chip(
                                                      elevation: 5,
                                                      labelPadding:
                                                          EdgeInsets.all(4),
                                                      backgroundColor:
                                                          Color(0xff1DD1A1),
                                                      label: GestureDetector(
                                                        onTap: () {
                                                          prefs.setString(
                                                              "languege", "ar");
                                                          languege_symbol =
                                                              "ar";
                                                          Get.to(loading());
                                                        },
                                                        child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child:
                                                                Text("Arabic")),
                                                      ),
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xff36E8B8),
                                                        child: const Text('Ar'),
                                                      )),
                                                  Chip(
                                                      labelPadding:
                                                          EdgeInsets.all(4),
                                                      elevation: 5,
                                                      backgroundColor:
                                                          Color(0xffFECA57),
                                                      label: GestureDetector(
                                                        onTap: () {
                                                          prefs.setString(
                                                              "languege", "en");
                                                          languege_symbol =
                                                              "en";
                                                          Get.to(loading());
                                                        },
                                                        child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.53,
                                                            child: Text(
                                                                "English")),
                                                      ),
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xffF7D790),
                                                        child: const Text('en'),
                                                      )),
                                                  Chip(
                                                      labelPadding:
                                                          EdgeInsets.all(4),
                                                      elevation: 5,
                                                      backgroundColor:
                                                          Color(0xff5F27CD),
                                                      label: GestureDetector(
                                                        onTap: () {
                                                          prefs.setString(
                                                              "languege", "ru");
                                                          languege_symbol =
                                                              "ru";
                                                          Get.to(loading());
                                                        },
                                                        child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: Text(
                                                                "Russian")),
                                                      ),
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xff8A56EF),
                                                        child: const Text('ru'),
                                                      )),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.002,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Chip(
                                                        elevation: 5,
                                                        labelPadding:
                                                            EdgeInsets.all(4),
                                                        backgroundColor:
                                                            Color(0xffF368E0),
                                                        label: GestureDetector(
                                                          onTap: () {
                                                            prefs.setString(
                                                                "languege",
                                                                "es");
                                                            languege_symbol =
                                                                "es";
                                                            Get.to(loading());
                                                          },
                                                          child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2,
                                                              child: Text(
                                                                  "Spanish")),
                                                        ),
                                                        avatar: CircleAvatar(
                                                          backgroundColor:
                                                              Color(0xffFB7AE9),
                                                          child:
                                                              const Text('es'),
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton.icon(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Colors.white,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.blue
                                                        .withOpacity(0.6),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50))),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                label: Text(
                                                    translation.write(
                                                        "close",
                                                        translation
                                                            .languege_symbol)!,
                                                    style: TextStyle(
                                                        color: Colors.white)))
                                          ],
                                        ),
                                      ))))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 25, right: 10, left: 10),
                      itemCount: list_of_task.length,
                      itemBuilder: (_, __) {
                        bool isopen = false;
                        return GestureDetector(
                          onLongPress: () {
                            if (selected.indexOf(list_of_task[__]["id"]) ==
                                -1) {
                              selected.add(list_of_task[__]["id"]);
                            } else {
                              selected.remove(list_of_task[__]["id"]);
                            }
                            setState(() {});
                          },
                          child: Dismissible(
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return await showDialog(
                                    context: context,
                                    builder: (_) => Directionality(
                                          textDirection: languege_symbol == "ar"
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                          child: AlertDialog(
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.report_problem,
                                                  color: Colors.blue
                                                      .withOpacity(0.7),
                                                  size: 35,
                                                ),
                                                Text(translation.write(
                                                    "Confirm",
                                                    translation
                                                        .languege_symbol)!),
                                              ],
                                            ),
                                            content: Text(
                                                "do you want to delete this note ?"),
                                            actions: [
                                              ElevatedButton.icon(
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    color: Colors.white,
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      primary: Colors.blue
                                                          .withOpacity(0.6),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  50))),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  label: Text(
                                                      translation.write(
                                                          "No",
                                                          translation
                                                              .languege_symbol)!,
                                                      style: TextStyle(color: Colors.white))),
                                              ElevatedButton.icon(
                                                  icon: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      primary: Colors.blue
                                                          .withOpacity(0.6),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50))),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(list_of_task[
                                                                        __]
                                                                    ["object"] +
                                                                translation.write(
                                                                    " has been deleted",
                                                                    translation
                                                                        .languege_symbol)!)));
                                                    Nontify
                                                        .cancle_notifiacation(
                                                            int.parse(
                                                                list_of_task[__]
                                                                        ["id"]
                                                                    .toString()
                                                                    .trim()));
                                                    helper_.delete_task(
                                                        id: list_of_task[__]
                                                            ["id"]);
                                                    int index =
                                                        remember_list_of_task
                                                            .indexOf(
                                                                list_of_task[__]
                                                                        ["id"]
                                                                    .toString());
                                                    if (index != -1) {
                                                      remember_list_of_task
                                                          .removeAt(index + 1);
                                                      remember_list_of_task
                                                          .removeAt(index);
                                                      prefs.setStringList(
                                                          "remenber",
                                                          remember_list_of_task);
                                                    }
                                                    get_tasks();

                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  label: Text(
                                                      translation.write(
                                                          "Yes",
                                                          translation
                                                              .languege_symbol)!,
                                                      style: TextStyle(
                                                          color: Colors.white)))
                                            ],
                                          ),
                                        ));
                                /*  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("delete")));*/

                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                mydial(context,
                                    mode: "edit",
                                    id: list_of_task[__]["id"],
                                    object: list_of_task[__]["object"],
                                    content: list_of_task[__]["content"]);
                                get_tasks();
                              }
                              return null;
                            },
                            key: Key(list_of_task[__]["object"]),
                            background: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 30,
                                      offset: Offset(0, 15),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(
                                          selected.indexOf(
                                                      list_of_task[__]["id"]) >=
                                                  0
                                              ? 0.6
                                              : 0))),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 30,
                                      offset: Offset(0, 15),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(
                                          selected.indexOf(
                                                      list_of_task[__]["id"]) >=
                                                  0
                                              ? 0.6
                                              : 0))),
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(Icons.edit),
                              ),
                            ),
                            //   onDismissed: (dir) {},
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 30,
                                      offset: Offset(0, 15),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(
                                          selected.indexOf(
                                                      list_of_task[__]["id"]) >=
                                                  0
                                              ? 0.6
                                              : 0))),
                              child: Theme(
                                data:
                                    ThemeData(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  leading: GestureDetector(
                                      onTap: () async {
                                        if (remember_list_of_task.indexOf(
                                                list_of_task[__]["id"]
                                                    .toString()) !=
                                            -1) {
                                          int index = remember_list_of_task
                                              .indexOf(list_of_task[__]["id"]
                                                  .toString());
                                          remember_list_of_task
                                              .removeAt(index + 1);
                                          remember_list_of_task.removeAt(index);
                                          Nontify.cancle_notifiacation(
                                              int.parse(list_of_task[__]["id"]
                                                  .toString()
                                                  .trim()));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(translation.write(
                                                      "dont notify me",
                                                      translation
                                                          .languege_symbol)!)));
                                          prefs.setStringList("remenber",
                                              remember_list_of_task);
                                          setState(() {});
                                          return;
                                        }
                                        DatePicker.showDateTimePicker(context,
                                            theme: DatePickerTheme(),
                                            showTitleActions: true,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime(2050, 6, 7),
                                            onChanged: (date) {},
                                            onConfirm: (date) {
                                          if (date.millisecondsSinceEpoch >
                                              DateTime.now()
                                                  .millisecondsSinceEpoch) {
                                            Nontify.Schedule(
                                                    id: int.parse(
                                                        list_of_task[__]["id"]
                                                            .toString()
                                                            .trim()),
                                                    title: list_of_task[__]
                                                        ["object"],
                                                    content: list_of_task[__]
                                                        ["content"],
                                                    scheduledate: date.add(
                                                        Duration(seconds: 10)))
                                                .then((value) {
                                              remember_list_of_task.add(
                                                  list_of_task[__]["id"]
                                                      .toString());
                                              remember_list_of_task.add(date
                                                  .millisecondsSinceEpoch
                                                  .toString());
                                              prefs.setStringList("remenber",
                                                  remember_list_of_task);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          translation.write(
                                                              "notify me",
                                                              translation
                                                                  .languege_symbol)!)));
                                              setState(() {});
                                            });
                                          }
                                        },
                                            currentTime: DateTime.now(),
                                            locale: localeType);
                                      },
                                      child: Icon(
                                        Icons.notification_add,
                                        color: remember_list_of_task.indexOf(
                                                    list_of_task[__]["id"]
                                                        .toString()) !=
                                                -1
                                            ? Colors.yellow[400]
                                            : Colors.grey,
                                      )),
                                  trailing: isopen
                                      ? Icon(Icons.copy)
                                      : Text(
                                          list_of_task[__]["mydate"]
                                              .toString()
                                              .split(" ")[0],
                                          style: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(0.7)),
                                        ),
                                  expandedAlignment: Alignment.topLeft,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Align(
                                        alignment: languege_symbol == "ar"
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              child: Text(
                                                  list_of_task[__]["content"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Ubuntu")),
                                            ),
                                            Expanded(
                                              //color: Colors.black,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: list_of_task[
                                                                        __]
                                                                    ["content"]
                                                                .toString()));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          translation.write("copy to clipboard", languege_symbol)!),
                                                    ));
                                                  },
                                                  icon: Icon(
                                                    Icons.copy,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  )),
                                              //  width: MediaQuery.of(context).size.width*0.1,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                  title: Text(
                                      list_of_task[__]["object"].toString(),
                                      style: TextStyle(
                                          fontSize: 25, fontFamily: "Ubuntu")),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Visibility(
                  visible: isLoaded,
                  child: SizedBox(
                    height: 75,
                    child: AdWidget(
                      ad: _ad,
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          selected.clear();
                          myContoller.searchController.clear();
                          get_tasks();
                          //setState(() {});
                        },
                        child: Tooltip(
                          message: translation.write("reset", languege_symbol)!,
                          child: Visibility(
                            // visible: selected.length > 0 ? true : false,
                            visible: true,
                            child: Container(
                              
                              margin: EdgeInsets.only(
                                  left: 10,
                                  bottom: 10,
                                  right: languege_symbol == "ar" ? 10 : 0),
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 30,
                                      offset: Offset(0, 15),
                                    ),
                                  ],
                                  color: Colors.blue.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(35)),
                              width: 55,
                              height: 55,
                              child: Icon(
                                Icons.note_sharp,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Text(" ")),
                      GestureDetector(
                        onTap: () async {
                          bool? resualt = await showDialog(
                              context: context,
                              builder: (b) => Directionality(
                                    textDirection: languege_symbol == "ar"
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    child: AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.report_problem,
                                            color: Colors.blue.withOpacity(0.7),
                                            size: 35,
                                          ),
                                          Text(translation.write(
                                              "Confirm", languege_symbol)!),
                                        ],
                                      ),
                                      content: Text(translation.write(
                                          "do you want to delete this note ?",
                                          languege_symbol)!),
                                      actions: [
                                        ElevatedButton.icon(
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.white,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue
                                                    .withOpacity(0.6),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50))),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            label: Text(
                                              "No",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        ElevatedButton.icon(
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue
                                                    .withOpacity(0.7),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50))),
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            label: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    ),
                                  ));
                          if (resualt == null) return;
                          if (resualt) {
                            for (int i = 0; i < selected.length; i++) {
                              await helper_.delete_task(id: selected[i]);
                              await Nontify.cancle_notifiacation(
                                  int.parse(selected[i].toString().trim()));
                              int index = remember_list_of_task
                                  .indexOf(selected[i].toString().toString());
                              if (index != -1) {
                                remember_list_of_task.removeAt(index + 1);
                                remember_list_of_task.removeAt(index);
                                prefs.setStringList(
                                    "remenber", remember_list_of_task);
                              }
                            }

                            selected.clear();
                            get_tasks();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(translation.write(
                                    " has been deleted", languege_symbol)!)));
                          } else {
                            selected.clear();
                            setState(() {});
                          }
                        },
                        child: Visibility(
                          visible: selected.isNotEmpty ? true : false,
                          child: Container(
                            margin: EdgeInsets.only(right: 20, bottom: 10),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 30,
                                    offset: Offset(0, 15),
                                  ),
                                ],
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(35)),
                            width: 80,
                            height: 55,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => mydial(context, mode: "add"),
                        child: Container(
                          margin: EdgeInsets.only(
                              right: 20,
                              bottom: 10,
                              left: languege_symbol == "ar" ? 20 : 0),
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  blurRadius: 30,
                                  offset: Offset(0, 15),
                                ),
                              ],
                              color: Colors.blue.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(35)),
                          width: 100,
                          height: 55,
                          child: Icon(
                            Icons.note_add,
                            color: Colors.white.withOpacity(0.8),
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  mydial(context, {object = "", content = "", required mode, id = ""}) {
    object_controller.text = object;
    content_controller.text = content;
    showDialog(
        context: context,
        builder: (_) => Center(
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: languege_symbol == "ar"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: AlertDialog(
                    backgroundColor: Colors.white70.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    title: Row(
                      children: [
                        Icon(
                          mode == "add" ? Icons.note_add_outlined : Icons.edit,
                          color: Colors.blue,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        mode == "add"
                            ? Text(
                                translation.write(
                                    "Add a note", languege_symbol)!,
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black.withOpacity(0.6)),
                              )
                            : Text(
                                translation.write(
                                    "Edit a note", languege_symbol)!,
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                    content: Column(
                      children: [
                        TextField(
                          controller: object_controller,
                          maxLength: 31,
                          maxLines: null,
                          textInputAction: TextInputAction.go,

                          decoration: InputDecoration(
                            fillColor: Colors.white.withOpacity(0.7),
                            filled: true,
                            counter: Text(""),
                            label: Text(
                                translation.write("object", languege_symbol)!),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          //    controller: message_controller,
                        ),
                        TextField(
                          controller: content_controller,
                          maxLength: 200,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.6),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 10, top: 5),
                              counter: Text(""),
                              label: Text(translation.write(
                                  "content", languege_symbol)!),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.blue))),
                          //    controller: message_controller,
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          label: Text(
                              translation.write("Cancel", languege_symbol)!,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white))),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          icon: Icon(
                            mode == "add" ? Icons.add_circle : Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (mode == "add")
                              add_task();
                            else
                              await helper_.modify_task(
                                  id: id,
                                  object: object_controller.text,
                                  content: content_controller.text);
                            get_tasks();
                            Navigator.of(context).pop();
                            if (mode == "edit") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(translation.write(
                                          "note has been modifed",
                                          languege_symbol)!)));
                            }
                          },
                          label: mode == "add"
                              ? Text(
                                  translation.write(
                                      " add   ", languege_symbol)!,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white))
                              : Text(
                                  translation.write(
                                      " edit  ", languege_symbol)!,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)))
                    ],
                  ),
                ),
              ),
            ));
  }
}
