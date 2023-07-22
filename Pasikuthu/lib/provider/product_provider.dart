import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasikuthu/services/firebase_services.dart';

class ProductProvider with ChangeNotifier{

  late DocumentSnapshot productdata ;
  late DocumentSnapshot sellerDetails ;


  getProductDetails(details){
      this.productdata = details;
      notifyListeners();
  }

  getSellerDetails(details){
    this.sellerDetails = details;
    notifyListeners();
  }

}