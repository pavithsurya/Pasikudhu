import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as b;
import 'package:location/location.dart';
import 'package:pasikuthu/screens/login-screen.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


import 'auth_scr/phone_auth.dart';
import 'home_screen.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'Location-screen';
  final bool locationChange ;
  final Widget popScreen ;

  LocationScreen(this.locationChange,this.popScreen);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  FirebaseService _service = FirebaseService();
  bool _loading = false;

  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  String manaddress = "";

  Future<LocationData> getLocation() async {

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {

      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {

      }
    }

    _locationData = await location.getLocation();

    List<b.Placemark> placemarks = await b.placemarkFromCoordinates(_locationData.latitude!.toDouble(),_locationData.longitude!.toDouble());



    setState(() {
      address = placemarks.reversed.last.locality.toString()+" , "+placemarks.reversed.last.administrativeArea.toString()+" , "+placemarks.reversed.last.postalCode.toString();
       });


    print(_locationData.latitude);
    return _locationData;

  }

  @override
  Widget build(BuildContext context) {

    if(widget.locationChange==false){
      _service.users
          .doc(_service.user?.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          if(document['address']!=''){
            setState(() {
              _loading = true;
            });
            Navigator.pushReplacementNamed(context, MainScreen.id);
          }else{
            setState(() {
              _loading = false;
            });
          }
        }
      });
    }


    ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr.style(message: 'Fetching location..');
    pr.style(backgroundColor: Theme.of(context).primaryColor);

    showBottomSheet(context){
        getLocation().then((location){
        if(location!=null){
          pr.hide();
          showModalBottomSheet(context: context,isScrollControlled: true,enableDrag: true, builder: (context) {

            return Column(
              children: [
                SizedBox(height: 30,),
                AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Row(
                    children: [
                      SizedBox(height: 10,),
                      Text('Location',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(

                        decoration: InputDecoration(
                          hintText: 'Search City , Area or Neighbourhood',
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                  child: ListTile(
                    onTap: (){
                      pr.show();
                      print(_locationData);
                        getLocation().then((value){
                          if(value!=null){
                            _service.updateUser({
                              'location' : GeoPoint(value.latitude!.toDouble(),value.longitude!.toDouble()),
                              'address' : address
                            }, context,widget.popScreen)
                          .then((value){
                            pr.hide();
                          Navigator.pushReplacement(context, MaterialPageRoute (
                          builder: (BuildContext context) => widget.popScreen,),);
                          });
                          }
                        });
                    },
                    horizontalTitleGap: 0.0,
                    leading: Icon(Icons.my_location,color: Colors.blue,),
                    title: Text('Use Current location',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(location ==  null? 'Enable location' : '$address',style: TextStyle(fontSize: 12),),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,bottom: 4,top: 4),
                    child: Text('CHOOSE CITY',style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 12),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CSCPicker(
                    layout: Layout.vertical,
                    dropdownDecoration: BoxDecoration(
                        shape: BoxShape.rectangle
                    ),
                    defaultCountry: DefaultCountry.India,
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value.toString();
                      });
                    },
                    onStateChanged:(value) {
                      setState(() {
                        stateValue = value.toString();
                      });
                    },
                    onCityChanged:(value) {
                      setState(() {
                        cityValue = value.toString();
                        manaddress = '$cityValue, $stateValue, ${countryValue.substring(8)}';
                      });
                      if(cityValue!='City'){
                        if(value!=null){
                          _service.updateUser({
                            'address' : manaddress,
                            'state' : stateValue,
                            'city' : cityValue,
                            'country' : countryValue.substring(8)

                          }, context,widget.popScreen);
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          });
        }else{
          pr.hide();
        }
       });

    }



      return Scaffold(
          body: Column(
            children: [

              SizedBox(height: 100,
                width: MediaQuery.of(context).size.width,),
              Image.asset('assets/location.png',
                height: 200,
              ),
              SizedBox(height: 30,),
              Text('May we know your \nlocation?',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text('To enjoy all that we have to offer \n we need to know your location',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
              SizedBox(height: 35,),
              _loading? Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8,),
                  Text('Fetching location..')
                ],
              ) : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _loading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):ElevatedButton.icon(
                            style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)), icon:Icon(CupertinoIcons.location_fill),label: Padding(
                            padding: const EdgeInsets.only(top: 15,bottom: 15),
                            child: Text('Around me',style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                            onPressed: (){
                              //pr.show();
                              setState(() {
                                _loading= true;
                              });
                              getLocation().then((value){
                                if(value!=null){
                                  _service.updateUser({
                                    'address' : address,
                                    'location' : GeoPoint(value.latitude!,value.longitude!)
                                  }, context,widget.popScreen).whenComplete((){
                                    //pr.hide();
                                  });
                                }
                              });
                            },

                          ),
                        ),

                      ],
                    ),
                  ),
                  TextButton(onPressed: (){
                    pr.show();
                    showBottomSheet(context);
                  }, child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Set location manually',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,decoration: TextDecoration.underline),),
                  ))
                ],
              )
            ],

          )
      );
    }
  }

