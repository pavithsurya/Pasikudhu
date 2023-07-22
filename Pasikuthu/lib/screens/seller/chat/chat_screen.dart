import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/screens/main_screen.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../../../provider/cat_provider.dart';
import '../../account_screen.dart';
import '../seller_subCat_list.dart';
import 'chat_card.dart';

class ChatScreen extends StatefulWidget {


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseService _service = FirebaseService();
  late DocumentSnapshot userdoc;
  bool _loading = true;
  @override
  void initState() {
    _service.getUserData().then((value){
      setState(() {
        userdoc = value;
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    _catProvider.getUserDetails();

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

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chats',style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorWeight: 2,
              indicatorColor: Colors.white,
              tabs: [
            Tab(text: 'ALL',),
            Tab(text: 'COLLECTION',),
            Tab(text: 'DONATION',)
          ]),
        ),
        body: TabBarView(children: [
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.messages.where('users',arrayContains: _service.user?.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
                }
                if (_loading) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
                }

                if(userdoc['name']==''||userdoc['mobile']==''||userdoc['email']==''){
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Complete your profile and start a chat',style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        Navigator.push (
                          context,
                          MaterialPageRoute (
                            builder: (BuildContext context) => AccountScreen(_service.user!.uid),
                          ),
                        );
                      }, child: Text('Go to profile'),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),)),
                    ],
                  ),);
                }

                if(snapshot.data?.docs.length==0){
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Start a chat by donating or collecting food',style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(onPressed: (){
                            Navigator.pushReplacementNamed(context, MainScreen.id);

                          }, child: Text('Collect Food'),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),)),
                          SizedBox(width: 10,),
                          ElevatedButton(onPressed: (){
                            showBottomSheet(context);

                          }, child: Text('Add Food'),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),)),
                        ],
                      ),

                    ],
                  ),);
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ChatCard(data);
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.messages.where('users',arrayContains: _service.user?.uid).where('product.seller',isNotEqualTo: _service.user?.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
                }
                if (_loading) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
                }

                if(userdoc['name']==''||userdoc['mobile']==''||userdoc['email']==''){
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Complete your profile and start a chat',style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        Navigator.push (
                          context,
                          MaterialPageRoute (
                            builder: (BuildContext context) => AccountScreen(_service.user!.uid),
                          ),
                        );
                      }, child: Text('Go to profile'),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),)),
                    ],
                  ),);
                }

                if(snapshot.data?.docs.length==0){
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('No foods collected yet',style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        Navigator.pushReplacementNamed(context, MainScreen.id);
                      }, child: Text('Collect Food'),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),)),
                    ],
                  ),);
                }


                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ChatCard(data);
                  }).toList(),
                );
              },
            ),

          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.messages.where('users',arrayContains: _service.user?.uid).where('product.seller',isEqualTo: _service.user?.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
                }

                if (_loading) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
                }

                if(userdoc['name']==''||userdoc['mobile']==''||userdoc['email']==''){
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Complete your profile and start a chat',style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        Navigator.push (
                          context,
                          MaterialPageRoute (
                            builder: (BuildContext context) => AccountScreen(_service.user!.uid),
                          ),
                        );
                      }, child: Text('Go to profile'),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),)),
                    ],
                  ),);
                }

                if(snapshot.data?.docs.length==0){
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('No Donations given yet',style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        showBottomSheet(context);

                      }, child: Text('Add Food'),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),)),
                    ],
                  ),);
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ChatCard(data);
                  }).toList(),
                );
              },
            ),
          )
        ])
      ),
    );
  }
}
