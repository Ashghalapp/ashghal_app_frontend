import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/tables/chat_tables.dart';
import 'package:moor_flutter/moor_flutter.dart';
// import 'package:moor/moor.dart';

part 'conversation_local_source.g.dart';

// class ConversationWithNewMessagesAndLastMessage {
//   final Conversations conversation;
//   final int newMessageCount;
//   final Messages? lastMessage;

//   ConversationWithNewMessagesAndLastMessage({
//     required this.conversation,
//     required this.newMessageCount,
//     this.lastMessage,
//   });
// }

@UseDao(tables: [Conversations, Messages])
class ConversationLocalSource extends DatabaseAccessor<ChatDatabase>
    with _$ConversationLocalSourceMixin {
  final ChatDatabase db;

  ConversationLocalSource(this.db) : super(db);

  /// Retrieves a list of local conversations from the database, local conversations are conversations created
  /// locally and is not sent yet to the remote server
  ///
  /// Returns a [Future] that resolves to a list of [LocalConversation] objects.
  ///
  /// Use this method to retrieve local conversations from the database.
  ///
  /// Example usage:
  /// ```dart
  /// final database = ChatDatabase(); // Initialize your database instance
  /// final conversationLocalSource = ConversationLocalSource(database);
  ///
  /// final localConversations = await conversationLocalSource.getLocalConversations();
  /// print("Local Conversations: $localConversations");
  /// ```
  Future<List<LocalConversation>> getLocalConversations() async {
    return await (select(db.conversations)
          ..where((c) => c.remoteId.equals(null)))
        .get();
  }

  /// Streams updates to all unblocked local conversations from the local data source.
  ///
  /// Returns a [Stream] that emits a list of [LocalConversation] objects whenever there
  /// is a change in the database. The stream filters out blocked conversations and ensures
  /// that the most recently updated conversations are at the top of the list.
  ///
  /// Use this method to observe updates to unblocked conversations.
  ///
  /// Example usage:
  /// ```dart
  /// final conversationSource = ConversationLocalSource(chatDatabase);
  /// final stream = conversationSource.watchAllConversations();
  ///
  /// stream.listen((conversations) {
  ///   print("Updated Conversations: $conversations");
  /// });
  /// ```
  Stream<List<LocalConversation>> watchAllConversations() async* {
    yield* (select(db.conversations)
          ..where((tbl) => tbl.isBlocked.equals(false))
          ..orderBy(
            [
              (table) => OrderingTerm(
                    expression: table.updatedAt,
                    mode: OrderingMode.desc,
                  )
            ],
          ))
        .watch();
  }

  /// Retrieves a list of local conversations from the localdata source.
  ///
  /// Returns a [Future] that resolves to a list of [LocalConversation] objects.
  ///
  /// Use this method to retrieve a list of local conversations from the database.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = ConversationRepository();
  /// final conversations = await repository.getAllConversations();
  /// print("Conversations: $conversations");
  /// ```
  Future<List<LocalConversation>> getAllConversations() async {
    return await (select(db.conversations)).get();
  }

  /// Updates a conversation in the database based on the provided user ID.
  ///
  /// Returns a [Future] that resolves to the number of rows updated in the database.
  ///
  /// Use this method to update a conversation associated with a specific user.
  ///
  /// - [conversationCompanion]: An [Insertable<LocalConversation>] companion object
  ///   containing the updated conversation data.
  /// - [userId]: The user ID associated with the conversation.
  Future<int> updateConversationWithUserId(
      Insertable<LocalConversation> conversationCompanion, int userId) async {
    return await (update(db.conversations)
          ..where(
            (conversation) => conversation.userId.equals(userId),
          ))
        .write(conversationCompanion);
  }

  /// Initiates a new conversation by inserting a [LocalConversation] into the data source.
  ///
  /// Returns a [Future] that resolves to a boolean `true` if the conversation initiation was successful,
  /// or `false` if it failed. Conversation initiation may fail if a conversation with the same userId
  /// already exists.
  ///
  /// Use this method to start a new conversation by inserting it into the local database.
  ///
  /// Example usage:
  /// ```dart
  /// final localSource = ConversationLocalSource(db);
  /// final newConversation = LocalConversation(
  ///   // Initialize conversation properties
  /// );
  /// final isStarted = await localSource.startConversation(newConversation);
  ///
  /// if (isStarted) {
  ///   print("New conversation started successfully.");
  /// } else {
  ///   print("Failed to start a new conversation.");
  /// }
  /// ```
  /// - [conversation]: An [Insertable] representation of the [LocalConversation] to insert.
  Future<bool> startConversation(
      Insertable<LocalConversation> conversation) async {
    try {
      await into(db.conversations).insert(
          conversation); //maybe there is a conversation wih the same userId
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Refreshes the `updatedAt` timestamp for a conversation in the local database.
  ///
  /// This method takes a [conversationID] and updates the `updatedAt` timestamp
  /// for the corresponding conversation to the current date and time.
  ///
  /// Use this method to update the `updatedAt` timestamp for a specific conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final source = ConversationLocalSource(ChatDatabase());
  /// final conversationID = 123;
  ///
  /// await source.refreshConversationUpdatedAt(conversationID);
  /// ```
  ///
  /// - [conversationID]: The local ID of the conversation to refresh.
  ///
  Future<int> refreshConversationUpdatedAt(int conversationID) async {
    final query = select(db.conversations)
      ..where((c) => c.localId.equals(conversationID));
    LocalConversation conversation = await query.getSingle();
    print("refresh function");
    return await (update(db.conversations)
          ..where((tbl) => tbl.localId.equals(conversationID)))
        .write(
      ConversationsCompanion(updatedAt: Value(DateTime.now())),
    );
  }

  /// Inserts a conversation into the local database.
  ///
  /// This method takes an [Insertable<LocalConversation>] object representing a conversation
  /// and inserts it into the local database.
  ///
  /// Use this method to insert a new conversation into the database.
  ///
  /// Example usage:
  /// ```dart
  /// final source = ConversationLocalSource(ChatDatabase());
  /// final conversationToInsert = // Insertable<LocalConversation> object
  ///
  /// await source.insertConversation(conversationToInsert);
  /// ```
  ///
  /// - [conversation]: An [Insertable<LocalConversation>] object representing the conversation to insert.
  Future<int> insertConversation(
      Insertable<LocalConversation> conversation) async {
    return await into(db.conversations).insert(conversation);
  }

  /// Retrieves a list of remote conversations from the local database.
  ///
  /// This method returns a [Future] that resolves to a list of [LocalConversation] objects
  /// representing conversations where the [remoteId] is not null.
  ///
  /// Use this method to get a list of remote conversations from the database.
  ///
  /// Example usage:
  /// ```dart
  /// final source = ConversationLocalSource(ChatDatabase());
  ///
  /// final remoteConversations = await source.getRemoteConversations();
  /// ```
  Future<List<LocalConversation>> getRemoteConversations() async {
    return await (select(db.conversations)
          ..where((c) => c.remoteId.isNotNull()))
        .get();
  }

  /// Retrieves a local conversation based on the provided [remoteId] and [userId].
  ///
  /// Returns a [Future] that resolves to a [LocalConversation] if a matching conversation is found,
  /// or `null` if no matching conversation exists.
  ///
  /// Use this method to retrieve a specific conversation by its [remoteId] and [userId].
  ///
  /// Example usage:
  /// ```dart
  /// final source = ConversationLocalSource(ChatDatabase());
  /// final remoteId = 123;
  /// final userId = 456;
  ///
  /// final conversation = await source.getConversationWith(remoteId, userId);
  ///
  /// if (conversation != null) {
  ///   print("Found conversation: $conversation");
  /// } else {
  ///   print("No conversation found with remoteId $remoteId and userId $userId.");
  /// }
  /// ```
  /// - [remoteId]: The remote ID associated with the conversation.
  /// - [userId]: The user ID associated with the conversation.
  Future<LocalConversation?> getConversationWith(
      int remoteId, int userId) async {
    return await (select(db.conversations)
          ..where((c) => c.remoteId.equals(remoteId) | c.userId.equals(userId)))
        .getSingleOrNull();
  }

  /// Retrieves the remote ID of a conversation by its local ID.
  ///
  /// Returns a [Future] that resolves to the remote ID of the conversation with the specified
  /// local ID if found, or `null` if no matching conversation is found.
  ///
  /// Use this method to retrieve the remote ID associated with a local conversation ID.
  ///
  /// - [localId]: The local ID of the conversation to find.
  Future<int?> getRemoteIdByLocalId(int localId) async {
    final query = select(db.conversations)
      ..where((c) => c.localId.equals(localId))
      ..limit(1);

    final result = await query.getSingleOrNull();

    return result?.remoteId;
  }

  /// Deletes a conversation from the local data source by its local ID.
  ///
  /// Returns a [Future] that resolves to a boolean `true` if the conversation was successfully deleted,
  /// or `false` if the deletion failed.
  ///
  /// Use this method to delete a conversation by its local ID.
  ///
  /// Example usage:
  /// ```dart
  /// final localSource = ConversationLocalSource(databaseInstance);
  /// final localIdToDelete = 123;
  /// final isDeleted = await localSource.deleteConversationByLocalId(localIdToDelete);
  ///
  /// if (isDeleted) {
  ///   print("Conversation with local ID $localIdToDelete deleted successfully.");
  /// } else {
  ///   print("Failed to delete conversation with local ID $localIdToDelete.");
  /// }
  /// ```
  /// - [localId]: The local ID of the conversation to delete.
  Future<bool> deleteConversationByLocalId(int localId) async {
    final query = delete(db.conversations)
      ..where((c) => c.localId.equals(localId));

    try {
      await query.go();
      return true; // Deletion successful
    } catch (_) {
      return false; // Deletion failed
    }
  }

  /// Blocks or unblocks a conversation based on its local ID.
  ///
  /// - [conversationLocalId]: The local ID of the conversation to block or unblock.
  /// - [block]: A boolean flag indicating whether to block (true) or unblock (false) the conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final conversationSource = ConversationLocalSource(chatDatabase);
  /// // Block a conversation by its local ID
  /// await conversationSource.blockUnblockConversation(123, true);
  ///
  /// // Unblock a conversation by its local ID
  /// await conversationSource.blockUnblockConversation(123, false);
  /// ```
  ///
  Future<int> blockUnblockConversation(
      int conversationLocalId, bool block) async {
    return await (update(db.conversations)
          ..where((conversation) =>
              conversation.localId.equals(conversationLocalId)))
        .write(
      ConversationsCompanion(
        isBlocked: Value(block),
      ),
    );
  }

  // /// A function to get all conversations from local storage.
  // ///
  // /// This function retrieves all conversations stored in the local
  // /// database and returns them as a list of [Conversation] objects.
  // ///
  // /// Returns:
  // /// - A [Future] that completes with a list of [Conversation] objects
  // ///   representing all the conversations in the local database.

  // Future<List<LocalConversation>> findAllConversations() =>
  //     select(db.conversations).get();

  // Future<LocalConversation?> getConversationByLocalId(int localId) {
  //   return (select(db.conversations)..where((c) => c.localId.equals(localId)))
  //       .getSingleOrNull();
  // }

  // Future<LocalConversation?> getConversationByRemoteId(int remoteId) {
  //   return (select(db.conversations)..where((c) => c.remoteId.equals(remoteId)))
  //       .getSingleOrNull();
  // }

  // Future<int> deleteConversation(LocalConversation conversation) async {
  //   // final conversation = ConversationsCompanion(id: Value(conversationId));
  //   return await delete(db.conversations).delete(conversation);
  // }

  // Future<int> getUniqueRandomNumber() async {
  //   final random = Random();
  //   int randomValue;
  //   // Retrieve all existing IDs from the `moor_conversations` table and create a set of existing IDs.
  //   final existingIds = await select(db.conversations)
  //       .get()
  //       .then((list) => list.map((conversation) => conversation.id).toSet());
  //   // Generate a random number and check if it is not present in the existing IDs set.
  //   do {
  //     randomValue = random.nextInt(1000000);
  //   } while (existingIds.contains(randomValue));

  //   return randomValue;
  // }
//
  // Future<LocalConversation?> getConversationWithUserId(int userid) {
  //   return (select(db.conversations)..where((c) => c.userId.equals(userid)))
  //       .getSingleOrNull();
  // }
//
  /// A function to get a conversation by its associated user ID from local storage.
  ///
  /// This function retrieves a conversation from the local database
  /// based on the provided [userId] and returns it as a [Conversation] object.
  ///
  /// Parameters:
  /// - [userId]: The ID of the associated user of the conversation to retrieve.
  ///
  /// Returns:
  /// - A [Future] that completes with a [Conversation] object representing
  ///   the conversation with the specified [userId]. If no conversation is found
  ///   with the provided [userId], the future completes with `null`.
  // Future<Conversation?> getConversationWithUser(int userId) {
  //   (select(conversations)..orderBy([
  //     (t)=>OrderingTerm.desc(t.createdAt)
  //   ])).join([
  //     leftOuterJoin(other, on)
  //   ])
  //   return (select(db.conversations)..where((c) => c.userId.equals(userId)))
  //       .getSingleOrNull();
  // }
  // Stream<List<ConversationWithNewMessagesAndLastMessage>>
  //     watchConversationsWithNewMessages() {
  //   // Subquery to count new messages for each conversation
  //   final newMessagesSubquery = selectOnly(messages)
  //     ..addColumns([messages.conversationId])
  //     ..where(messages.readAt.isNull())
  //     ..groupBy([messages.conversationId]);
  //   // Custom select query to join conversations with the count of new messages
  //   final customSelectQuery = customSelect([
  //     conversations,
  //     ifThenElse(newMessagesSubquery.exists, 1, 0).as('newMessageCount'),
  //   ]).join([
  //     leftOuterJoin(
  //       newMessagesSubquery,
  //       customSelectQuery.d(conversations.id) ==
  //           newMessagesSubquery.d(messages.conversationId),
  //     ),
  //   ]);
  //   return customSelectQuery.watch().map((rows) {
  //     return rows.map((row) {
  //       final conversation = ConversationsTable().mapFromRow(row.readTable(conversations));
  //       final newMessageCount = row.readInt('newMessageCount');
  //       return ConversationWithNewMessagesAndLastMessage(
  //         conversation: conversation,
  //         newMessageCount: newMessageCount,
  //       );
  //     }).toList();
  //   });
  // }

  /// A function to insert or update a conversation in the local storage.
  ///
  /// If the provided [conversation] has an ID of -1, a unique random ID will
  /// be generated and set as the ID of the conversation before inserting it.
  /// If the conversation already has a valid ID, it will be updated in the
  /// database.
  ///
  /// Parameters:
  /// - [conversation]: The conversation to be inserted or updated.
  ///
  /// Returns:
  /// - A [Future] that completes when the operation is finished.

  /// A function to update a conversation in the local storage.
  ///
  /// Parameters:
  /// - [conversation]: The conversation to be updated.
  ///
  /// Returns:
  /// - A [Future] that completes when the update operation is finished.

  /// A function to delete a conversation from the local storage.
  ///
  /// Parameters:
  /// - [conversation]: The conversation to be deleted.
  ///
  /// Returns:
  /// - A [Future] that completes when the delete operation is finished.

  /// A function to generate a unique random number that is not present in the table before.
  ///
  /// This function generates a random integer between 0 and 99,999.
  /// It checks if the generated value is not already present in the `moor_conversations` table.
  /// If the generated value exists in the table, it generates another random value until it finds a unique one.
  ///
  /// Returns:
  /// - A `Future<int>` representing the generated unique random number.
}
