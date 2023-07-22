

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/auth_scr/emamil_verify.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';

class EmailAuthentication{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseService _service = FirebaseService();
  Future<DocumentSnapshot> getAdminCredential(email,password,isLog,context)async{
    DocumentSnapshot _result = await users.doc(email).get();
    if(isLog){
      emailLogin(email,password,context);
    }else{
      if(_result.exists){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An account already exists with this email'))
        );
      }else{
        emailRegister(email,password,context);
      }
    }
    return _result;
  }

  emailLogin(email,password,context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(_service.user!.emailVerified){
        if(credential.user?.uid!=null){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen(false, LocationScreen(false,MainScreen()))),
                (Route<dynamic> route) => false,
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email isn't verified"))
        );
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.'))
        );

      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong password provided for that user.'))
        );

      }
    }

  }
  emailRegister(email,password,context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if(credential.user?.uid!=null){
        return users.doc(credential.user?.uid).set({
          'uid' : credential.user?.uid,
          'mobile' :'',
          'image':'',
          'email' : credential.user?.email,
          'name': '',
          'address':''
        }).then((value) async {
          await credential.user?.sendEmailVerification().then((value){
            Navigator.pushReplacementNamed(context, EmailVerification.id);
          });

        }).catchError((onError){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add user'))
        );
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The password provided is too weak.'))
        );

      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The account already exists for that email.'))
        );

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error occurred'))
      );

    }

  }

}