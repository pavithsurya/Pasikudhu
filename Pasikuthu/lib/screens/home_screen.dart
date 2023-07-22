
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:location/location.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/screens/login-screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/screens/product_list.dart';
import 'package:pasikuthu/widgets/banner_widget.dart';
import 'package:pasikuthu/widgets/category_widget.dart';
import 'package:pasikuthu/widgets/custom_appbar.dart';

import '../widgets/banner_widget1.dart';
import '../widgets/banner_widget2.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String addres = '';
  late bool result = false;
  late bool temp = false;


  @override
  void initState() {
    _checker();
    super.initState();
  }

  _checker() async {
    bool result1 = await InternetConnectionChecker().hasConnection;
    setState(() {
      result = result1;
      temp  = true;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return temp?Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: Size.fromHeight(110),
      child: SafeArea(child: CustomAppbar())),
      body: result?SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize:MainAxisSize.min ,
          children: [
            //SizedBox(height: 10,),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12,0,12,8),
                child: Column(
                  children: [
                    CarouselSlider(
                        items: [BannerWidget(),BannerWidget1()],
                        options: CarouselOptions(
                           height: MediaQuery.of(context).size.height*.28,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                           viewportFraction: 1.0,
                           initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.vertical,
                          //enlargeStrategy:  CenterPageEnlargeStrategy.height,
                        )
                    ),
                      Category(),
                  ],
                ),
              ),
            ),
            //SizedBox(height: 10,),
            ProductList(false),
            
          ],
        )
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('No Internet :('),
    SizedBox(height: 20,),
    ElevatedButton(onPressed: (){
      Navigator.pushReplacementNamed(context, MainScreen.id);

    }, child: Text('Retry'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),)
    ],
    ),
      ),
    ):Container();
  }
}
