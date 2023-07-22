import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/firebase_services.dart';
import '../widgets/product_card.dart';

class MyAdScreen extends StatelessWidget {
  const MyAdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _formate = NumberFormat('##,##,##0');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Donations',),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(

          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12,8,12,8),
            child: FutureBuilder<QuerySnapshot>(
              future: _service.items.where('seller-uid',isEqualTo: _service.user?.uid).orderBy('postedAt').get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 140,right: 140),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      backgroundColor: Colors.grey.shade100,
                    ),
                  );
                }
                if(snapshot.data?.size==0){return Container(height:MediaQuery.of(context).size.height/1.25,child: Center(child: Text("You haven't donated yet" ,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)));}


                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(height: 56,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Posts',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        )),

                    new GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2/2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 10
                      ),itemCount: snapshot.data?.size,
                      itemBuilder: (BuildContext context, int i) {
                        var data = snapshot.data?.docs[i];
                        var _price = 0;
                        String _formattedPrice = '₹ ${_formate.format(_price)}';
                        return ProductCard(data: data, formattedPrice: _formattedPrice,sug: false,);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
