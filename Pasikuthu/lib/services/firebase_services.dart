import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as b;
import 'package:location/location.dart';
import '../screens/home_screen.dart';



class FirebaseService{
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');



  Future<void> updateUser(Map<String,dynamic>data,context,screen) async {
    Location location = new Location();
    LocationData _locationData;
    _locationData = await location.getLocation();
    return users
        .doc(user?.uid)
        .update(data)
        .then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute (
        builder: (BuildContext context) => screen,),);
    })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update location'))
          );
    });
  }

  Future<String> getAddress(lat,lng) async{
    List<b.Placemark> placemarks = await b.placemarkFromCoordinates(lat,lng);


    return placemarks.reversed.last.subLocality.toString()+" , "+placemarks.reversed.last.locality.toString()+" , "+placemarks.reversed.last.administrativeArea.toString()+" , "+placemarks.reversed.last.postalCode.toString();


  }
  Future<DocumentSnapshot>getUserData() async{
    DocumentSnapshot doc =  await users.doc(user?.uid).get();
    return doc;
  }
  Future<DocumentSnapshot>getSellerData(id) async{
    DocumentSnapshot doc =  await users.doc(id).get();
    return doc;
  }

  Future<DocumentSnapshot>getProductDetails(id) async{
    DocumentSnapshot doc =  await items.doc(id).get();
    return doc;
  }
  Future<DocumentSnapshot>getCategoryDetails(id) async{
    DocumentSnapshot doc =  await categories.doc(id).get();
    return doc;
  }

  createChatRoom({chatData}){
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e){
      print(e.toString());
    });
  }

  createChat(String chatRoomId,message){
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e){
      print(e.toString());
    });
    messages.doc(chatRoomId).update({
      'lastChat': message['message'],
      'lastChatTime' : message['time'],
      'read':false,
      'lastSentBy':message['sentBy']
    });
  }
  getChat(chatRoomId)async {
    return messages.doc(chatRoomId).collection('chats').orderBy('time').snapshots();
  }
  deleteChat(chatRoomId)async {
    return messages.doc(chatRoomId).delete();
  }
  deleteProduct(productid)async {
    return items.doc(productid).delete();
  }

}