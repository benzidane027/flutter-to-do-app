// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget settingIcon(context) {
  double _w = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.fromLTRB(0, _w / 10, _w / 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: _w / 8.5,
          width: _w / 8.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            tooltip: 'Settings',
            icon: Icon(Icons.settings,
                size: _w / 17, color: Colors.black.withOpacity(.6)),
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}

class myContoller {
  static TextEditingController searchController = TextEditingController();
}

Widget searchBar(context,palceholder,callback) {
  myContoller controller = myContoller();
  double _w = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.fromLTRB(_w / 20, _w / 25, _w / 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          // height: _w / 8.5,
          width: _w * 1.36,
          padding: EdgeInsets.symmetric(horizontal: _w / 60),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(99),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
            ],
          ),
          child: TextField(
            controller: myContoller.searchController,
            maxLines: 1,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.settings),
                onPressed: ()=>callback(),
              ),
              fillColor: Colors.transparent,
              filled: true,
              hintStyle: TextStyle(
                  color: Colors.black.withOpacity(.4),
                  fontWeight: FontWeight.w600,
                  fontSize: _w / 22),
              prefixIcon:
                  Icon(Icons.search, color: Colors.black.withOpacity(.6)),
              hintText: palceholder,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget card(
    context, String title, String subtitle, String image, Widget route) {
  double _w = MediaQuery.of(context).size.width;
  return Opacity(
    opacity: 0.5,
    child: InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        // Navigator.of(context).push(MyFadeRoute(route: route));
      },
      child: Container(
        width: _w / 2.36,
        height: _w / 1.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 50),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: _w / 2.36,
              height: _w / 2.6,
              decoration: BoxDecoration(
                color: Color(0xff5C71F3),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Add image here',
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Image.asset(
            //   image,
            //   fit: BoxFit.cover,
            //   width: _w / 2.36,
            //   height: _w / 2.6),
            Container(
              height: _w / 6,
              width: _w / 2.36,
              padding: EdgeInsets.symmetric(horizontal: _w / 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textScaleFactor: 1.4,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    textScaleFactor: 1,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
