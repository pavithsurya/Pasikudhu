import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:pasikuthu/services/search_service.dart';

import '../screens/location_screen.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  FirebaseService _service = FirebaseService();
  SearchService _search = SearchService();

  static List<Products> products = [];
  @override
  void initState() {
    _service.items.get().then((QuerySnapshot snapshot){
      snapshot.docs.forEach((doc) {
        products.add(
          Products(Item: doc['Item'], Ingredients:  doc['Ingredients'], Description:  doc['Description'], Serves: doc['Serves'], category: doc['category'], subCat: doc['subCat'], postedDate: doc['postedAt'],location: doc['location'], document: doc)
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Address is not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          if(data['address']==null){
            if(data['state']==null){
              GeoPoint latlong = data['location'];
              _service.getAddress(latlong.latitude, latlong.longitude).then((adres){
                return appBar(adres, context);
              });
            }
          }else if(data['address']!=''){

            return appBar(data['address'], context);
          }

        }

        return Text("");
      },
    );
  }

  Widget appBar(address,context){
    var ad = address.split(',');
    var addd;
    ad[0].length>1?addd = ad[0]:addd = ad[1];

    return AppBar(

      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: (){
          Navigator.push (
            context,
            MaterialPageRoute (
              builder: (BuildContext context) => LocationScreen(true,MainScreen()),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Icon(CupertinoIcons.location_solid,color: Colors.black,size: 18,),
              Flexible(child: Text(" "+addd+" ",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),
              Icon(Icons.keyboard_arrow_down_outlined,color: Colors.black,size: 18,),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56) ,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: InkWell(
                      onTap: (){
                        _search.search(context: context,productList: products);
                      },
                      child: Container(
                        child: TextField(
                          enabled: false,
                          onTap: (){

                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelText: 'Find donations and more',
                              labelStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.only(left: 10,right: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
