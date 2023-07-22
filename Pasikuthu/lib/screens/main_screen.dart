
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/account_screen.dart';
import 'package:pasikuthu/screens/seller/chat/chat_screen.dart';
import 'package:pasikuthu/screens/location_screen.dart';
import 'package:pasikuthu/screens/myAd_screen.dart';
import 'package:pasikuthu/screens/seller/seller_subCat_list.dart';
import 'package:provider/provider.dart';

import '../provider/cat_provider.dart';
import '../services/firebase_services.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget  currentScreen = HomeScreen();
  int _index = 0;
  final PageStorageBucket _bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    _service.users
        .doc(_service.user?.uid)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        if(document['address']==''){
          //print('hi');
          Navigator.push (
            context,
            MaterialPageRoute (
              builder: (BuildContext context) => LocationScreen(true,MainScreen()),
            ),
          );
        }
      }
    });


    var _catProvider = Provider.of<CategoryProvider>(context);
    _catProvider.getUserDetails();
    //FirebaseService _service = FirebaseService();




    showBottomSheet(context){
      showModalBottomSheet(context: context,enableDrag: true, builder: (context) {
        return Scaffold(
            appBar: AppBar(
              shape: Border(bottom: BorderSide(color: Colors.grey)),
              backgroundColor: Colors.red.shade900,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text('Choose Category',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
                                 _catProvider.getCategory(doc?['catName']);
                                 //_catProvider.getCatSnapshot(doc);
                                  if(doc!['subCat']==null){
                                    return print('No sub Categories');
                                  }
                                  Navigator.pushNamed(context, SellerSubCatList.id,arguments: doc);
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

    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      body : PageStorage(
        child: currentScreen,
        bucket:_bucket ,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade900,
        onPressed: (){
          showBottomSheet(context);
        },
        child: CircleAvatar(
          foregroundColor: Colors.red.shade900,
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    MaterialButton(
                      minWidth:40,
                      onPressed: () {
                        setState(() {
                          _index=0;
                          currentScreen=HomeScreen();
                        });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index==0?Icons.home: Icons.home_outlined),
                        Text('HOME',
                        style: TextStyle(color: _index==0?color:Colors.black,
                        fontWeight: _index==0?FontWeight.bold:FontWeight.normal,
                        fontSize: 12),)
                      ],
                    ),),
                    MaterialButton(
                    minWidth:40,
                    onPressed: () {
                      setState(() {
                        _index=1;
                        currentScreen=ChatScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index==1?CupertinoIcons.chat_bubble_fill:CupertinoIcons.chat_bubble),
                        Text('CHATS',
                          style: TextStyle(color: _index==1?color:Colors.black,
                              fontWeight: _index==1?FontWeight.bold:FontWeight.normal,
                          fontSize: 12),)
                      ],
                    ),),
                  
                ],
              ),
              Row(
                children: [
                MaterialButton(
                minWidth:40,
                onPressed: () {
                  setState(() {
                    _index=2;
                    currentScreen=MyAdScreen();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_index==2?CupertinoIcons.heart_fill:CupertinoIcons.heart),
                    Text('DONATIONS',
                      style: TextStyle(color: _index==2?color:Colors.black,
                          fontWeight: _index==2?FontWeight.bold:FontWeight.normal,
                          fontSize: 12),)
                  ],
                ),),
                  MaterialButton(
                    minWidth:40,
                    onPressed: () {
                      setState(() {
                        _index=3;
                        currentScreen=AccountScreen(_service.user!.uid);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index==3?CupertinoIcons.person_fill:CupertinoIcons.person),
                        Text('ACCOUNT',
                          style: TextStyle(color: _index==3?color:Colors.black,
                              fontWeight: _index==3?FontWeight.bold:FontWeight.normal,
                              fontSize: 12),)
                      ],
                    ),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
