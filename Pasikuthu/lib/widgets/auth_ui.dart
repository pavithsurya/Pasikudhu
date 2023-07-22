import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/auth_scr/emamil_verify.dart';
import 'package:pasikuthu/screens/auth_scr/google_auth.dart';
import 'package:pasikuthu/screens/auth_scr/phone_auth.dart';
import 'package:pasikuthu/services/phone_authserv.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../screens/auth_scr/email_auth.dart';

class AuthUi extends StatelessWidget {
  const AuthUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   width: 220,
          //   child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //
          //         backgroundColor: Colors.indigo.shade600,
          //         shape: new RoundedRectangleBorder(
          //           borderRadius: new BorderRadius.circular(3.0),
          //         )
          //       ),
          //       onPressed: (){
          //         Navigator.pushNamed(context, Phoneauth.id);
          //       }, child: Row(
          //     children: [
          //       Icon(Icons.phone_android_outlined,color: Colors.white,),
          //       SizedBox(width: 8,),
          //       Text('Continue with Phone',style: TextStyle(color: Colors.white),)
          //
          //     ],
          //   )),
          // ),
          SignInButton(
          Buttons.google,
            text : ('Continue with Google'),
            onPressed: ()async {
              User? user = await GoogleAuthentication.signinWithGoogle(context: context);
              if(user!=null){
                Phoneauthservice _authentication = Phoneauthservice();
                _authentication.addUser(context);

              }
            },),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('OR',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, EmailAuth.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text('Login with Email',style: TextStyle(color: Colors.white,fontSize: 18),),
                decoration: BoxDecoration(border: Border(bottom:BorderSide(color: Colors.white))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
