
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
/*
* 输入框
* */
class MessageInputBar extends StatefulWidget {

  final  Function(String) onSendPressed;
  final  Function(String) onImageSendPressed;

  MessageInputBar({
    super.key,
    required this.onSendPressed,
    required this.onImageSendPressed
  });

  @override
  State<StatefulWidget> createState() {
    return _MessageInputBarState();
  }


}

class _MessageInputBarState extends State<MessageInputBar> {
  var messageInputTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  var _isGalleryVisible = false;
  bool _sendButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _handleSendButtonVisibilityModeChange();
    _focusNode.addListener(() {

      if(_focusNode.hasFocus) {
        setState(() {
          _isGalleryVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    messageInputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF8F8F8),
      child:
        Column(
          children: [
            _buildMessageInputBar(),
            if(_isGalleryVisible) _buildMorePage()

          ],
        )

    );

  }

  void _handleSendButtonVisibilityModeChange() {
    messageInputTextController.removeListener(_handleTextControllerChange);
    _sendButtonVisible = messageInputTextController.text.trim() != '';
    messageInputTextController.addListener(_handleTextControllerChange);
  }
  void _handleTextControllerChange() {
    print('_handleTextControllerChange');
    setState(() {
      _sendButtonVisible = messageInputTextController.text.trim() != '';
      if(_sendButtonVisible) {
        _isGalleryVisible = false;
      }
    });
  }

  void _handleSendPressed() {
    final trimmedText = messageInputTextController.text.trim();
    if (trimmedText != '') {
      widget.onSendPressed(trimmedText);

      messageInputTextController.clear();

    }
  }


    Widget _buildMessageInputBar() {
    return Padding(

      padding: const EdgeInsets.only(top: 6, left: 8, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildVoiceMessageButton(),
          Flexible(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: messageInputTextController,
                focusNode: _focusNode,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 16, color: Colors.black),
                minLines: 1,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
                  contentPadding: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 0, top: 0),
                ),
              ),
            ),
          ),
          _buildMediaMessageButton(),
          _buildSendButton(),

        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),

      child: !_sendButtonVisible
          ? _buildMoreButton()
          : IconButton(
        color: Colors.black,
        icon: Icon(Icons.send),
        onPressed:_handleSendPressed,
      ),
    );
  }

  Widget _buildMediaMessageButton() {
    return IconButton(
      color: Colors.black,
      icon: Icon(Icons.add_photo_alternate_outlined),
      onPressed:_onGalleryPickerPressed,
    );
  }

  Widget _buildVoiceMessageButton() {
    return IconButton(
      color: Colors.black,
      icon: Icon(Icons.keyboard_voice),
      onPressed: () {

      },
    );
  }

  Widget _buildMoreButton() {

    return AnimatedRotation(
      turns: _isGalleryVisible ? pi  : 0,
      duration: const Duration(milliseconds: 100),
      child:  IconButton(
        color: Colors.black,
        icon: Icon(Icons.add_circle_outline),
        onPressed: () {

          _focusNode.unfocus();
          setState(() {
            _isGalleryVisible = !_isGalleryVisible;
          });

        },
      ),
    );

  }

  Widget _buildMorePage() {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      padding: const EdgeInsets.only(top: 30),
      color: Colors.white,
      height: 200,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 20,
        childAspectRatio: 1,
        children: [

          TextButton(
            child: Column(
              children: [
                Icon(Icons.add_photo_alternate_outlined, color: Colors.black,),
                SizedBox(height: 12,),
                Text("Photo", style: TextStyle(fontSize: 11, color: Colors
                    .black45),)
              ],
            ),
            onPressed: _onGalleryPickerPressed,
          ),
          TextButton(
            child: Column(
              children: [
                Icon(Icons.camera_alt_outlined, color: Colors.black,),
                SizedBox(height: 12,),
                Text("Shot", style: TextStyle(fontSize: 11, color: Colors
                    .black45),)
              ],
            ),
            onPressed: _onCameraPickerPressed,
          ),

        ],
      ),
    );
  }

  void _onGalleryPickerPressed() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    String? path = image?.path;

    print("imagePath = $path");
    if(path != null) {

      widget.onImageSendPressed(path);
    }
  }

  void _onCameraPickerPressed() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    String? path = image?.path;

    print("imagePath = $path");
    if(path != null) {

      widget.onImageSendPressed(path);
    }
  }
}
