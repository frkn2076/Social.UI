import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:social/utils/holder.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';

class SocketManager {
  static const _emulatorBaseUrl = 'https://10.0.2.2:5001/';
  static const _localhostBaseUrl = 'https://localhost:5001/';
  static const _serverBaseUrl = 'https://37.148.213.160:5001/';

  static const _baseUrl = _serverBaseUrl;

  static HubConnection createHubConnection(){
    return HubConnectionBuilder()
      .withUrl("${_baseUrl}chatHub")
      .withHubProtocol(MessagePackHubProtocol())
      .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 20000]).build();
  }

  static Future startConnectionIfNotOpen(HubConnection hubConnection) async {
    if(hubConnection.state == HubConnectionState.Disconnected) {
      await hubConnection.start();
    }
  }

  // static void onError() {
  //   hubConnection.onclose(({error}) {
  //     hubConnection = HubConnectionBuilder()
  //         .withUrl("${_baseUrl}chatHub")
  //         .withHubProtocol(MessagePackHubProtocol())
  //         .withAutomaticReconnect(
  //             retryDelays: [2000, 5000, 10000, 20000]).build();
  //     hubConnection.start();
  //   });
  // }

  Map<String, dynamic> createChatTextMessage(String message, int activityId) {
    String? firstName;
    String? lastName;
    if (Holder.name?.contains(' ') ?? false) {
      var names = Holder.name!.split(' ');
      if (names.length >= 2) {
        firstName = names[0];
        lastName = names.skip(1).join(' ');
      }
    } else {
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
      "id": activityId.toString(),
      "status": 'seen',
      "text": message,
      "type": 'text'
    };

    return chatMessage;
  }

  Map<String, dynamic> createChatPhotoMessage(int height, int width, int size,
      String uri, String name, int activityId) {
    String? firstName;
    String? lastName;
    if (Holder.name?.contains(' ') ?? false) {
      var names = Holder.name!.split(' ');
      if (names.length >= 2) {
        firstName = names[0];
        lastName = names.skip(1).join(' ');
      }
    } else {
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
      "id": activityId.toString(),
      "status": 'seen',
      "type": 'image',
      "height": height,
      "width": width,
      "size": size,
      "uri": uri,
      "name": name
    };

    return chatMessage;
  }
}
