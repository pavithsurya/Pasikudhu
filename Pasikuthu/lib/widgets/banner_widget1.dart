import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pasikuthu/screens/seller/seller_subCat_list.dart';
import 'package:pasikuthu/services/firebase_services.dart';

import '../screens/categories/subCat_list.dart';

class BannerWidget1 extends StatefulWidget {
  const BannerWidget1({Key? key}) : super(key: key);

  @override
  State<BannerWidget1> createState() => _BannerWidget1State();
}

class _BannerWidget1State extends State<BannerWidget1> {
  FirebaseService _service = FirebaseService();
  late DocumentSnapshot docsnap;

  @override
  void initState() {
    _service.getCategoryDetails('QyVISNiIoCySW6ZcwliS').then((value){
      docsnap = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
          width :MediaQuery.of(context).size.width,
          height :MediaQuery.of(context).size.height*.25,
          color: Colors.red.shade900,
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(fit:BoxFit.cover,image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/pasikudhu-fdce3.appspot.com/o/categories%2FScreenshot%202022-11-13%20224522.jpg?alt=media&token=ed0eac3d-cef2-4bc7-9c4d-1085ae71dd76',),
            )),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text('Tiffin\nItems',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 25
                            ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 45.0,
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  isRepeatingAnimation: true,
                                  animatedTexts: [
                                    FadeAnimatedText('New way to \nDonate and Collect Food',textStyle: TextStyle(fontFamily: 'Lato'),
                                        duration: Duration(seconds: 4)),
                                    // FadeAnimatedText('Many more Tiffin Items\n are there for you',textStyle: TextStyle(fontFamily: 'Lato')
                                    //     ,duration: Duration(seconds: 4)),
                                    // FadeAnimatedText('Reach more customers!',textStyle: TextStyle(fontFamily: 'Lato'),
                                    //     duration: Duration(seconds: 4)),

                                  ],
                                ),
                              ),
                            )

                          ],
                        ),
                        Neumorphic(
                          style: NeumorphicStyle(
                            color: Colors.black26,
                            oppositeShadowLightSource: true,
                          ),
                          child: Padding(

                              padding: const EdgeInsets.all(8.0),
                              child: Image.network('https://firebasestorage.googleapis.com/v0/b/pasikudhu-fdce3.appspot.com/o/categories%2Fpngwing.com%20(5).png?alt=media&token=20e3166a-053f-437b-a77d-aeb061effbfb',width: 100,height: 100,)
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: NeumorphicButton(
                        onPressed: (){
                          Navigator.pushNamed(context, SubCatList.id,arguments: docsnap);
                        },
                        style: NeumorphicStyle(color: Colors.white),
                        child: Text('Collect food',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                      )),
                      SizedBox(width: 20,),
                      Expanded(child: NeumorphicButton(
                        onPressed: (){
                          Navigator.pushNamed(context, SellerSubCatList.id,arguments: docsnap);

                        },
                        style: NeumorphicStyle(color: Colors.white),
                        child: Text('Donate food',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                      )),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
