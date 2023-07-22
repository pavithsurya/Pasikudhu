


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/screens/otp_screen.dart';


class Phoneauthservice {

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String veriId = "";



  Future<void> addUser(context) async {

    User? user = auth.currentUser;

    // Call the user's CollectionReference to add a new user
    final QuerySnapshot result =  await users.where('uid',isEqualTo: user?.uid).get();

    List <DocumentSnapshot> document = result.docs;


    if(document.length>0){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LocationScreen(false, MainScreen())),
            (Route<dynamic> route) => false,
      );

    }else{

      return users.doc(user?.uid)
          .set({
        'uid': user?.uid, //user id
        'mobile': user?.phoneNumber !=null ? user?.phoneNumber : '',
        'email':user?.email!=null?user?.email:'',
        'name':'',
        'address':'',
        'image':''
      })
          .then((value){
            print('added');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LocationScreen(false, MainScreen())),
                  (Route<dynamic> route) => false,
            );
      })
          .catchError((error) => print("Failed to add user: $error"));

    }



  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {

    final PhoneVerificationCompleted verificationCompleted = (
        PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };


  final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
    if (e.code == 'invalid phone number') {
      print('The provided phone number is not valid.');
    }
    print('The error is ${e.code}');
  };


  // final PhoneCodeSent codeSent = (String verId, int? resendtoken) async {
  //   veriId = verId;
  // };


  try{
    auth.verifyPhoneNumber(phoneNumber: number ,verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (String verId, int? resendtoken) async {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => OTPScreen(number: number,verId:verId ,),),);
        },
        timeout: const Duration(seconds: 20),
        codeAutoRetrievalTimeout: (String verificationId){
          print(verificationId);
        });
  }catch(e){
    print('Error ${e.toString()}');
  }
}
}