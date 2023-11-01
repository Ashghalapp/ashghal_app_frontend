import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/localization/local_controller.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';

import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/conversation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ChatPopupMenuItemsValues {
  settings,
  blockedUsers,
}

extension ChatPopupMenuItemsValuesExtension on ChatPopupMenuItemsValues {
  String get value {
    switch (this) {
      case ChatPopupMenuItemsValues.settings:
        return AppLocalization.settings;
      case ChatPopupMenuItemsValues.blockedUsers:
        return AppLocalization.blockedUsers;
    }
  }
}

class ChatScreenController extends GetxController {
  // RxList<ConversationWithCountAndLastMessage> get conversations =>
  //     _chatController.conversations;
  // RxBool isLoaing = false.obs;
  RxBool isSearching = false.obs;
  final ChatController chatController = Get.put(ChatController());
  TextEditingController searchFeildController = TextEditingController();
  FocusNode searchFeildFocusNode = FocusNode();
  RxBool isSearchTextEmpty = true.obs;

  RxBool selectionEnabled = false.obs;
  RxBool forwardSelectionEnabled = false.obs;
  RxList<int> selectedConversationsIds = <int>[].obs;
  // MessageAndMultimediaModel? _forwardedMessage;
  Future<void> Function(List<int> selectedConversationsIds)?
      _onForwardedMessageSend;

  resetToNormalMode() {
    isSearching.value = false;
    searchFeildController.text = "";
    isSearchTextEmpty.value = true;
    selectionEnabled.value = false;
    forwardSelectionEnabled.value = false;
    selectedConversationsIds.clear();
    _onForwardedMessageSend = null;
  }

  void forwardMessage(
      Future<void> Function(List<int> selectedConversationsIds)
          onForwardedMessageSend) {
    forwardSelectionEnabled.value = true;
    print(
        "Here we are*********************************************************");
    _onForwardedMessageSend = onForwardedMessageSend;
  }

  void cnacelForwardMode() {
    resetToNormalMode();
    Get.back();
    // _forwardedMessage = null;
  }

  Future<void> forwardMessageToSelectedConversations() async {
    resetToNormalMode();
    _onForwardedMessageSend ?? (selectedConversationsIds);
  }

  void selectConversation(int conversationId) {
    if (!(selectionEnabled.value || forwardSelectionEnabled.value)) {
      selectionEnabled.value = true;
    }
    if (selectedConversationsIds.contains(conversationId)) {
      selectedConversationsIds.remove(conversationId);
    } else {
      selectedConversationsIds.add(conversationId);
    }
  }

  Future<void> startConversationWith(int userId) async {
    chatController.startConversationWith(userId);
  }

  Future<void> deleteConversation(int conversationId) async {
    chatController.deleteConversation(conversationId);
  }

  popupMenuButtonOnSelected(ChatPopupMenuItemsValues value) {
    if (value == ChatPopupMenuItemsValues.settings) {
      AppLocallcontroller controller = Get.find();
      controller.changLang("en");
      // goToSettingsScreen();
    } else if (value == ChatPopupMenuItemsValues.blockedUsers) {
      goToBlockedUsersScreen();
    }
    // else if (value == ChatPopupMenuItemsValues.createConversation) {
    //   startConversationWith(13);
    // }
  }

  toggleSearchMode() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      // chatController.searchMatchedMessages.clear();
      searchFeildController.clear();
      chatController.stopSearchMode();
      isSearchTextEmpty.value = true;
      // chatController.searchText = "";
    } else {
      searchFeildFocusNode.requestFocus();
    }
  }

  clearSearchField() {
    searchFeildController.text = "";
    isSearchTextEmpty.value = true;
  }

  // Future<void> onSearchButtonPressed() async {
  //   print("onSearchButtonPressed");
  //   if (searchFeildController.text.trim() != "") {
  //     searchStarted = true;
  //     await chatController.search(searchFeildController.text);
  //   }
  // }

  // bool searchStarted = false;

  Future<void> onSearchTextFieldChanges(String text) async {
    print("onSearchTextFieldChanges");
    // if (text.trim().length > 2 || searchStarted) {
    if (text.trim().isEmpty) {
      isSearchTextEmpty.value = true;
    } else {
      isSearchTextEmpty.value = false;
    }
    await chatController.search(text);
    // }
  }

  void goToSettingsScreen() {}
  void goToBlockedUsersScreen() {}
  void goToConversationScreen(LocalConversation conversation,
      [LocalMessage? matchedMessage]) {
    Get.delete<ConversationScreenController>();
    Get.put(ConversationScreenController(conversation: conversation));
    Get.to(() => ConversationScreen(conversation: conversation));
  }

  void goToConversationScreenWithSearchData(
    MatchedConversationsAndMessage matchedConversation,
  ) {
    goToConversationScreen(
      matchedConversation.conversation,
      matchedConversation.message,
    );
    // Get.delete<ConversationScreenController>();
    // Get.put(ConversationScreenController(
    //     conversation: matchedConversation.conversation));
    // Get.to(() =>
    //     ConversationScreen(conversation: matchedConversation.conversation));
  }
}