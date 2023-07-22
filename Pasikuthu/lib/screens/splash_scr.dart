import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/screens/login-screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  //const SplashScreen({Key ?key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool result = false;
  late bool temp = false;

  @override
  void initState() {
    _checker();
    Timer(Duration(
      seconds: 3,
    ),() async {
      bool result = await InternetConnectionChecker().hasConnection;
      if(result == true) {
        FirebaseAuth.instance.authStateChanges().listen((User ?user) {
          if (user==null){
            Navigator.pushReplacementNamed(context, loginscr.id);
          }
          else{
            Navigator.pushReplacementNamed(context, MainScreen.id);
          }
        });
      }else
        {
          showSimpleNotification(Text('No Internet'));
        }


    });
    super.initState();
  }

  _checker() async {
    bool result1 = await InternetConnectionChecker().hasConnection;
    setState(() {
      result = result1;
      temp = true;
    });
  }

  @override
  Widget build(BuildContext context){

    const colorizeColors = [
      Colors.white,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Lato',
      fontWeight: FontWeight.bold,

    );


    return temp?Scaffold(
      backgroundColor: Colors.red.shade900,
      body: Center(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OpacityAnimatedWidget.tween(
              duration: Duration(milliseconds: 2000),
              opacityEnabled: 1, //define start value
              opacityDisabled: 0,
              child: Column(
                children: [
                  Text("Pasikudhu",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 80,color: Colors.white),),
            //       Image.asset('assets/Pasikudhu.png',
            //       height: 300,
            // ),
                  Visibility(
                      visible: !result,
                      child:Text('No Internet',style: TextStyle(color: Colors.white),),)
                ],
              ),),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !result,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
              onPressed:(){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Retry',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),),
          ),
        ),
      ),

    ):Container();
  }
}
