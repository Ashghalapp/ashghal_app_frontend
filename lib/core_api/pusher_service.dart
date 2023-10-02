// PUSHER_APP_ID=1673626
// PUSHER_APP_KEY=481dbd40382f1648677d
// PUSHER_APP_SECRET=269840bcfd53348fe26b
// PUSHER_HOST=
// PUSHER_PORT=443
// PUSHER_SCHEME=https
// PUSHER_APP_CLUSTER=ap2
// import 'package:pusher_channels/pusher_channels.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherConfig {
  static String apiKey = "481dbd40382f1648677d";
  static String apiCluster = "ap2";
}

class PusherService {
  PusherChannelsFlutter? pusher;
  static List<Channelhandler> channelsHandlers = [];
  static PusherService? _instance;
  final DioService _dioService = DioService();

  PusherService._();

  factory PusherService() {
    _instance ??= PusherService._(); // Initialize if null
    return _instance!;
  }

  Future<void> initialize() async {
    pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher!.init(
          apiKey: PusherConfig.apiKey,
          cluster: PusherConfig.apiCluster,
          useTLS: true,
          // onConnectionStateChange: (),
          // onError: onError,
          // onSubscriptionSucceeded: onSubscriptionSucceeded,  //use this if you want to be informed of when a channel has successfully been subscribed to, which is useful if you want to perform actions that are only relevant after a subscription has succeeded. For example querying the members for presence channel.
          onEvent:
              onEvent, //Called when a event is received by the client. The global event handler will trigger on events from any channel.
          // authEndpoint: ,  //The authEndpoint provides a URL that the Pusher client will call to authorize users for a presence channel.
          // onSubscriptionError: onSubscriptionError,  //use this if you want to be informed of a failed subscription attempt, which you could use, for example, to then attempt another subscription or make a call to a service you use to track errors.
          // onDecryptionFailure: onDecryptionFailure,  //only used with private encrypted channels - use this if you want to be notified if any messages fail to decrypt.
          // onMemberAdded: onMemberAdded,
          // onMemberRemoved: onMemberRemoved,
          authEndpoint: "http://10.0.2.2/api/broadcasting/auth",
          onAuthorizer: onAuthorizer,
          authParams: {
            //The authEndpoint provides a URL that the Pusher client will call to authorize users for a presence channel. On how to implement an authorization service please check here: https://pusher.com/docs/channels/server_api/authenticating-users/
            'params': {'foo': 'bar'}, //Query parameters  (AJAX only).
            'headers': {'baz': 'boo'} //Headers parameters (AJAX only).
          });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  dynamic _authResponse;
  Future<void> initializePusher() async {
    await initialize();
    await connect();
  }

  Future<void> connect() async {
    if (pusher != null) {
      await pusher!.connect();
    }
  }

  Future<void> disconnect() async {
    if (pusher != null) {
      await pusher!.disconnect();
    }
  }

  Future<void> subscribeToPublicChannel(
      String channelName, Channelhandler handler) async {
    if (pusher != null) {
      Channelhandler? h = channelsHandlers.firstWhereOrNull((element) =>
          element.channel.channelName == handler.channel.channelName &&
          element.channel.eventName == handler.channel.eventName);
      if (h == null) {
        channelsHandlers.add(handler);
      }
      final channel = await pusher!.subscribe(
        channelName: channelName,
        // onEvent: (event) {
        // },
      );
    }
  }

  void addNewChannelHandler(Channelhandler handler) {
    Channelhandler? h = channelsHandlers.firstWhereOrNull((element) =>
        element.channel.channelName == handler.channel.channelName &&
        element.channel.eventName == handler.channel.eventName);
    if (h == null) {
      channelsHandlers.add(handler);
    }
  }

  Future<void> subscribeToChannel(String channelName) async {
    if (pusher != null) {
      final myPrivateChannel =
          await pusher!.subscribe(channelName: channelName);
    }
  }

  Future<void> subscribeToPresenceChannel(
      String channelName, Channelhandler handler) async {
    if (pusher != null) {
      addNewChannelHandler(handler);
      final myPrivateChannel = await pusher!.subscribe(
        channelName: handler.channel.channelName,
      );
    }
  }

  Map<String, dynamic> fromjson(Map<String, dynamic> data) {
    return {
      "channelName": data['channelName'] ?? "",
      "eventName": data['eventName'] ?? "",
    };
  }

  Future<void> unsubscribeFromChannel(String channelName) async {
    if (pusher != null) {
      await pusher!.unsubscribe(channelName: channelName);
    }
  }

  Future<void> onEvent(PusherEvent event) async {
    Channelhandler? handler;
    if (channelsHandlers.isNotEmpty) {
      handler = channelsHandlers.firstWhereOrNull(
        (element) =>
            element.channel.channelName == event.channelName &&
            element.channel.eventName == event.eventName,
      );
    }
    if (handler != null) {
      handler.onEvent(event);
    } else {
      print(
          "///////////////////My Idea Doesn't work/////////////////////////////");
      print("channelName:${event.channelName}");
      print("channelName:${event.eventName}");
      print("event:${event.data}");
      //  RemoteMessageModel message =  RemoteMessageModel.fromJson(event.data);
      //   print(message.name)
      //   Map<String, dynamic> data = event.data as Map<String, dynamic>;
      //   print(data['message']);
    }

    // print()
  }

  /// use this if you want to be informed of when a channel has successfully
  /// been subscribed to, which is useful if you want to perform actions that
  /// are only relevant after a subscription has succeeded.
  ///
  /// For example querying the members for presence channel.
  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("onSubscriptionSucceeded: $channelName data: $data");
  }

  /// use this if you want to be informed of a failed subscription attempt,
  /// which you could use, for example, to then attempt another subscription
  /// or make a call to a service you use to track errors.
  void onSubscriptionError(String message, dynamic e) {
    print("onSubscriptionError: $message Exception: $e");
  }

  /// only used with private encrypted channels
  /// use this if you want to be notified if any messages fail to decrypt.
  void onDecryptionFailure(String event, String reason) {
    print("onDecryptionFailure: $event reason: $reason");
  }

  /// Called when a member is added to the presence channel.
  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName member: $member");
  }

  /// Called when a member is removed to the presence channel.
  void onMemberRemoved(String channelName, PusherMember member) {
    print("onMemberRemoved: $channelName member: $member");
  }

  /// When passing the onAuthorizer() callback to the init() method,
  /// this callback is called to request auth information.
  /// For more information on how to generate the correct information, please
  /// look here: https://pusher.com/docs/channels/library_auth_reference/auth-signatures/
  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    print(
        "onAuthorizer started --------- Socket id:$socketId ------- channelname: $channelName");
    return await _dioService.autherizeUserOnChannel(
      socketId: socketId,
      channelName: channelName,
    );

    // Dio dio = Dio();
    // var response = await dio.post(ApiConstants.channelsAutherizingUrl,
    //     data: {'socket_id': socketId, 'channel_name': channelName},
    //     options: Options(
    //       headers: {
    //         'Authorization': 'Bearer H1yyza0I8r87vRAJXWn3H84EN3SjiEqn3QePFV2q',
    //       },
    //     ));
    // print("?????????????????${response.statusCode}??${response.statusMessage}");
    // print("?????????????????${response.data}??${response.statusMessage}");
    // return response.data;
    // if (response.statusCode == 200) {
    //   var json = jsonDecode(response.data);
    //   return response.data;
    // }

    // String token = await Store.read("token");
    // print("*******************************");
    // print(
    //     "onAuthorizer started --------- Socket id:$socketId ------- channelname: $channelName");
    // print("*******************************");
    // var authUrl = "http://10.0.2.2:8000/api/broadcasting/auth";
    // var result = await http.post(
    //   Uri.parse(authUrl),
    //   headers: {
    //     // 'Content-Type': 'application/x-www-form-urlencoded',
    //     'Authorization': 'Bearer H1yyza0I8r87vRAJXWn3H84EN3SjiEqn3QePFV2q',
    //   },
    //   body: {'socket_id': socketId, 'channel_name': channelName},
    // );
    // print("**************$result*****************");
    // print("*******************************");
    // //  var data = null;
    // // var authorizer = pusherAuthKey.then((pusherAuthKey) {
    // //   data = pusherAuthKey.body;
    // //   // return jsonDecode(data);
    // // });
    // // return authorizer;
    // var json = jsonDecode(result.body);
    // print("------------------------------------");
    // print("${result.body}");
    // print("------------------------------------");
    // return json;
  }

  /// use this if you want to use connection state changes to perform different actions / UI updates The different states that the connection can be in are:
  /// CONNECTING - the connection is about to attempt to be made
  /// CONNECTED - the connection has been successfully made
  /// DISCONNECTING - the connection has been instructed to disconnect and it is just about to do so
  /// DISCONNECTED - the connection has disconnected and no attempt will be made to reconnect automatically
  /// RECONNECTING - an attempt is going to be made to try and re-establish the connection
  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }

  /// use this if you want to be informed of errors received from Pusher Channels e.g. Application is over connection quota. You can find some of the possible errors listed here.
  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }
  // Add methods to subscribe to and unsubscribe from channels
  // Handle events and triggers here
}

class Channelhandler {
  final AppChannel channel;
  final Function(PusherEvent event) onEvent;

  Channelhandler({
    required this.channel,
    required this.onEvent,
  });
}

class AppChannel {
  final String channelName;
  final String eventName;

  AppChannel({
    required this.channelName,
    required this.eventName,
  });
}
// List<Channelhandler> channelsHandlers = [
//   Channelhandler(
//       channelName: 'chat',
//       eventName: 'message.sent',
//       onEvent: ((event) {
//         print("////////////////////My Idea Works////////////////////////////");
//         print("channelName:${event.channelName}");
//         print("channelName:${event.eventName}");
//         print("event:${event.data}");
//         dynamic data = json.decode(event.data);
//         RemoteMessageModel message = RemoteMessageModel.fromJson2(data);
//         // Map<String, dynamic> data = event.data as Map<String, dynamic>;
//         // print(data['message']);
//       }))
// ];
