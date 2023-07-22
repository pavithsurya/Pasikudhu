import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/popup_menu_model.dart';
import 'chat_stream.dart';

class ChatConversations extends StatefulWidget {
  final String chatRoomId;
  final String name;
  final String number;


  ChatConversations({required this.chatRoomId, required this.name, required this.number});

  @override
  State<ChatConversations> createState() => _ChatConversationsState();
}

class _ChatConversationsState extends State<ChatConversations> {
  bool _send = false;
  late Stream<QuerySnapshot> chatMessageStream;
  CustomPopupMenuController _controller = CustomPopupMenuController();
  FirebaseService _service = FirebaseService();
  var chatMessageController = TextEditingController();
  sendMessage(){
    if(chatMessageController.text.isNotEmpty){
      FocusScope.of(context).unfocus();
      Map<String,dynamic> message ={
      'message' : chatMessageController.text  ,
        'sentBy': _service.user!.uid,
        'time' : DateTime.now().microsecondsSinceEpoch
    };
      _service.createChat(widget.chatRoomId, message);
      chatMessageController.clear();
    }
  }
  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream =value;
      });
    });

    super.initState();
  }

  _callSeller(String number){
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    launchUrl(launchUri);
  }

  late List<PopupMenuModel> menuItems = [
    PopupMenuModel('Delete Chat', Icons.delete),
    PopupMenuModel('Mark as Done', Icons.done_all),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            _callSeller(widget.number);

          }, icon: Icon(Icons.call)),
          CustomPopupMenu(
            child: Container(
              child: Icon(Icons.more_vert,),
            ),
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: const Color(0xFF4C4C4C),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menuItems
                        .map(
                          (item) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if(item.title=='Delete Chat'){
                            _service.deleteChat(widget.chatRoomId);
                            _controller.hideMenu();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Chat Deleted'))
                            );
                          }
                        },
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                item.icon,
                                size: 15,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding:
                                  EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
          ChatStream(widget.chatRoomId),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade800,
                    )
                  )
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    Expanded(child: SizedBox(
                      height: 60,
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          TextField(
                            onChanged: (value){
                              if(value.isNotEmpty){
                                setState(() {
                                  _send = true;
                                });
                              }
                              else{
                                setState(() {
                                  _send = false;
                                });
                              }
                            },
                            onSubmitted: (value){
                              if(value.length>0){
                                sendMessage();
                              }
                            },
                            controller: chatMessageController,
                            style: TextStyle(fontSize: 17),
                            decoration: InputDecoration(
                              hintText: 'Type Message',
                              //hintStyle: TextStyle(color: Colors.red.shade900),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                      
                    ),),
                    Visibility(
                      visible: _send,
                      child: IconButton(onPressed: (){
                          sendMessage();
                      }, icon: Icon(Icons.send,color: Theme.of(context).primaryColor,) ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
