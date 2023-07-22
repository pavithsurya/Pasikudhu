import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/firebase_services.dart';

class ChatStream extends StatefulWidget {
  final String chatRoomId;


  ChatStream(this.chatRoomId);

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {

  bool temp = true;
  bool _load = true;
  late Stream<QuerySnapshot> chatMessageStream;
  late DocumentSnapshot chatDoc;  FirebaseService _service = FirebaseService();

  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream =value;
        _load = false;
      });
    });
    _service.messages.doc(widget.chatRoomId).get().then((value) {
      setState(() {
        chatDoc = value;
        temp = false;
      });
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return _load==false?StreamBuilder<QuerySnapshot>(

      stream: chatMessageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
        }
        if(_load){
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),);
        }

        return snapshot.hasData?Column(
          children: [
            temp ? Center(child: LinearProgressIndicator(color: Theme.of(context).primaryColor,),):
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(aspectRatio:60/60,child: Container(decoration: BoxDecoration(shape:BoxShape.circle,image: DecorationImage(fit:BoxFit.cover,
        alignment:FractionalOffset.topCenter,image: NetworkImage(chatDoc['product']['productImage']))),)),
              ),
              title: Text(chatDoc['product']['Item'],style: TextStyle(fontWeight: FontWeight.bold,),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Text('₹ '+chatDoc['product']['price']),
                  SizedBox(width: 20,)
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey.shade300,
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context,index){
                    String sentBy = snapshot.data?.docs[index]['sentBy'];
                    String me = _service.user!.uid;
                    String lastChatDate;
                    var _date = DateFormat().add_yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(snapshot.data?.docs[index]['time']));
                    var _today = DateFormat().add_yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));
                    if(_date==_today){
                      lastChatDate = DateFormat('hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(snapshot.data?.docs[index]['time']));
                    }else{
                      lastChatDate = _date.toString();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8,),
                      child: Column(
                        children: [
                          BubbleSpecialThree(
                            text: snapshot.data?.docs[index]['message'],
                            color: sentBy == me? Theme.of(context).primaryColor:Colors.white,
                            isSender: sentBy == me,
                            tail: true,
                            textStyle: TextStyle(
                                color: sentBy == me?Colors.white:Colors.black,
                                fontSize: 16
                            ),
                          ),
                          Align(
                            alignment: sentBy==me?Alignment.centerRight:Alignment.centerLeft,
                              child: Padding(
                                padding: sentBy==me?EdgeInsets.only(right: 20):EdgeInsets.only(left: 20),
                                child: Text(lastChatDate,style: TextStyle(fontSize: 10),),
                              ))
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ):Container();

      },
    ):Container();
  }
}
