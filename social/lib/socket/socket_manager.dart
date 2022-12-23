import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:social/utils/holder.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';
import 'package:uuid/uuid.dart';

class SocketManager {
  static const _emulatorBaseUrl = 'https://10.0.2.2:5001/';
  static const _localhostBaseUrl = 'https://localhost:5001/';
  static const _serverBaseUrl = 'https://37.148.213.160:5001/';

  static const _baseUrl = _emulatorBaseUrl;

  HubConnection buildSocketConnection() {
    return HubConnectionBuilder()
    .withUrl("${_baseUrl}chatHub")
    .withHubProtocol(MessagePackHubProtocol())
    .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 20000])
    .build();
  }

  

  Map<String,dynamic> createChatMessage(String message, int roomId) {
    String? firstName;
    String? lastName;
    if(Holder.name?.contains(' ') ?? false){
      var names = Holder.name!.split(' ');
      if(names.length >= 2){
        firstName = names[0];
        lastName = names.skip(1).join(' ');
      }
    }
    else{
      firstName = Holder.name ?? Holder.userName;
    }
    Map<String, dynamic> author = {
      "id": Holder.userId.toString(),
      "firstName": firstName,
      "lastName": lastName
    };

    Map<String, dynamic> chatMessage = {
      "author": author,
      "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
      "id": roomId.toString(),
      "status": 'seen',
      "text": message,
      "type": 'text'
    };

    return chatMessage;

    // var textMessage = Message.fromJson(chatMessage);

    // return textMessage;
  }
}
