import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GroupChattingScreen extends StatefulWidget {
  const GroupChattingScreen({super.key , required this.name  ,required this.image});

  final String name;
  final image;

  @override
  State<GroupChattingScreen> createState() => _GroupChattingScreen();
}

class _GroupChattingScreen extends State<GroupChattingScreen> {
  List<ChatMessage> messages = [];
  final TextEditingController _textEditingController = TextEditingController();

  String filePath = "";
  void _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
      });
    }
  }


  void _sendMessage() {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      messages.insert(0, ChatMessage(text: messageText));
      _textEditingController.clear();
      setState(() {});
    }
  }

  File? SelectedImage;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(onPressed: (){
              setState(() {
                Navigator.pop(context);
              });
            }, icon: Icon(Icons.arrow_back , color: Colors.amber,)),
            title:Row(
              children: [
                CircleAvatar(
                  radius: 18.0,
                  backgroundImage: widget.image,
                ),
                SizedBox(width: 10,),
                Text(widget.name, style: TextStyle(color: Colors.amber , fontSize: 20 , fontWeight: FontWeight.bold )),
              ],
            ),
            actions: [
              // IconButton(onPressed: (){
              //
              // }, icon: Icon(Icons.more_vert , color: Colors.amber,size: 30,))

              PopupMenuButton(
                  icon: Icon(Icons.more_vert , color: Colors.amber,size: 30,),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.amber)
                  ),
                  color: Colors.black54,
                  itemBuilder: (BuildContext context){
                    return <PopupMenuEntry>[
                      PopupMenuItem(child: ListTile(
                        title: Text('Add Member' , style: TextStyle(color: Colors.amber),),
                        onTap: (){},
                      )),
                      PopupMenuItem(child: ListTile(
                        title: Text('Remove Member',style: TextStyle(color: Colors.amber)),
                        onTap: (){},
                      )),
                      PopupMenuItem(child: ListTile(
                        title: Text('Add Group Admin',style: TextStyle(color: Colors.amber)),
                        onTap: (){},
                      )),
                      PopupMenuItem(child: ListTile(
                        title: Text('Delete Group ',style: TextStyle(color: Colors.amber)),
                        onTap: (){},
                      )),
                    ];
                  })
            ],
            elevation: 10,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueGrey,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true, // Reverse the list
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5, // Max width 50% of screen
                              minWidth: 0, // Allow minimum width
                            ),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(message.text, style: TextStyle(fontSize: 17 , color: Colors.white,fontWeight: FontWeight.bold),)),
                        leading: message.file != null ? Icon(Icons.attach_file) : null,
                        onTap: () {
                          // Handle file tap if needed
                        },
                      );
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.emoji_emotions_rounded, color: Colors.amber),
                            ),
                            IconButton(
                              onPressed: _pickDocument,
                              icon: Icon(Icons.attach_file_sharp, color: Colors.amber),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.multiline,
                                maxLines: null, // Allows multiple lines
                                decoration: InputDecoration(
                                  hintText: 'Text Now...',
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white, fontSize: 17),
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                            IconButton(
                              onPressed: imagePickerCamera,
                              icon: Icon(Icons.camera_alt_sharp, color: Colors.amber),
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Icons.mic, color: Colors.amber)),
                            IconButton(
                              onPressed: _sendMessage,
                              icon: Icon(Icons.send, color: Colors.amber),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }
  Future imagePickerCamera()async{
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        sourcePath: returnedImage!.path
    );
    if(returnedImage == null)return;
    setState(() {
      SelectedImage = File(croppedFile!.path);
      Navigator.of(context).pop();

    });
  }
}


class ChatMessage {
  final String text;
  final File? file;

  ChatMessage({required this.text, this.file});
}
