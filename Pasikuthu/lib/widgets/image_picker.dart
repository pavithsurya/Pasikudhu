
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:pasikuthu/provider/cat_provider.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? image;
  XFile? image1;
  bool uploading = false;

  final ImagePicker _picker = ImagePicker();

   getImage() async {
     image =  await _picker.pickImage(source: ImageSource.gallery);
    setState(()  {
      image1 = image;
    });

  }

  @override
  Widget build(BuildContext context) {


     var _provider = Provider.of<CategoryProvider>(context);


     Future<String> uploadFile(String filepath) async {
       String downloadurl = '';
       File file = File(filepath);
       String imagename = 'ItemImage/${DateTime.now().microsecondsSinceEpoch}';

       try {
         await FirebaseStorage.instance.
         ref(imagename)
         .putFile(file);
         downloadurl = await FirebaseStorage.instance.ref(imagename).getDownloadURL();
         if(downloadurl!=''){
           setState(() {
             image= null;
             _provider.getImages(downloadurl);
             _provider.getWidget(downloadurl);
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



    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min  ,
        children: [
          AppBar(
            backgroundColor: Colors.red.shade900,
            title: Text('Upload Images'),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if(image!=null)
                    Positioned(
                      right: 0,
                        child: IconButton(icon: Icon(Icons.clear), onPressed: () {
                      setState(() {
                        image = null;
                      });
                    },)),
                    Container(height: 120,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(child:image == null ? Icon(CupertinoIcons.photo_fill_on_rectangle_fill,color: Colors.grey,):Image(image: XFileImage(image1!),)  ),),
                  ],
                ),
                SizedBox(height: 20,),
                if(_provider.lst.length>0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4)
                  ),
                    child: GalleryImage(
                      imageUrls: _provider.lst,
                      numOfShowImages: _provider.lst.length<=3 ?_provider.lst.length : 3,
                    )
                ),
                SizedBox(height: 20,),
                if(image!=null)
                Row(
                  children: [
                    Expanded(child: NeumorphicButton(
                      style: NeumorphicStyle(color: Colors.green.shade600),
                      onPressed: (){
                          setState(() {
                            uploading = true;
                            uploadFile(image!.path).then((url){
                              if(url!=''){
                                setState(() {
                                  uploading = false;
                                });
                              }
                            });
                          });

                        },
                      child: Text('Save',textAlign: TextAlign.center,),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: NeumorphicButton(
                      style: NeumorphicStyle(color: Colors.red.shade600),
                      onPressed: (){

                      },
                      child: Text('Cancel',textAlign: TextAlign.center,),
                    )),
                  ],
                ),

                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImage,
                        style: NeumorphicStyle(color: Colors.red.shade900 ),
                          child: Text(_provider.lst.length>0 ? 'Upload More Images':'Upload Image',textAlign:TextAlign.center,style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:20 ,),
                if(uploading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
