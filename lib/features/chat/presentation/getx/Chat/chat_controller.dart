import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_last_message_and_count_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/conversation_with_count_and_last_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/block_unblock_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/delete_conversation.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/get_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/send_message.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/start_conversation_with.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/synchronize_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_all_conversations.dart';
import 'package:ashghal_app_frontend/features/chat/domain/use_cases/watch_conversations_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/dependency_injection.dart'
    as di;
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxList<ConversationWithCountAndLastMessage> conversations =
      <ConversationWithCountAndLastMessage>[].obs;
  RxBool isLoaing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToConversations();
    _listenToConversationsLastMessageAndCount();
    _syncronizeConversations();
  }

  Future<void> _syncronizeConversations() async {
    //  _listenToConversations();
    //   _listenToConversationsLastMessageAndCount();
    // GetAllConversationsUseCase getAllConversations = di.getIt();
    // var result = await getAllConversations.call();
    // result.fold((l) => null, (conversations) {
    //   for (var conversation in conversations) {
    //     _insertOrReplaceLocalConversation(conversation);
    //   }
    // });
    SynchronizeConversations synchronizeConversations = di.getIt();
    synchronizeConversations.call();
    // SynchronizeConversations synchronizeConversations = di.getIt();
    // synchronizeConversations.call().then((value) {
    //   //after syncronizing start listeners
    //   _listenToConversations();
    //   _listenToConversationsLastMessageAndCount();
    // });
  }

  void _listenToConversations() {
    WatchAllConversations watchAllConversations = di.getIt();
    watchAllConversations.call().listen((localConversations) {
      print("Listener got updates");
      for (var localConversation in localConversations) {
        // print(localConversation.toString());
        print("Listner Data :$localConversation");
        _insertOrReplaceLocalConversation(localConversation);
      }
    });
  }

  void _insertOrReplaceLocalConversation(LocalConversation conversation) {
    int index = conversations.indexWhere(
        (element) => element.conversation.localId == conversation.localId);
    if (index == -1) {
      conversations.add(ConversationWithCountAndLastMessage(
        conversation: conversation,
      ));
    } else {
      conversations[index] = conversations[index].copyWith(
        conversation: conversation,
      );
    }
  }

  void _listenToConversationsLastMessageAndCount() {
    WatchConversationsLastMessageAndCount watchConversationLastMessageAndCount =
        di.getIt();
    watchConversationLastMessageAndCount().listen((lastMessagesAndCounts) {
      for (var lastMessageAndCount in lastMessagesAndCounts) {
        _insertOrReplaceConversationLastMessageAndCount(
            lastMessageAndCount as ConversationLastMessageAndCountModel);
      }
    });
  }

  void _insertOrReplaceConversationLastMessageAndCount(
      ConversationLastMessageAndCountModel message) {
    int index = conversations.indexWhere((element) =>
        element.conversation.localId == message.lastMessage.conversationId);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(
        lastMessage: message.lastMessage,
        newMessagesCount: message.newMessagesCount,
      );
    } else {}
  }

  Future<void> startConversationWith(int userId) async {
    StartConversationRequest request = StartConversationRequest(userId: userId);
    StartConversationWith startConversationWith = di.getIt();
    (await startConversationWith(request)).fold(
      (failure) {},
      (r) => null,
    );
  }

  Future<void> deleteConversation(int conversationId) async {
    DeleteConversationRequest request = DeleteConversationRequest(
      conversationLocalId: conversationId,
    );
    DeleteConversationUseCase deleteConversationUseCase = di.getIt();
    (await deleteConversationUseCase(request)).fold(
      (failure) => {},
      (success) {
        if (success) {
          conversations.removeWhere(
            (element) => element.conversation.localId == conversationId,
          );
          // int index = conversations.indexWhere(
          //   (element) => element.conversation.localId == conversationId,
          // );
          // if (index != -1) {

          // }
        }
      },
    );
  }
}
