import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:pasikuthu/Forms/user_review.dart';
import 'package:pasikuthu/provider/cat_provider.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:provider/provider.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../screens/location_screen.dart';
import '../widgets/image_picker.dart';

class SellerForm extends StatefulWidget {
  String name;

  static const String id = 'seller-form';

  SellerForm(this.name);

  @override
  State<SellerForm> createState() => _SellerFormState();
}

class _SellerFormState extends State<SellerForm> {
  final _formkey = GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();
  var _itemcontroller = TextEditingController();
  var _desccontroller = TextEditingController();
  var _ingridientcontroller = TextEditingController();

  var _servecontroller = TextEditingController();
  var _addresscontroller = TextEditingController();



    validate(CategoryProvider provider){
      if(_formkey.currentState!.validate()){
        if(provider.lst.isNotEmpty){
            provider.dataUpload.addAll({
              'category': provider.selectedCategory,
              'subCat':provider.selectedSubCategory,
              'Item':_itemcontroller.text,
              'Description':_desccontroller.text,
              'Ingredients' : _ingridientcontroller.text,
              'Serves' : _servecontroller.text,
              'seller-uid':_service.user?.uid,
              'images': provider.lst,
              'postedAt' : DateTime.now().microsecondsSinceEpoch,
              'location' : _addresscontroller.text
            });

            Navigator.pushNamed(context, UserReview.id);
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please Upload at least one Image'),)
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Complete Required fields'),)
        );
      }
    }

   @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
     var _provider = Provider.of<CategoryProvider>(context);


     if(_provider.dataUpload.isNotEmpty){
       setState(() {
         _itemcontroller.text =  _provider.dataUpload['Item'];
         _desccontroller.text =  _provider.dataUpload['Description'];
         _ingridientcontroller.text =  _provider.dataUpload['Ingredients'];
         //_pricecontroller.text =  _provider.dataUpload['Price'];
         _servecontroller.text =  _provider.dataUpload['Serves'];
       });
     }

     // setState(() {
     //   _itemcontroller.text = _provider.dataUpload.isEmpty ? '' : _provider.dataUpload['Item'];
     //   _desccontroller.text = _provider.dataUpload.isEmpty ? '' : _provider.dataUpload['Description'];
     //   _ingridientcontroller.text = _provider.dataUpload.isEmpty ? '' : _provider.dataUpload['Ingredients'];
     //   _pricecontroller.text = _provider.dataUpload.isEmpty ? '' : _provider.dataUpload['Price'];
     //   _servecontroller.text = _provider.dataUpload.isEmpty ? '' : _provider.dataUpload['Serves'];
     // });

     if(_provider.userDetails!=null){
       setState(() {
         String add =  _provider.userDetails['address'];
         var ad = add.split(',');
         _addresscontroller.text = ad[0].trim();
       });
     }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<CategoryProvider>(context);
    _provider.getUserDetails();

    // Widget _appbar(){
    //   return AppBar(
    //     backgroundColor: Colors.red.shade900,
    //     automaticallyImplyLeading: false,
    //     title: Text('${widget.name} > Items',style: TextStyle(color: Colors.white),),
    //   );
    // }

    // Widget _itemList(){
    //   return Dialog(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         _appbar(),
    //         Expanded(
    //
    //           child: ListView.builder(itemBuilder: (BuildContext context , int index){
    //             return ListTile(
    //                 title:  Text('hi')//,
    //             );
    //           }),
    //         )
    //       ],
    //     ),
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Donate '+widget.name),
      ),
      body:SafeArea(
        child: Form(
          key: _formkey, child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ITEM',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
                  InkWell(
                    // onTap: (){
                    //     showDialog(context: context, builder: (BuildContext context){
                    //       return _itemList();
                    //     });
                    // },
                    child: TextFormField(
                      controller: _itemcontroller,
                      decoration: InputDecoration(
                        labelText: 'ITEM Name / Dish'
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please complete required field';
                        }
                        return null;
                      },

                    ),
                  ),
                  TextFormField(
                    controller: _desccontroller,
                    maxLines: 10,
                    minLines: 1,
                    //enabled: false,
                    decoration: InputDecoration(
                        labelText: 'Description',
                      helperText: 'Enter small description'
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please complete required field';
                      }
                      return null;
                    },

                  ),
                  TextFormField(
                    controller: _ingridientcontroller,
                    maxLines: 5,
                    minLines: 1,
                    //enabled: false,
                    decoration: InputDecoration(
                        labelText: 'Main Ingredients'
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please complete required field';
                      }
                      return null;
                    },

                  ),
                  // TextFormField(
                  //   controller: _pricecontroller,
                  //    keyboardType: TextInputType.number,
                  //   //enabled: false,
                  //   decoration: InputDecoration(
                  //       labelText: 'Price',
                  //     prefixText: 'Rs. '
                  //   ),
                  //   validator: (value){
                  //     if(value!.isEmpty){
                  //       return 'Please complete required field';
                  //     }
                  //     return null;
                  //   },
                  //
                  // ),
                  TextFormField(
                    controller: _servecontroller,
                     keyboardType: TextInputType.number,
                    //enabled: false,
                    decoration: InputDecoration(
                        labelText: 'Serves People Count',
                        helperText: 'Enter People Count',
                        prefixText: 'Num. ',
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please complete required field';
                      }
                      return null;
                    },

                  ),
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
                              labelText: 'Location',
                              counterText: 'Post Location'

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
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LocationScreen(true,SellerForm(widget.name))));
                      }, icon: Icon(Icons.arrow_forward_ios,
                        size: 18,))
                    ],
                  ),

                  SizedBox(height: 10,),
                  Divider(color: Colors.grey,),

              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return ImagePickerWidget();
                  });
                },
                child: Neumorphic(
                  style: NeumorphicStyle(

                  ),
                  child: Container(
                    height: 40,
                    child: Center(child: Text(_provider.lst.length>0?'Upload more Images':'Upload Image'),),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  if(_provider.lst.length>0){
                    SwipeImageGallery(context: context,children: _provider.wid).show();
                  }
                },
                child: Neumorphic(
                  style: NeumorphicStyle(

                  ),
                  child: Container(
                    height: 40,
                    child: Center(child: Text('Show Images'),),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  _provider.clearList();
                },
                child: Neumorphic(
                  style: NeumorphicStyle(

                  ),
                  child: Container(
                    height: 40,
                    child: Center(child: Text('Clear'),),
                  ),
                ),
              ),
                  SizedBox(height: 70,),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('Next',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold),),
                ),
                onPressed: (){
                      validate(_provider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
