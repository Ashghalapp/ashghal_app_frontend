import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';

class ConversationWithCountAndLastMessage {
  LocalConversation conversation;
  int newMessagesCount;
  LocalMessage? lastMessage;
  bool isActive; //defualt false and it will be updated by real time channels
  DateTime?
      lastSeen; //Handle last seen as request when the user connects to the internet and update it according to real time updates

  ConversationWithCountAndLastMessage({
    required this.conversation,
    this.newMessagesCount = 0,
    this.lastMessage,
    this.isActive = true,
    this.lastSeen,
  });

  // factory ConversationWithCountAndLastMessage.fromJson(
  //     Map<String, dynamic> json) {
  //   return ConversationWithCountAndLastMessage(
  //     id: json['id'],
  //     userId: json['user_id'],
  //     createdAt: DateTime.parse(json['created_at']),
  //     newMessagesCount: json['new_messages_count'] ?? 0,
  //     lastMessage: json['last_message'] != null
  //         ? LocalMessage.fromJson(json['last_message'])
  //         : null,
  //   );
  // }

  // static List<ConversationWithCountAndLastMessage> fromLocalJsonList(
  //     List<Map<String, dynamic>> jsonList) {
  //   return jsonList
  //       .map<ConversationWithCountAndLastMessage>(
  //           (json) => ConversationWithCountAndLastMessage.fromJson(json))
  //       .toList();
  // }

  // @override
  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> json = {
  //     ...super.toJson(), // Include the base class (Conversation) properties
  //     'new_messages_count': newMessagesCount,
  //   };
  //   if (lastMessage != null) {
  //     json['last_message'] = lastMessage!.toJson();
  //   }
  //   return json;
  // }

  // @override
  // String toString() {
  //   return 'LocalConversation(id: $id, userId: $userId, createdAt: $createdAt, newMessagesCount: $newMessagesCount, lastMessage: $lastMessage)';
  // }

  ConversationWithCountAndLastMessage copyWith({
    LocalConversation? conversation,
    int? newMessagesCount,
    LocalMessage? lastMessage,
    bool? isActive,
    DateTime? lastSeen,
  }) {
    return ConversationWithCountAndLastMessage(
      conversation: conversation ?? this.conversation,
      newMessagesCount: newMessagesCount ?? this.newMessagesCount,
      lastMessage: lastMessage ?? this.lastMessage,
      isActive: isActive ?? this.isActive,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
