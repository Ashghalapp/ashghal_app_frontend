import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/block_unblock_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/clear_chat.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/conversation_messages_read.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/download_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/send_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/upload_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversation_messages_multimedia.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:get/get.dart';

class ConversationController extends GetxController {
  RxList<MessageAndMultimediaModel> messages =
      <MessageAndMultimediaModel>[].obs;

  late final int conversationId;
  ConversationController({required this.conversationId});

  RxBool isloading = false.obs;
  // final RemoteMessageService messageService = RemoteMessageService.create();
  // final RemoteMessageConfirmationService confirmationService =
  //     RemoteMessageConfirmationService.create();

  @override
  void onInit() {
    super.onInit();
    // di.setupChatDependencies();

    _markConversationMessagesAsRead();
    // _listenToAllMessages();
    // _listenToMultimedia();
  }

  Future<void> _markConversationMessagesAsRead() async {
    // print("Conversation ID" + conversationId.toString());
    ConversationMessagesReadUseCase conversationMessagesRead = di.getIt();
    conversationMessagesRead.call(conversationId).then((value) {
      _listenToAllMessages();
      _listenToMultimedia();
    });
  }

  void _listenToAllMessages() {
    WatchConversationMessages watchConversationMessages = di.getIt();
    watchConversationMessages(conversationId).listen((localMessages) {
      print(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to messages got updates :${localMessages.length}");
      for (var localMessage in localMessages) {
        _insertOrReplaceMessage(localMessage);
      }
    });
  }

  void _listenToMultimedia() {
    WatchConversationMessagesMultimediaUseCase useCase = di.getIt();
    useCase(conversationId).listen((localMultimedia) {
      print(
          "~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~ Listen to Multimedia got updates :${localMultimedia.length}");
      for (var multimedia in localMultimedia) {
        _insertOrReplaceMultimedia(multimedia);
      }
    });
  }

  void _insertOrReplaceMessage(LocalMessage message) {
    int index = messages
        .indexWhere((element) => element.message.localId == message.localId);
    if (index == -1) {
      messages.add(MessageAndMultimediaModel(message: message));
    } else {
      messages[index] = messages[index].copyWith(message: message);
    }
  }

  void _insertOrReplaceMultimedia(LocalMultimedia multimedia) {
    int index = messages.indexWhere(
        (element) => element.message.localId == multimedia.messageId);
    if (index == -1) {
      // messages.add(MessageAndMultimediaModel(message: message));
    } else {
      print("multimedia added");
      messages[index] = messages[index].copyWith(multimedia: multimedia);
    }
    messages.refresh();
  }

  Future<void> sendTextMessage(String body) async {
    SendMessageRequest request = SendMessageRequest.withBody(
      conversationId: conversationId,
      body: body,
    );
    _sendMessage(request);
  }

  Future<void> sendMultimediaMessage(String path) async {
    SendMessageRequest request = SendMessageRequest.withMultimedia(
      conversationId: conversationId,
      filePath: path,
      onSendProgress: (count, total) {},
      cancelToken: null,
    );
    _sendMessage(request);
  }

  Future<void> sendTextAndMultimediaMessage(String body, String path) async {
    SendMessageRequest request = SendMessageRequest.withBodyAndMultimedia(
      conversationId: conversationId,
      filePath: path,
      body: body,
      onSendProgress: (count, total) {},
      cancelToken: null,
    );
    _sendMessage(request);
  }

  Future<void> _sendMessage(SendMessageRequest request) async {
    // print("Request Sent");
    SendMessageUseCase sendMessageUseCase = di.getIt();
    (await sendMessageUseCase.call(request)).fold(
      (failure) {
        // print("Request Fail${failure.message}");
      },
      (localMessage) {
        // print("request success$localMessage");
      },
    );
    // print("Request Finished");
  }

  Future<bool> download(DownloadRequest request) async {
    print("download Request Sent");
    DownloadMultimediaUseCase useCase = di.getIt();
    return (await useCase.call(request)).fold<bool>(
      (failure) {
        print("download Request Fail ${failure.message}");
        return false;
      },
      (state) {
        print("download request success");
        return state;
      },
    );
    // // print("Request Finished");
  }

  Future<bool> upload(UploadRequest request) async {
    print("upload Request Sent");
    UploadMultimediaUseCase useCase = di.getIt();
    return (await useCase.call(request)).fold<bool>(
      (failure) {
        print("upload Request Fail ${failure.message}");
        return false;
      },
      (state) {
        print("upload request success");
        return state;
      },
    );
    // print("upload Request Finished");
    // return false;
  }

  // Future<void> sendMessage(SendMessageRequest request) async {
  //   // isloading.value = true;
  //   try {
  //     SendMessageUseCase sendMessage = di.getIt();
  //     (await sendMessage(request)).fold(
  //       (r) => null,
  //       (l) {},
  //     );
  //   } catch (e) {
  //     // showErrorDialog(e.toString());
  //   }
  //   // isloading.value = false;
  // }

  Future<void> clearChat() async {
    ClearChatUseCase useCase = di.getIt();
    (await useCase.call(ClearChatRequest(conversationLocalId: conversationId)))
        .fold(
      (failure) {
        //
      },
      (success) {
        messages.clear();
      },
    );
  }

  Future<void> deleteMessages(List<int> messagesIds) async {
    DeleteMessagesUseCase useCase = di.getIt();
    (await useCase.call(DeleteMessagesRequest(messagesIds: messagesIds))).fold(
      (failure) {
        //
      },
      (success) {
        messages.removeWhere(
            (element) => messagesIds.contains(element.message.localId));
      },
    );
  }

  Future<void> blockConversation() async {
    _blockUnblockConversation(
      BlockUnblockConversationRequest(
        conversationId: conversationId,
        block: true,
      ),
    );
  }

  Future<void> unblockConversation() async {
    _blockUnblockConversation(
      BlockUnblockConversationRequest(
        conversationId: conversationId,
        block: false,
      ),
    );
  }

  Future<void> _blockUnblockConversation(
      BlockUnblockConversationRequest request) async {
    BlockUnblockConversationUseCase useCase = di.getIt();
    (await useCase(request)).fold(
      (failure) => {
        //
      },
      (success) {
        if (success) {
          //
        }
      },
    );
  }

  @override
  void onClose() {
    // textEditingController.dispose();
    super.onClose();
  }
}