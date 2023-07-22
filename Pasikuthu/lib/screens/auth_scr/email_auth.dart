import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:pasikuthu/services/email_authserv.dart';

import '../reset_pass.dart';

class EmailAuth extends StatefulWidget {
  static const String id = 'emailAuth-screen';
  const EmailAuth({Key? key}) : super(key: key);

  @override
  State<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool _login = false;
  bool _loading = false;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  EmailAuthentication  _service = EmailAuthentication();
  _validateEmail(){
    if(_formKey.currentState!.validate()){
        setState(() {
          _validate = false;
          _loading = true;
        });

        _service.getAdminCredential(_emailController.text,_passwordController.text,_login,context).then((value){
          setState(() {
            _loading = false;
          });
        });
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.red.shade900,
        title: Text('Login',style:
        TextStyle(color: Colors.white),),),
      body: Form(
        key: _formKey,
        child: Padding(
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
              Text('Enter to ${_login? 'Login':'Register'}',style:
              TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
              SizedBox(height: 10,),
              Text('Enter Email and Password to ${_login? 'Login':'Register'}',style: TextStyle(color: Colors.grey),),
              SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
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
                decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                labelText: 'Email',filled: true,fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))
              ),),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: true ,
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: _validate?IconButton(onPressed: (){
                    _passwordController.clear();
                    setState(() {
                      _validate = false;
                    });
                  }, icon: Icon(Icons.clear)) : null,
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Password',filled: true,fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))
              ),
              onChanged: (value){
                if(_emailController.text.isNotEmpty){
                  if(value.length>3){
                    setState(() {
                      _validate = true;
                    });
                  }
                  else{
                    _validate= false;
                  }
                }
              },
              ),

              Align(
                alignment: Alignment.bottomRight,
                  child: TextButton(child :Text('Forgot Passsword?',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),onPressed: (){
                      Navigator.pushNamed(context, PasswordReset.id);
                  },)),
              Row(
                children: [
                  Text(_login?'New Account ?':'Already have an account ?'),
                  TextButton(onPressed:(){
                    setState(() {
                      _login=!_login;
                    });
                  }, child: Text(_login?'Register':'Login',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),))
                ],
              )


            ],

          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AbsorbPointer(
            absorbing: _validate?false:true,
            child: ElevatedButton(
              style: ButtonStyle( backgroundColor: _validate ? MaterialStateProperty.all(Theme.of(context).primaryColor):MaterialStateProperty.all(Colors.grey)),
              onPressed:(){
                _validateEmail();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _loading?SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ):Text('${_login? 'Login':'Register'}',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),),
          ),
        ),
      ),
    );
  }
}
