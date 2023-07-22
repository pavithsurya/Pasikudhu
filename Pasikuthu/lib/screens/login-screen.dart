import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import '../widgets/auth_ui.dart';

class loginscr extends StatefulWidget {
  static const String id = 'login-screen';
  const loginscr({Key? key}) : super(key: key);

  @override
  State<loginscr> createState() => _loginscrState();
}

class _loginscrState extends State<loginscr> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: Column(
        children: [
          Expanded(child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 100,),
                Image.asset('assets/food.png',
                  width: 150,
                ),
                SizedBox(height: 10,),
                Text("Let's get started",style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),)

              ],
            ),
          ),),
          Expanded(child: Container(
            child: AuthUi(),
          ),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('If you continue, you are accepting our \nTerms and conditions and Privacy Policy',style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,),
          )
        ],
      ),
    );
  }
}
