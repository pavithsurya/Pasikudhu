import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/provider/product_provider.dart';
import 'package:pasikuthu/screens/product_details_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../provider/cat_provider.dart';

class ProductCard extends StatefulWidget {

  const ProductCard({
    Key? key,
    required this.data,
    required this.sug,
    required String formattedPrice,
  }) : _formattedPrice = formattedPrice, super(key: key);

  final QueryDocumentSnapshot<Object?>? data;
  
  final String _formattedPrice;
  final bool sug;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseService _service = FirebaseService();
  late DocumentSnapshot sellerDetails;
  
  @override
  void initState() {
    _service .getSellerData(widget.data!['seller-uid']).then((value) {
      if(mounted){
        setState(() {
          sellerDetails = value;
        });
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

     return InkWell(
       onTap: (){
         _provider.getProductDetails(widget.data);
         _provider.getSellerDetails(sellerDetails);
         Navigator.push (
           context,
           MaterialPageRoute (
             builder: (BuildContext context) => ProductDetails(),
           ),
         );
       },
       child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height:110,
                child: Center(
                  child: AspectRatio(aspectRatio:150/100,child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),image: DecorationImage(fit:BoxFit.cover,
                      alignment:FractionalOffset.topCenter,image: NetworkImage(widget.data!['images'][0]))),)),
                ),
              ),
              SizedBox(height:15,),
              Align(
                alignment: Alignment.center,
                child: Column(children: [Text(widget.data!['Item'],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Lato',fontSize: 18,fontWeight: FontWeight.bold),),
                  //SizedBox(height: 3,),
                  //Text(widget._formattedPrice+"     ",),
                ],),
              )
              //Text(address,maxLines: 1,)
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10,)]
        ),
    ),
     );

  }
}