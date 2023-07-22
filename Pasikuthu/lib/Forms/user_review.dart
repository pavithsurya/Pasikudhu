import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../provider/cat_provider.dart';
import '../screens/location_screen.dart';

class UserReview extends StatefulWidget {
  static const String id = 'user-review';
  const UserReview({Key? key}) : super(key: key);

  @override
  State<UserReview> createState() => _UserReviewState();
}

class _UserReviewState extends State<UserReview> {

  final _formkey = GlobalKey<FormState>();
  bool _loading = false;

  FirebaseService _service = FirebaseService();
  var _namecontroller = TextEditingController();
  var _countrycodecontroller = TextEditingController(text: '+91');
  var _phonecontroller = TextEditingController();
  var _emailcontroller = TextEditingController();
  var _addresscontroller = TextEditingController();

  @override
  void didChangeDependencies() {
    var _provider = Provider.of<CategoryProvider>(context);
    _provider.getUserDetails();
    if(_provider.userDetails!=null){
      setState(() {
        _namecontroller.text = _provider.userDetails['name'];
        _phonecontroller.text = _provider.userDetails['mobile']!=""?_provider.userDetails['mobile'].substring(3,):_provider.userDetails['mobile'];
        _emailcontroller.text = _provider.userDetails['email'];
        _addresscontroller.text = _provider.userDetails['address'];

      });
    }
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<CategoryProvider>(context);
    showConfirmDialog(){
      return showDialog(context: context, builder: (BuildContext context){
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirm',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold) ,),
                SizedBox(height: 10,),
                Text('Are you sure want to post the item?'),
                SizedBox(height: 10,),
                ListTile(
                  leading: Image.network(_provider.dataUpload['images'][0]),
                  title: Text(_provider.dataUpload['Item'],maxLines: 1,),
                  //subtitle: Text(_provider.dataUpload['Price']),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NeumorphicButton(
                      child: Text('Cancel'),
                      onPressed: (){
                        setState(() {
                          _loading = false;
                        });
                        Navigator.pop(context);
                      },
                      style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          color: Theme.of(context).primaryColor
                        ),
                        color: Colors.transparent
                      ),
                    ),
                    SizedBox(width: 10,),

                    NeumorphicButton(
                      child: Text('Confirm',style: TextStyle(color: Colors.white),),
                      style: NeumorphicStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: (){
                        setState(() {
                          _loading = true;
                        });
                        updateUser(_provider,{
                          'contactDetails':{
                            'Contactmobile' : '+91'+_phonecontroller.text,
                            'ContactEmail' : _emailcontroller.text
                          },
                          'mobile':'+91'+_phonecontroller.text,
                          'name' : _namecontroller.text,
                        }, context).then((value){
                          setState(() {
                            _loading = false;
                          });
                        });

                      },
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                if(_loading)
                Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ))
              ],
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Review Details'),
      ),
      body: Form(
        key:_formkey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.red.shade50,
                        radius: 38,
                        child: Icon(CupertinoIcons.person_alt,color: Colors.blue.shade600,size: 60,),
                      ),
                    ),
                    SizedBox(width:10 ,),
                    Expanded(
                      child: TextFormField(
                        controller: _namecontroller,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Text('Contact details',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _countrycodecontroller,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Country',
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _phonecontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Mobile number',
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    helperText: 'Enter contact email'
                  ),
                  validator: (value){
                    final bool isValid = EmailValidator.validate(_emailcontroller.text);
                    if(value==null||value.isEmpty){
                      return 'Enter Email';
                    }
                    if(value.isNotEmpty&& isValid==false){
                      return 'Enter valid Email';
                    }
                    return null;

                  },
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        controller: _addresscontroller,
                        keyboardType: TextInputType.number,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: 'Address',
                            counterText: 'Donor Address'

                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please complete required field';
                          }
                          return null;
                        },

                      ),
                    ),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LocationScreen(true,UserReview())));
                    }, icon: Icon(Icons.arrow_forward_ios,
                      size: 18,))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Text('Confirm',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onPressed: (){
                  if(_formkey.currentState!.validate()){

                    showConfirmDialog();

                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter required fields'),)
                    );
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );

  }Future<void> updateUser(provider,Map<String,dynamic>data,context) async {

    return _service.users
        .doc(_service.user?.uid)
        .update(data)
        .then((value) {
          saveItemtoDB(provider,context);

    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update location'))
      );
    });
  }
  Future<void> saveItemtoDB(CategoryProvider provider,context) async {

    return _service.items
        .add(
      provider.dataUpload,
    )
        .then((value) {
          provider.clearData();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Your Ad is posted successfully"))
          );
          Navigator.pushReplacementNamed(context, MainScreen.id);
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update location'))
      );
    });
  }
}
