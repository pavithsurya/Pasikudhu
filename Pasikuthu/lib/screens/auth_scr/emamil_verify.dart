import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';

class EmailVerification extends StatelessWidget {
  static const String id = 'email-ver';
  //const EmailVerification({Key? key}) : super(key: key);
  FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children :[
            Text('Verify Email',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Theme.of(context).primaryColor),),
              Text('Check your email to verify your registered Email \n (If email not found check in Spam)\nIf verified press refresh and go next',style: TextStyle(color: Colors.grey),),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),onPressed: () async {
                      var result = await OpenMailApp.openMailApp();

                      if (!result.didOpen && !result.canOpen) {
                        showNoMailAppsDialog(context);


                      } else if (!result.didOpen && result.canOpen) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return MailAppPickerDialog(
                              mailApps: result.options,
                            );
                          },
                        );
                      }
                      Navigator.pushReplacementNamed(context, EmailVerification.id);
                    }, child: Text('Verify Email')),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(
                        style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),onPressed: () async {

                      _service.user!.reload();
                      Navigator.pushReplacementNamed(context, EmailVerification.id);
                    }, child: Text('Refresh')),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(
                        style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),onPressed: () async {

                      _service.user!.reload();
                      print(_service.user!.emailVerified);
                      if(_service.user!.emailVerified){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LocationScreen(false, LocationScreen(false,MainScreen()))),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }, child: Text('Next')),
                  ),
                ],
              )
          ],
      ),
        ),),
    );
  }
  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

}
