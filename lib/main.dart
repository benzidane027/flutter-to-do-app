// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, annotate_overrides, override_on_non_overriding_member, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:app/db_manager.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'simple note'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var helper_ = db_helpeer();
  List list_of_task = [];
  List selected = [];
  bool select = false;
  var object_controller = TextEditingController();
  var content_controller = TextEditingController();
  void initState() {
    super.initState();
    get_tasks();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 25, right: 10, left: 10),
                itemCount: list_of_task.length,
                itemBuilder: (_, __) {
                  return GestureDetector(
                    onLongPress: () {
                      if (selected.indexOf(list_of_task[__]["id"]) == -1) {
                        selected.add(list_of_task[__]["id"]);
                      } else {
                        selected.remove(list_of_task[__]["id"]);
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blue.withOpacity(
                                  selected.indexOf(list_of_task[__]["id"]) >= 0
                                      ? 0.6
                                      : 0))),
                      child: ExpansionTile(
                        trailing: Text(
                          list_of_task[__]["mydate"].toString().split(" ")[0],
                          style: TextStyle(color: Colors.grey.withOpacity(0.7)),
                        ),
                        expandedAlignment: Alignment.topLeft,
                        children: [
                          Text(list_of_task[__]["content"].toString(),
                              style:
                                  TextStyle(fontSize: 18, fontFamily: "Ubuntu"))
                        ],
                        title: Text(list_of_task[__]["object"].toString(),
                            style:
                                TextStyle(fontSize: 25, fontFamily: "Ubuntu")),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            child: Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    selected.clear();

                    setState(() {});
                  },
                  child: Visibility(
                    visible: selected.length > 0 ? true : false,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 0.8)
                          ],
                          color: Colors.blue.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(35)),
                      width: 55,
                      height: 55,
                      child: Icon(
                        Icons.select_all,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Text(" ")),
                GestureDetector(
                  onTap: () async {
                    List temp = await helper_.get_task(id: selected[0]);
                    mydial(context,
                        mode: "edit",
                        id: selected[0],
                        object: temp[0]["object"].toString(),
                        content: temp[0]["content"].toString());
                  },
                  child: Visibility(
                    visible: selected.length == 1 ? true : false,
                    child: Container(
                      margin: EdgeInsets.only(right: 20, bottom: 10),
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 0.8)
                          ],
                          color: Colors.blue.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(35)),
                      width: 55,
                      height: 55,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    for (int i = 0; i < selected.length; i++) {
                      await helper_.delete_task(id: selected[i]);
                    }
                    selected.clear();
                    get_tasks();
                  },
                  child: Visibility(
                    visible: selected.length > 0 ? true : false,
                    child: Container(
                      margin: EdgeInsets.only(right: 20, bottom: 10),
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 0.8)
                          ],
                          color: Colors.blue.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(35)),
                      width: 55,
                      height: 55,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => mydial(context, mode: "add"),
                  child: Container(
                    margin: EdgeInsets.only(right: 20, bottom: 10),
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              blurRadius: 10,
                              spreadRadius: 0.8)
                        ],
                        color: Colors.blue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(35)),
                    width: 55,
                    height: 55,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  mydial(context, {object = "", content = "", required mode, id = ""}) {
    object_controller.text = object;
    content_controller.text = content;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: mode == "add" ? Text("add note") : Text("edit note"),
            content: Container(
              height: 300,
              child: Column(
                children: [
                  TextField(
                    controller: object_controller,
                    maxLength: 31,
                    maxLines: null,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        counter: Text(""),
                        label: Text("object"),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                    //    controller: message_controller,
                  ),
                  TextField(
                    controller: content_controller,
                    maxLength: 200,
                    maxLines: 6,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, top: 5),
                        counter: Text(""),
                        label: Text("content"),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                    //    controller: message_controller,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
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
                          },
                          child: mode == "add"
                              ? Text("  add    ")
                              : Text("  edit   ")),
                      Expanded(
                        child: Text(" "),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("cancel"))
                    ],
                  )
                ],
              ),
            )));
  }
}
