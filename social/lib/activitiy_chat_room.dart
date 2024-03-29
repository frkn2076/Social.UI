import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/http/api.dart';
import 'package:social/socket/socket_manager.dart';
import 'package:social/utils/holder.dart';
import 'package:uuid/uuid.dart';

class ActivityChatRoom extends StatelessWidget {
  final int id;
  final String activity;
  const ActivityChatRoom({Key? key, required this.id, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: Text(activity),
        centerTitle: true,
      ),
      body: MyStatefulWidget(id: id),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final int id;
  const MyStatefulWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<types.Message> _messages = [];
  final _user = types.User(id: Holder.userId.toString());
  final _hubConnection = SocketManager.createHubConnection();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _joinChatGroup();
    });

    _hubConnection.on("GroupSendMessage", (arguments) {
      var args = (arguments as List).cast<String>().map((e) => e);
      var messages = args.map((e) {
        var decoded = jsonDecode(e);
        decoded["createdAt"] = int.parse(
            decoded["createdAt"]); //fix for long datatype on json issue
        return types.Message.fromJson(decoded);
      }).toList();
      setState(() {
        for (var message in messages) {
          _messages.insert(0, message);
        }
      });
    });
    _loadMessages();
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: _messages,
      // onAttachmentPressed: _handleAttachmentPressed,
      onMessageTap: _handleMessageTap,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: _handleSendPressed,
      showUserAvatars: true,
      showUserNames: true,
      user: _user,
    );
  }

  void _addMessage(types.Message message) async {
    setState(() {
      _messages.insert(0, message);
    });
  }

  // ignore: unused_element
  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      // _sendPhotoMessage(
      //     image.height, image.width, bytes.length, result.path, result.name);
      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    await _sendTextMessage(message.text);
    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final result = await Api().getRoomMessages(widget.id);
    if (result.isSuccessful == true) {
      final messages = (jsonDecode(result.response!) as List)
          .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        _messages = messages;
      });
    }
  }

  Future _sendTextMessage(String message) async {
    var messageToPublish =
        SocketManager().createChatTextMessage(message, widget.id);
    await _sendDataOverSocket(json.encode(messageToPublish));
  }

  Future _joinChatGroup() async {
    await SocketManager.startConnectionIfNotOpen(_hubConnection);
    await _hubConnection
        .invoke("JoinGroup", args: <Object>[widget.id.toString()]);
  }

  Future _sendDataOverSocket(String message) async {
    await SocketManager.startConnectionIfNotOpen(_hubConnection);
    await _hubConnection.invoke("GroupSendMessage", args: <Object>[message]);
  }
}
