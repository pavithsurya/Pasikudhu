import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/Forms/seller_form.dart';
import 'package:pasikuthu/Forms/user_review.dart';
import 'package:pasikuthu/provider/cat_provider.dart';
import 'package:pasikuthu/provider/product_provider.dart';
import 'package:pasikuthu/screens/auth_scr/emamil_verify.dart';
import 'package:pasikuthu/screens/auth_scr/phone_auth.dart';
import 'package:pasikuthu/screens/categories/category_list.dart';
import 'package:pasikuthu/screens/categories/subCat_list.dart';
import 'package:pasikuthu/screens/home_screen.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/screens/login-screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/screens/product_by_cat_screen.dart';
import 'package:pasikuthu/screens/product_details_screen.dart';
import 'package:pasikuthu/screens/reset_pass.dart';
import 'package:pasikuthu/screens/seller/edit_profile.dart';
import 'package:pasikuthu/screens/seller/seller_subCat_list.dart';
import 'package:pasikuthu/screens/splash_scr.dart';
import 'package:pasikuthu/screens/auth_scr/email_auth.dart';
import 'package:provider/provider.dart';

import 'Forms/edit_user_review.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(

      MultiProvider(providers: [
        Provider (create: (_) => CategoryProvider()),
        Provider (create: (_) => ProductProvider()),

      ],child: const MyApp() ,)
     );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
                  fontFamily: 'Lato',
                  primaryColor: Colors.red.shade900
                ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        loginscr.id: (context) => loginscr(),
        Phoneauth.id: (context) => Phoneauth(),
        LocationScreen.id: (context) => LocationScreen(false,MainScreen()),
        EmailAuth.id: (context) => EmailAuth(),
        EmailVerification.id : (context) => EmailVerification(),
        PasswordReset.id : (context) => PasswordReset(),
        HomeScreen.id : (context) => HomeScreen(),
        CategoryList.id : (context) => CategoryList(),
        SubCatList.id : (context) => SubCatList(),
        MainScreen.id : (context) => MainScreen(),
        SellerSubCatList.id : (context) => SellerSubCatList(),
        UserReview.id : (context) => UserReview(),
        EditUserReview.id : (context) => EditUserReview(),
        ProductDetails.id : (context) => ProductDetails(),
        ProductByCat.id : (context) => ProductByCat(),
        SellerForm.id : (context) => SellerForm(" "),
        EditProfile.id : (context) => EditProfile(),


      },
    );


    // return FutureBuilder(
    //   // Replace the 3 second delay with your initialization code:
    //   future: Future.delayed(Duration(seconds: 3)),
    //   builder: (context, AsyncSnapshot snapshot) {
    //     // Show splash screen while waiting for app resources to load:
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //           theme: ThemeData(
    //               fontFamily: 'Lato',
    //               primaryColor: Colors.red.shade900
    //           ),
    //           home: SplashScreen());
    //     } else {
    //       // Loading is done, return the app:
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(
    //           fontFamily: 'Lato',
    //           primaryColor: Colors.red.shade900
    //         ),
    //         home: loginscr(),
    //         routes: {
    //           loginscr.id: (context) => loginscr(),
    //           Phoneauth.id: (context) => Phoneauth(),
    //           LocationScreen.id: (context) => LocationScreen(),
    //         },
    //       );
    //     }
    //   },
    // );
  }
}
