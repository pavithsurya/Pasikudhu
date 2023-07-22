import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/login-screen.dart';
import 'package:pasikuthu/services/phone_authserv.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class Phoneauth extends StatefulWidget {
  static const String id = 'phoneauth-screen';
  const Phoneauth({Key? key}) : super(key: key);

  @override
  State<Phoneauth> createState() => _PhoneauthState();
}

class _PhoneauthState extends State<Phoneauth> {
  bool validate = false;
  var countryCodeController = TextEditingController(text:'+91');
  var phoneNumberController = TextEditingController();

  // showAlertDialog(BuildContext context){
  //   AlertDialog alert = AlertDialog(
  //     content: Row(
  //       children: [
  //         CircularProgressIndicator(
  //           valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
  //         ),
  //         SizedBox(width: 8,),
  //         Text('Please wait')
  //       ],
  //     ),
  //   );
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context, builder: (BuildContext context){
  //     return alert;
  //   });
  // }

Phoneauthservice _service = Phoneauthservice();


  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed(){
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => loginscr(),),);
      return Future.value(false);
    }
    ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr.style(message: 'Hold on');
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.red.shade900,
          iconTheme: IconThemeData(color :Colors.white,
          ),
          title: Text('Login',style: TextStyle(color: Colors.white),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:40),
              CircleAvatar(radius: 30,
              backgroundColor: Colors.red.shade900,
                  child: Icon(Icons.person_outline_rounded,color:Colors.white,
                    size: 40,
                  ),),
              SizedBox(height: 12,),
              Text('Enter your Phone',style:
              TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
              SizedBox(height: 10,),
              Text('We will send Confirmation code to your phone',style: TextStyle(color: Colors.grey),),
              Row(
                children: [
                  Expanded(flex:1,child: TextFormField(
                    controller: countryCodeController,
                    enabled: false,
                    decoration: InputDecoration(
                      counterText: '00',
                      labelText: 'Country'
                    ),
                  ),),
                  SizedBox(width: 10,),
                  Expanded(flex : 3,child: TextFormField(
                    onChanged: (value){
                      if(value.length==10)
                        {
                          setState(() {
                            validate=true;
                          });
                        }
                      else{
                        setState(() {
                          validate = false;
                        });
                      }
                    },
                    autofocus: true,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    decoration: InputDecoration(

                        labelText: 'Number',
                      hintText: 'Enter your phone number',
                      hintStyle: TextStyle(fontSize: 10,color: Colors.grey)
                    ),
                  ),),

                ],
              )

            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AbsorbPointer(
              absorbing: validate?false:true,
              child: ElevatedButton(
                style: ButtonStyle( backgroundColor: validate ? MaterialStateProperty.all(Theme.of(context).primaryColor):MaterialStateProperty.all(Colors.grey)),
                onPressed:(){
                  String number = '${countryCodeController.text}${phoneNumberController.text}';
                  pr.show();

                  _service.verifyPhoneNumber(context, number).then((value) => pr.hide());

                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Next',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),),
            ),
          ),
        ),
      ),
    );
  }
}
