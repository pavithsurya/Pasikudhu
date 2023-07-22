import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:pasikuthu/services/firebase_services.dart';
import 'package:intl/intl.dart';

import '../../../model/popup_menu_model.dart';
import 'chat_conversation_screen.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;


  ChatCard(this.chatData);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool temp = false;
  bool temp1 = false;
  bool exists = false;
  FirebaseService _service = FirebaseService();
  CustomPopupMenuController _controller = CustomPopupMenuController();
  late DocumentSnapshot doc;
  late DocumentSnapshot profiledoc;

  @override
  void initState() {
    // TODO: implement initState
    getProductDetails();
    widget.chatData['users'][0]!=_service.user?.uid?getprofiledoc(widget.chatData['users'][0]):getprofiledoc(widget.chatData['users'][1]);
    super.initState();
  }
  getProductDetails(){
    _service.getProductDetails(widget.chatData['product']['productId']).then((value){
      setState(() {
        doc = value;
        temp  =true;

      });
    });
  }
  getprofiledoc(uid){
    _service.getSellerData(uid).then((value){
      setState(() {
        profiledoc = value;
        temp1 = true;
      });
    });
  }

  late List<PopupMenuModel> menuItems = [
  PopupMenuModel('Delete Chat', Icons.delete),
  PopupMenuModel('Mark as Done', Icons.done_all),
  ];


  @override
  Widget build(BuildContext context) {
    String lastChatDate;
    var _date = DateFormat().add_yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));
    var _today = DateFormat().add_yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));
    if(_date==_today){
      lastChatDate = DateFormat('hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));
    }else{
      lastChatDate = _date.toString();
    }
    return temp?temp1? Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        child: ListTile(
          onTap: (){
            if(widget.chatData['lastSentBy']!=_service.user?.uid){
              _service.messages.doc(widget.chatData['chatRoomId']).update({
                'read':true
              });
            }
            Navigator.push (
              context,
              MaterialPageRoute (
                builder: (BuildContext context) => ChatConversations(chatRoomId: widget.chatData['chatRoomId'],name: profiledoc['name'],number: profiledoc['mobile'],),
              ),
            );
          },

          leading: profiledoc['image']==''?AspectRatio(aspectRatio:60/60,child: Container(decoration: BoxDecoration(shape:BoxShape.circle,image: DecorationImage(fit:BoxFit.cover,
              alignment:FractionalOffset.topCenter,image: NetworkImage(widget.chatData['product']['productImage']))),)):
          AspectRatio(aspectRatio:60/60,child: Container(decoration: BoxDecoration(shape:BoxShape.circle,image: DecorationImage(fit:BoxFit.cover,
              alignment:FractionalOffset.topCenter,image: NetworkImage(profiledoc['image']))),)),
          title: Row(
            children: [
              Text(profiledoc['name']+" "),
              Text(' ('+widget.chatData['product']['Item']+')',style: TextStyle(color: Colors.grey),),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.chatData['lastChat']!=null)
              Row(
                children: [
                  Text(widget.chatData['lastChat'].length>24?widget.chatData['lastChat'].substring(0,25)+"...":widget.chatData['lastChat'],maxLines: 1,style: TextStyle(color:widget.chatData['read']==false?widget.chatData['lastSentBy']!=_service.user?.uid?Colors.black:Colors.grey:Colors.grey,fontWeight: widget.chatData['lastSentBy']!=_service.user?.uid?widget.chatData['read']?FontWeight.normal: FontWeight.bold:FontWeight.normal),),
                  Text(widget.chatData['read']==false?widget.chatData['lastSentBy']!=_service.user?.uid?'   •':'':'',style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
          trailing:Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(child:
                Text(lastChatDate,maxLines: 1,style: TextStyle(fontSize: 12),),),
              ),
              CustomPopupMenu(
                child: Container(
                  child: Icon(Icons.more_horiz, color: Colors.black),
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
                                  _service.deleteChat(widget.chatData['chatRoomId']);
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
          )
        ),
      ),
    ):Container():Container();
  }
}
