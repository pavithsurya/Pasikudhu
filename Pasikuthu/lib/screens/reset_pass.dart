import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/services/email_authserv.dart';

import 'auth_scr/email_auth.dart';

class PasswordReset extends StatelessWidget {
  static const String id = 'password-reset-screen';
  var _emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock,color: Theme.of(context).primaryColor,size: 50,),
                SizedBox(height: 10,),
                Text('Forgot\nPassword?',
                  textAlign: TextAlign.center
                  ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Theme.of(context).primaryColor),),
                SizedBox(height: 10,),
                Text('Send us your email ,\n we will send reset link to your email\n(Check in Spam)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),),
                SizedBox(height: 10,),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _emailController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: 'Registered Email',filled: true,fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))
                  ),
                  validator: (value){
                    final bool isValid = EmailValidator.validate(_emailController.text);
                    if(value==null||value.isEmpty){
                      return 'Enter Email';
                    }
                    if(value.isNotEmpty&& isValid==false){
                      return 'Enter valid Email';
                    }
                    return null;

                  },

                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Send'),
        ),onPressed: (){
          if(_formkey.currentState!.validate()){
            FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value){
              Navigator.pushReplacementNamed(context, EmailAuth.id);
            });
          }

      },),
    );
  }
}
