import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasikuthu/services/firebase_services.dart';

class CategoryProvider with ChangeNotifier{

  FirebaseService _service = FirebaseService();
late DocumentSnapshot doc;
late DocumentSnapshot userDetails ;
late String selectedCategory;
late String selectedSubCategory;
List<String> lst = [];
List<Widget> wid = [];
Map<String,dynamic> dataUpload = {};

getCategory(selectedCat){
  this.selectedCategory = selectedCat;
  //print('yes');
  notifyListeners();
}
  getSubCategory(selectedsubCat){
    this.selectedSubCategory = selectedsubCat;
    //print('no');
    notifyListeners();
  }
getCatSnapshot(snapshot){
  this.doc = snapshot;
  notifyListeners();
}
getImages(url){
  this.lst.add(url);
  notifyListeners();
}
getWidget(url){
  this.wid.add(Image.network(url));
  notifyListeners();
}
getData(data){
  this.dataUpload = data;
}
getUserDetails(){
  _service.getUserData().then((value){
    this.userDetails = value;
    notifyListeners();
  });
}
clearData(){
  this.lst = [];
  this.dataUpload = {};
  notifyListeners();
}
  clearList(){
    this.lst = [];
    this.wid = [];
    notifyListeners();
  }
}