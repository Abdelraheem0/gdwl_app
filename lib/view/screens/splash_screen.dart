// ignore_for_file: unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdwl/view/screens/layout.dart';



class SplashScreen extends StatefulWidget {

  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init()async{
    startTimer();
  }





  startTimer() async {
    var _duration = new Duration(milliseconds: 2000);
    return new Timer(_duration, () async {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LayoutScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return new Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
//                  color: Colors.blue,
                ),

              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              Container(
                width: MediaQuery.of(context).size.width*0.5,
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        )
    );
  }
}
