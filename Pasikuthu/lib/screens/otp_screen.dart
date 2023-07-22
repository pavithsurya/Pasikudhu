import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasikuthu/screens/auth_scr/phone_auth.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/services/phone_authserv.dart';

class OTPScreen extends StatefulWidget {


  final String number,verId;

  OTPScreen({required this.number,required this.verId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {


  bool _loading = false;
  String error = '';

  Phoneauthservice _services = Phoneauthservice();
  var _text1 = TextEditingController();
  var _text2 = TextEditingController();
  var _text3 = TextEditingController();
  var _text4 = TextEditingController();
  var _text5 = TextEditingController();
  var _text6 = TextEditingController();

  Future<void>phoneCredential(BuildContext context,String otp,)async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verId, smsCode: otp);
      final User? user = (await _auth.signInWithCredential(credential)).user;
      if(user!=null){
        _services.addUser(context);

      }else{
        print('Login Failed');
        if(mounted)
          {
            setState(() {
              error = 'Login Failed';
            });
          }
      }
    }catch(e){
      print(e.toString());
      if(mounted)
        {
          setState(() {
            error = 'Invalid OTP';
          });
        }
    }
  }


  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.red.shade900,
        title: Text('Login',style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:20,right :20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                CircleAvatar(
              radius: 30,
                  backgroundColor: Colors.red.shade200,
                  child: Icon(Icons.person_outline,size: 40,color: Colors.red.shade900,),
              ),
                SizedBox(height: 10,),
                Text('Welcome Back',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: RichText(text: TextSpan(text: 'We sent a 6-digit code to ',
                      style: TextStyle(color: Colors.grey,fontSize: 12),
                      children: [
                        TextSpan(
                          text: widget.number,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12)
                        )
                      ]),

                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Phoneauth(),),);
                      },
                       child: Icon(Icons.edit),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: _text1,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder()
                        ),
                        onChanged: (value){
                          if(value.length==1)
                            {
                              node.nextFocus();
                            }
                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: _text2,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        onChanged: (value){
                          if(value.length==1)
                          {
                            node.nextFocus();
                          }
                          if(value.length==0)
                          {
                            node.previousFocus();
                          }

                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: _text3,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        onChanged: (value){
                          if(value.length==1)
                          {
                            node.nextFocus();
                          }
                          if(value.length==0)
                          {
                            node.previousFocus();
                          }

                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: _text4,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        onChanged: (value){
                          if(value.length==1)
                          {
                            node.nextFocus();
                          }
                          if(value.length==0)
                          {
                            node.previousFocus();
                          }

                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: _text5,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        onChanged: (value){
                          if(value.length==1)
                          {
                            node.nextFocus();
                          }
                          if(value.length==0)
                          {
                            node.previousFocus();
                          }

                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: _text6,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        onChanged: (value){
                          if(value.length==1)
                          {
                            if(_text1.text.length==1){
                              if(_text2.text.length==1){
                                if(_text3.text.length==1){
                                  if(_text4.text.length==1){
                                    if(_text5.text.length==1){

                                        String _otp = '${_text1.text}${_text2.text}${_text3.text}${_text4.text}${_text5.text}${_text6.text}';
                                        setState(() {
                                          _loading = true;
                                        });
                                        phoneCredential(context, _otp,);

                                    }
                                  }
                                }
                              }
                            }
                          }
                          else{
                            setState(() {
                              _loading = false;
                            });
                          }
                          if(value.length==0)
                          {
                            node.previousFocus();
                          }

                        },
                      ),
                    ),


                  ],
                ),
                SizedBox(height: 18,),
                if(_loading)
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 50,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme
                            .of(context)
                            .primaryColor),
                      ),
                    ),
                  ),
                SizedBox(height: 18,),
                Text(error,style: TextStyle(color: Colors.red,fontSize: 12),)
              ],
    ),
      ),
    );
  }
}
