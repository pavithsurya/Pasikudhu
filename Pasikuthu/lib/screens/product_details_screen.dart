import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart'as launcher;
import 'package:pasikuthu/provider/product_provider.dart';
import 'package:pasikuthu/screens/account_screen.dart';
import 'package:pasikuthu/screens/seller/chat/chat_conversation_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Forms/edit_seller_form.dart';
import 'main_screen.dart';
class ProductDetails extends StatefulWidget {
  static const String id = 'product-detals-screen';


  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late GoogleMapController _controller;
  FirebaseService _service = FirebaseService();
  late DocumentSnapshot userdoc;
  bool loading = true;
  int index = 0;
  final _format = NumberFormat('##,##,##0');

  @override
  void initState() {
    _service.getUserData().then((value){
      setState(() {
        userdoc = value;
      });
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        loading = false;
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
  _callSeller(String number){
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
      launchUrl(launchUri);
  }

  createChatRoom(ProductProvider _provider){
    var _prodprovider = Provider.of<ProductProvider>(context);
    Map product = {
      'productId' : _provider.productdata.id,
      'productImage':_provider.productdata['images'][0],
      //'price':_provider.productdata['Price'],
      'Item':_provider.productdata['Item'],
      'seller':_provider.productdata['seller-uid']
    };
    List<String> users = [
      _provider.sellerDetails['uid'],//seller
      _service.user!.uid, //buyer
    ];
    String chatRoomId = '${_provider.sellerDetails['uid']}.${_service.user!.uid}.${_provider.productdata.id}';
    Map<String,dynamic> chatData = {
      'users':users,
      'chatRoomId':chatRoomId,
      'product':product,
      'read':false,
      'lastChat':null,
      'lastSentBy':null,
      'lastChatTime':DateTime.now().microsecondsSinceEpoch
    };
    _service.createChatRoom(chatData: chatData);
    Navigator.push (
      context,
      MaterialPageRoute (
        builder: (BuildContext context) =>  ChatConversations(chatRoomId: chatRoomId,name: _prodprovider.sellerDetails['name'],number: _prodprovider.sellerDetails['mobile'],),
      ),
    );
  }

 // const ProductDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    var _prodprovider = Provider.of<ProductProvider>(context);
    var data = _prodprovider.productdata;
    var _price = 0;
    String price = _format.format(_price);
    var dt = DateTime.fromMicrosecondsSinceEpoch(data['postedAt']);
    var d12 = DateFormat('dd/MM/yyyy, hh:mm a').format(dt);
    GeoPoint _location = _prodprovider.sellerDetails['location'];

    showConfirmDialog(){
      return showDialog(context: context, builder: (BuildContext context){
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Complete profile',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold) ,),
                SizedBox(height: 10,),
                Text('Complete your profile and start a chat'),
                SizedBox(height: 10,),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      alignment: Alignment.center,
                      child: NeumorphicButton(
                        child: Text('Go to Profile',style: TextStyle(color: Colors.white),),
                        style: NeumorphicStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: (){
                          Navigator.push (
                            context,
                            MaterialPageRoute (
                              builder: (BuildContext context) => AccountScreen(_service.user!.uid),
                            ),
                          );

                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          if(_prodprovider.productdata['seller-uid']==_service.user!.uid )IconButton(onPressed: (){_service.deleteProduct(_prodprovider.productdata.id);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item Deleted'))
          );}, icon: Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                color: Colors.grey.shade300,
                child: loading?Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 10,),
                    Text('Loading')
                  ],
                ),):
                Stack(
                  children: [
                    Center(
                      child: PhotoView(
                        backgroundDecoration: BoxDecoration(color: Colors.grey.shade300),
                        imageProvider: NetworkImage(data['images'][index]),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12,right: 12),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: data['images'].length,
                              itemBuilder: (BuildContext context , int i){
                            return InkWell(
                              onTap: (){
                                setState(() {
                                  index = i;
                                });
                              },
                              child: Container(
                                  height:60,
                                  width:60,
                                  child: Image.network(data['images'][i]),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                ),
                              ),
                            );
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            loading ? Container():Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(data['Item'].toUpperCase(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                        Text(' ('+data['subCat']+')',style: TextStyle(fontSize: 23),)
                      ],
                    ),
                    // SizedBox(height: 10,),
                    // Text('₹ '+price,style: TextStyle(fontSize: 20,),),
                    SizedBox(height: 10,),
                    Text(data['category'],style: TextStyle(color: Theme.of(context).primaryColor),),
                    SizedBox(height: 10,),
                    Text('Description :',style :TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['Description'],),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text(data['Ingredients'].toUpperCase(),style :TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                Text(' (incl)')
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text('SERVES : '),
                                Text(data['Serves'],style :TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 10,),
                    Text('Posted at '+d12),
                    Divider(color: Colors.grey,),
                    Row(
                      children: [
                        Icon(CupertinoIcons.person_crop_circle,color: Colors.red.shade600,size: 60,),
                        SizedBox(width:10 ,),
                        Expanded(
                          child: ListTile(title: Text(_prodprovider.sellerDetails['name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          subtitle: Text('See Profile',style: TextStyle(color: Theme.of(context).primaryColor),),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,),
                          onTap: (){
                            Navigator.push (
                              context,
                              MaterialPageRoute (
                                builder: (BuildContext context) => AccountScreen(_prodprovider.sellerDetails['uid']),
                              ),
                            );
                          },)
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey,),
                    Container(alignment:Alignment.center,child: TextButton.icon(onPressed: (){_mapLauncher(_location);},style: ButtonStyle(alignment: Alignment.center), label: Text(_prodprovider.sellerDetails['address']), icon: Icon(Icons.location_pin),)),
                    SizedBox(height: 10,),
                    Container(height: 200,color: Colors.grey.shade300,child: Stack(
                      children: [
                        Center(child: GoogleMap(initialCameraPosition: CameraPosition(
                          target: LatLng(_location.latitude,_location.longitude),
                          zoom: 15
                        ),
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller){
                          setState(() {
                            _controller = controller;
                          });
                        },),),
                        Center(child: Icon(Icons.location_on_sharp,size: 35,)),
                        Center(child: CircleAvatar(radius: 60,backgroundColor: Colors.black12,),),
                        Positioned(right:0.0,
                            child: Material(
                              elevation: 4,
                              shape: Border.all(color: Colors.grey.shade300),
                              child: IconButton(icon: Icon(Icons.alt_route_outlined),onPressed: (){
                                _mapLauncher(_location);

                              },),
                            ))

                      ],
                    ),),
                    Row(
                      children: [
                        Expanded(child: Text('AD ID : '+data['postedAt'].toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                        // TextButton(child: Text('REPORT THIS AD'), onPressed: () {  },),
                      ],
                    ),
                    //SizedBox(height: 10,),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _prodprovider.productdata['seller-uid']==_service.user!.uid ?
          Row(
            children: [
              Expanded(child: NeumorphicButton(
                onPressed: (){
                  Navigator.push (
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) => EditSellerForm('Edit Item'),
                    ),
                  );
                },
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_note,size: 16,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Edit Product',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              )),

            ],
          ):Row(
            children: [
              Expanded(child: NeumorphicButton(
                onPressed: (){
                  if(userdoc['name']==''||userdoc['mobile']==''||userdoc['email']==''){
                    showConfirmDialog();
                  }
                  else{
                    print('no');
                    createChatRoom(_prodprovider);
                  }
                },
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat,size: 16,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Chat',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              )),
              SizedBox(width: 20,),
              Expanded(child: NeumorphicButton(
                onPressed: (){
                  _callSeller('${_prodprovider.sellerDetails['contactDetails']['Contactmobile']}');
                },
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call,size: 16,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Call',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              )),

            ],
          ),
        ),
      ),
    );
  }
}
