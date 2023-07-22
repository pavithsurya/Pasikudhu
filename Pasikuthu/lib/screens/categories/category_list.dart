import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_services.dart';




//NOT USED FN





class CategoryList extends StatelessWidget {
  static const String id = 'category-list';
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FirebaseService _service = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.grey)),
        backgroundColor: Colors.red.shade900,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Categories',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.get(),
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
                        visualDensity: VisualDensity(vertical: 3),
                        leading: Image.network(doc?['image'],),
                        title: Text(doc?['catName'],style: TextStyle(fontSize: 15),),
                        trailing: Icon(Icons.arrow_forward_ios,size: 15,),
                      )
                    );
                  }),
            );
          },
        ),
      )
    );
  }
}
