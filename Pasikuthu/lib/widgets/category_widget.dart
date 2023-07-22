import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/categories/category_list.dart';
import 'package:pasikuthu/screens/categories/subCat_list.dart';
import 'package:pasikuthu/services/firebase_services.dart';

import '../screens/product_by_cat_screen.dart';

class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    showBottomSheet(context){
          showModalBottomSheet(context: context,enableDrag: true, builder: (context) {
            return Scaffold(
                appBar: AppBar(
                  shape: Border(bottom: BorderSide(color: Colors.grey)),
                  backgroundColor: Colors.red.shade900,
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text('Categories',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
                body: Container(
                  child: FutureBuilder<QuerySnapshot>(
                    future: _service.categories.orderBy('sortId',descending: false).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(),);
                      }

                      return Container(
                        child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (BuildContext context , int index){
                              var doc = snapshot.data?.docs[index];
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: (){
                                      if(doc!['subCat']==null){
                                        return print('No sub Categories');
                                      }
                                      Navigator.pushNamed(context, SubCatList.id,arguments: doc);
                                    },
                                    visualDensity: VisualDensity(vertical: 3),
                                    leading: Image.network(doc?['image'],),
                                    title: Text(doc?['catName'],style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                    trailing: Icon(Icons.arrow_forward_ios,size: 15,),
                                  )
                              );
                            }),
                      );
                    },
                  ),
                )
            );
          });


    }



    return Container(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.categories.orderBy('sortId',descending: false).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          return Container(
            height: 200,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('Categories',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                      TextButton(child: Row(
                        children: [
                          Text('See all'),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ), onPressed: () {
                        //Navigator.pushNamed(context, CategoryList.id);
                        showBottomSheet(context);
                      },),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context , int index){
                      var doc = snapshot.data?.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          print(doc!['catName']);
                            if(doc!['subCat']==null){
                            return print('No sub Categories');
                            }
                            Navigator.pushNamed(context, SubCatList.id,arguments: doc);

                          },
                          child: Container(
                          child: Column(
                          children: [
                          Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(doc!['image'],width: 100,height: 100,),
                          ),
                          //Flexible(child: Text(doc['catName'].toUpperCase(),maxLines:2,textAlign:TextAlign.center,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                          ],
                          ),

                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
