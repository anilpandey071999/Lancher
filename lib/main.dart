import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lancher/permission_handling.dart';
import 'package:launcher_assist/launcher_assist.dart';


void main() => runApp(

    MaterialApp(home:new MyApp(),debugShowCheckedModeBanner: false,));

var installedApps;

class MyApp extends StatefulWidget {
//  MyApp({Key key, this.title}) : super(key: key);
//
//  final String title;
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {


  var numberOfInstalledApps;
  var wallpaper;

  DateTime now = DateTime.now();

  @override
  initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        now = DateTime.now();
      });
    });

    // Get all apps
    LauncherAssist.getAllApps().then((apps) {
      setState(() {
        numberOfInstalledApps = apps.length;
        installedApps = apps;
      });
    });

    // Get wallpaper as binary data
    LauncherAssist.getWallpaper().then((imageData) {
      setState(() {
        wallpaper = imageData;
      });
    });

  }

  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    HandlerOfPermissions().askOnce();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
              child: wallpaper != null
                  ? new Image.memory(wallpaper,
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ):
              new Center()
          ),
          PageView(
            scrollDirection: Axis.vertical,
            controller: ctrl,
            children: <Widget>[
              Center(
                child: Container(
                      alignment: Alignment.topCenter,
                      child:Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),

                            child: Text(DateFormat('  hh:mm a').format(now),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.fromLTRB(0, 140, 0, 0),
                            child: Text(DateFormat('EEEE, d MMM').format(now),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.bottomCenter,
                              child:rowsApp(installedApps: installedApps)
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0),
                      ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      child: apps(installedApps: installedApps),
                   decoration: BoxDecoration(
                     color: Colors.black.withOpacity(0.5),
                        ),
                    ),
                      )
                    ],
                  )
                ],
              ),


        ],
      )
    );
  }

}

class apps extends StatefulWidget {
  const apps({
    Key key,
    @required this.installedApps,
}) : super(key:key);

  final installedApps;

  @override
  _appsState createState() => _appsState();
}

class _appsState extends State<apps> with SingleTickerProviderStateMixin{

  AnimationController opacityController;
  Animation<double> _opacity;

  void initState(){
    super.initState();
    opacityController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _opacity = Tween(begin: 0.0,end: 1.0).animate(opacityController);
  }

  @override
  Widget build(BuildContext context) {
    opacityController.forward();
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
        child: gridViewContainer(widget.installedApps),
      ),
    );
  }

  gridViewContainer(installApps){
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 40,
      physics: ScrollPhysics(),
      children: List.generate(
          installApps != null? installApps.length : 0,
              (index) {
                return GestureDetector(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        iconContainer(index),
                        SizedBox(height: 10),
                        Text(
                          installApps[index]["label"],
                          style: TextStyle(
                            color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                   onTap: () =>LauncherAssist.launchApp(installedApps[index]["package"]),
                );
              }
      ),
    );
  }

  iconContainer(index) {
    try {
      return Image.memory(
        widget.installedApps[index]["icon"] != null
            ? widget.installedApps[index]["icon"]
            : Uint8List(0),
        height: 40,
        width: 50,
      );
    } catch (e) {
      return Container();
    }
  }
  @override
  void dispose() {
    opacityController.dispose();
    super.dispose();
  }
}

class rowsApp extends StatefulWidget {
  const rowsApp({
    Key key,
    @required this.installedApps,
  }) : super(key:key);

  final installedApps;
  @override
  _rowsappState createState() => _rowsappState();
}

class _rowsappState extends State<rowsApp> {
  get installApps => installedApps;

  get index => index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 625, 0, 0),
      child: GestureDetector(child:Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                        child: Column(
                          children: <Widget>[
                            iconContainer(5),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child:Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                        child: Column(
                          children: <Widget>[
                            iconContainer(26),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                        onTap: () =>LauncherAssist.launchApp(installedApps[26]["package"]),
                      ),

                      GestureDetector(
                        child:Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                          child: Column(
                            children: <Widget>[
                              iconContainer(7),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        onTap: () =>LauncherAssist.launchApp(installedApps[7]["package"]),
                      ),
                      GestureDetector(
                        child:Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              iconContainer(2),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        onTap: () =>LauncherAssist.launchApp(installedApps[2]["package"]),
                      ),


                    ],
                  ),

                ),
          onTap: () =>LauncherAssist.launchApp(installedApps[index]["package"])

      )

    );
  }
  iconContainer(index) {
    try {
      return Image.memory(
        widget.installedApps[index]["icon"] != null
            ? widget.installedApps[index]["icon"]
            : Uint8List(0),
        height: 40,
        width: 50,
      );
    } catch (e) {
      return Container();
    }
  }
}


