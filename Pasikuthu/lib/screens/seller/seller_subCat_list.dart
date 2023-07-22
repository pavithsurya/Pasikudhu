
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/Forms/seller_form.dart';
import 'package:provider/provider.dart';
import '../../provider/cat_provider.dart';
import '../../services/firebase_services.dart';

class SellerSubCatList extends StatelessWidget {
  static const String id = 'seller-subcat-list';
  const SellerSubCatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    final DocumentSnapshot args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.grey)),
        backgroundColor: Colors.red.shade900,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(args['catName'],style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            var data = snapshot.data!['subCat'];

            return Container(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context , int index){
                    //var doc = snapshot.data?.docs[index];
                    return Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8),
                        child: ListTile(
                          onTap: (){
                            _catProvider.getSubCategory(data[index]);
                            Navigator.push (
                              context,
                              MaterialPageRoute (
                                builder: (BuildContext context) => SellerForm(data[index]),
                              ),
                            );
                          },
                          visualDensity: VisualDensity(vertical: 3),
                          title: Text(data[index],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                        )
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}
