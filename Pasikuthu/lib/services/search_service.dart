
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/product_list.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:intl/intl.dart';

import '../provider/product_provider.dart';
import '../screens/product_details_screen.dart';
import 'firebase_services.dart';

class Products {
  final String Item, Ingredients,Description,Serves,category,subCat,location ;
  final int postedDate;
  final DocumentSnapshot document;

  Products({required this.Item, required this.Ingredients, required this.Description,
      required this.Serves, required this.category, required this.subCat, required this.postedDate, required this.location,required this.document});
}
class SearchService{
  late DocumentSnapshot sellerDetails;

        search({context,productList}){
          showSearch(
            context: context,
            delegate: SearchPage<Products>(
              barTheme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.white,foregroundColor: Colors.black),
                  inputDecorationTheme: InputDecorationTheme(hintStyle: TextStyle(color: Colors.black54,fontSize: 17,fontFamily: 'Lato'),
                border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.transparent)),)),
              onQueryUpdate: print,
              items: productList,
              searchLabel: 'Search Donations',
              suggestion: SingleChildScrollView(child: ProductList(true)),
              failure: const Center(
                child: Text('No donations found :('),
              ),
              filter: (product) => [
                product.Item,
                product.Ingredients,
                product.Description,
                //product.price,
                product.Serves,
                product.category,
                product.subCat,
                product.location,
              ],
              builder: (product) {
          FirebaseService _service = FirebaseService();
          _service .getSellerData(product.document['seller-uid']).then((value) {
            sellerDetails = value;
          });
                var _provider = Provider.of<ProductProvider>(context);
                final _formate = NumberFormat('##,##,##0');
                //var _price = int.parse(product.price);
                //String _formattedPrice = '₹ ${_formate.format(_price)}';
                var dt = DateTime.fromMicrosecondsSinceEpoch(product.postedDate);
                var d12 = DateFormat('dd/MM/yyyy, hh:mm a').format(dt);

                return InkWell(
                  onTap: (){
                    _provider.getProductDetails(product.document);
                    _provider.getSellerDetails(sellerDetails);
                    Navigator.push (
                      context,
                      MaterialPageRoute (
                        builder: (BuildContext context) => ProductDetails(),
                      ),
                    );
                  },
                  child: Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 130,
                              child: Image.network(product.document['images'][0]),
                            ),
                            SizedBox(width: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5,),
                                    Text(product.Item,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Lato'),),
                                    //Text(_formattedPrice,style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,fontFamily: 'Lato'),),
                                    SizedBox(height: 10,),
                                    Row(children: [Icon(Icons.fastfood,color: Colors.red.shade500,size: 15,),Text('  '+product.category+' ('+product.subCat+')',style: TextStyle(fontFamily: 'Lato'),)],),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,color: Colors.red.shade500,size: 15,),
                                        Text('  '+d12,style: TextStyle(fontSize: 12,fontFamily: 'Lato'),),
                                      ],
                                    )
                                  ],
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          );
        }
}