import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pasikuthu/screens/seller/seller_subCat_list.dart';
import 'package:pasikuthu/services/firebase_services.dart';

import '../screens/categories/subCat_list.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  FirebaseService _service = FirebaseService();
  late DocumentSnapshot docsnap;

  @override
  void initState() {
    _service.getCategoryDetails('OFFjXeFxGdOPyIeerYeo').then((value){
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
            decoration: BoxDecoration(image: DecorationImage(fit:BoxFit.cover,image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/pasikudhu-fdce3.appspot.com/o/categories%2FScreenshot%202022-11-13%20220400%20(1).jpg?alt=media&token=8c4c06f7-0950-4d6c-8347-9860989a2d22',),
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
                          Text('Rice\nDishes',style: TextStyle(
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
                          FadeAnimatedText('Collect and Donate easily!',textStyle: TextStyle(fontFamily: 'Lato'),
                          duration: Duration(seconds: 4)),
                          // FadeAnimatedText('New way to \nBuy and Sell Dishes',textStyle: TextStyle(fontFamily: 'Lato'),
                          //     duration: Duration(seconds: 4)),
                          // FadeAnimatedText('Many more Rice dishes\n are there for you',textStyle: TextStyle(fontFamily: 'Lato')
                          // ,duration: Duration(seconds: 4)),
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
                          child: Image.network('https://firebasestorage.googleapis.com/v0/b/pasikudhu-fdce3.appspot.com/o/banner%2Fkisspng-thai-fried-rice-arroz-con-pollo-pilaf-biryani-spicy-food-5b22a6223e61b4.3604011815289974102555.png?alt=media&token=968bc656-6775-424d-800c-f5bf5632620c',width: 100,height: 100,)
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
