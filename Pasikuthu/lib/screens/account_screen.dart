import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasikuthu/screens/seller/edit_profile.dart';
import '../services/firebase_services.dart';
import '../widgets/product_card.dart';
import 'package:map_launcher/map_launcher.dart'as launcher;

class AccountScreen extends StatefulWidget {
  String uid;

  AccountScreen(this.uid);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late DocumentSnapshot userdoc;
  bool _loading = true;
  FirebaseService _service = FirebaseService();
  late GeoPoint _location;

  @override
  void initState() {
    _service.getSellerData(widget.uid).then((value){
      setState(() {
        userdoc = value;
        _loading = false;
        _location =userdoc['location'];
      });
    });
    super.initState();
  }
  _mapLauncher(location) async {
    final availableMaps = await launcher.MapLauncher.installedMaps;


    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: 'Donor Location (Pasikudhu)',
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _formate = NumberFormat('##,##,##0');
    return _loading? Center(child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ),):
      Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(userdoc['uid']==_service.user?.uid ?'My Profile':''),
        actions: [
          if(userdoc['uid']==_service.user?.uid)
            IconButton(icon:Icon(Icons.edit),onPressed: (){
              Navigator.push (
                context,
                MaterialPageRoute (
                  builder: (BuildContext context) => EditProfile(),
                ),
              );
            },)
        ],
        backgroundColor: Colors.red.shade900,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userdoc['image']==''?Container(width: MediaQuery.of(context).size.width,
            color: Colors.grey,
            height: 300,):
          AspectRatio(aspectRatio:130/100,child: Container(decoration: BoxDecoration(color:Colors.grey,boxShadow:[BoxShadow(blurRadius: 10)],borderRadius: BorderRadius.all(Radius.circular(5),),image: DecorationImage(fit:BoxFit.cover,
          alignment:FractionalOffset.topCenter,image: NetworkImage(userdoc['image']))),)),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text(
                    userdoc['name']==''?'Not Specified':userdoc['name'],
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 15),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    userdoc['email']==''?'Not Specified':userdoc['email'],
                    style: TextStyle(
                        fontSize: 18),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Mobile',
                    style: TextStyle(
                        fontSize: 15),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    userdoc['mobile']==''?'Not Specified':userdoc['mobile'],
                    style: TextStyle(
                        fontSize: 18),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Address',
                    style: TextStyle(
                        fontSize: 15),
                  ),

                  TextButton.icon(onPressed: (){_mapLauncher(_location);},style: ButtonStyle(alignment: Alignment.center), label: Text(userdoc['address'],style: TextStyle(fontSize: 18),), icon: Icon(Icons.location_pin,size: 20,),),
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      'ADs',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),

                ],
              ),


            ),
            SizedBox(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12,8,12,8),
                child: FutureBuilder<QuerySnapshot>(
                  future: _service.items.where('seller-uid',isEqualTo: widget.uid).orderBy('postedAt').get(),
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
                    if(snapshot.data?.size==0){return Container(child: Center(child: Text("You haven't posted any AD" ,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)));}


                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [


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
          ],
        ),
      ),
    );
  }
}
