
import 'dart:io';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasikuthu/screens/account_screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../../provider/cat_provider.dart';
import '../../services/firebase_services.dart';
import '../location_screen.dart';


class EditProfile extends StatefulWidget {
  static const String id = 'edit-profile';
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  
  
  

  final _formkey = GlobalKey<FormState>();
  bool _loading = false;

  FirebaseService _service = FirebaseService();
  var _namecontroller = TextEditingController();
  var _countrycodecontroller = TextEditingController(text: '+91');
  var _phonecontroller = TextEditingController();
  var _emailcontroller = TextEditingController();
  var _addresscontroller = TextEditingController();
  late String _image ;
  XFile? image;
  XFile? image1;


  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    var _provider = Provider.of<CategoryProvider>(context);
    _provider.getUserDetails();
    if(_provider.userDetails!=''){
      setState(() {
        _namecontroller.text = _provider.userDetails['name'];
        _emailcontroller.text = _provider.userDetails['email'];
        _addresscontroller.text = _provider.userDetails['address'];

      });
    }
    if(_provider.userDetails['mobile']!=''){
      setState(() {
        _phonecontroller.text = _provider.userDetails['mobile'].substring(3,);
      });
    }

    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }


  getImage() async {
    image =  await _picker.pickImage(source: ImageSource.gallery);
    setState(()  {
      image1 = image;
    });

  }

  @override
  Widget build(BuildContext context) {
    bool uploading = false;
    var _provider = Provider.of<CategoryProvider>(context);

    Future<String> uploadFile(String filepath) async {
      String downloadurl = '';
      File file = File(filepath);
      String imagename = 'ProfileImage/${DateTime.now().microsecondsSinceEpoch}';

      try {
        await FirebaseStorage.instance.
        ref(imagename)
            .putFile(file);
        downloadurl = await FirebaseStorage.instance.ref(imagename).getDownloadURL();
        if(downloadurl!=''){
          setState(() {
            image= null;
            _image = downloadurl;
            print(downloadurl);
          });
        }
      } on FirebaseException catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error'))
        );
        // ...
      }
      return downloadurl;
    }

    showConfirmDialog(){
      return showDialog(context: context, builder: (BuildContext context){

        return uploading?Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        )):Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirm',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold) ,),
                SizedBox(height: 10,),
                Text('Are you sure want to edit the details?'),
                SizedBox(height: 10,),

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
                        });image1!=null?
                        updateUser(_provider,{
                          'mobile' : '+91'+_phonecontroller.text,
                          'email' : _emailcontroller.text,
                          'name' : _namecontroller.text,
                          'image':_image
                        }, context).then((value){
                          setState(() {
                            _loading = false;
                          });
                        }):updateUser(_provider,{
                          'mobile' : '+91'+_phonecontroller.text,
                          'email' : _emailcontroller.text,
                          'name' : _namecontroller.text,
                        }, context).then((value){
                          setState(() {
                            _loading = false;
                          });
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                              (Route<dynamic> route) => false,
                        );
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
        title: Text('Edit Profile'),
        backgroundColor: Theme.of(context).primaryColor,
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
                SizedBox(height: 10,),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: image1==null?_provider.userDetails['image']==''?CircleAvatar(
                        backgroundColor: Colors.red.shade900,
                        radius: 90,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 88,
                          child: Icon(CupertinoIcons.person_alt,color: Colors.red.shade900,size: 60,),
                        ),
                      ):CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(_provider.userDetails['image']),
                      ):CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.transparent,
                        backgroundImage: XFileImage(image1!),
                      ),
                    ),
                    Positioned(
                      left: 200,
                      child: InkWell(
                        onTap: getImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade900,
                          child: Icon(Icons.edit,color: Colors.white,),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(width:10 ,),
                TextFormField(
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
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LocationScreen(true,EditProfile())));
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
                  showConfirmDialog();
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      if(image1!=null){
                        uploading = true;
                        uploadFile(image!.path).then((url){
                          if(url!=''){
                            setState(() {
                              uploading = false;
                              Navigator.pop(context);
                              showConfirmDialog();
                            });
                          }
                        });
                      }
                      showConfirmDialog();
                    });

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
  }
  Future<void> updateUser(provider,Map<String,dynamic>data,context) async {

    return _service.users
        .doc(_service.user?.uid)
        .update(data);

  }
}
