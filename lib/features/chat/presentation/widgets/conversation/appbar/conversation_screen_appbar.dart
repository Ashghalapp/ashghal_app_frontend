import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/search_textformfield.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/user_status_text_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../avatar.dart';

class ConversationScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final LocalConversation conversation;
  ConversationScreenAppBar({super.key, required this.conversation});
  final ConversationScreenController _screenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _screenController.selectionEnabled.value
          ? buildSelectionAppBar()
          : _screenController.isSearching.value
              ? buildSearchAppbar()
              : buildNormalAppBar(conversation);
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  AppBar buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _screenController.toggleSelectionMode,
        icon: const Icon(
          Icons.close,
        ),
      ),
      title: Text(
        _screenController.selectedMessagesIds.isNotEmpty
            ? "${_screenController.selectedMessagesIds.length} item selected"
            : "No item selected",
        style: const TextStyle(fontSize: 15),
      ),
      actions: [
        Visibility(
          visible: _screenController.selectedMessagesIds.length == 1,
          child: IconButton(
            icon: const Icon(
              Icons.copy_outlined,
            ),
            onPressed: _screenController.copyToClipboard,
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.isNotEmpty,
          child: IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: _screenController.deleteSelectedMessages,
          ),
        ),
        Visibility(
          visible: _screenController.selectedMessagesIds.length == 1,
          child: IconButton(
            icon: const Icon(
              Icons.info_outlined,
            ),
            onPressed: _screenController.viewMessageInfo,
          ),
        ),
        IconButton(
          icon: Obx(() => Icon(
                Icons.select_all,
                color: _screenController.selectedMessagesIds.length ==
                        _screenController.conversationController.messages.length
                    ? Get.theme.primaryColor
                    : null,
              )),
          onPressed: _screenController.selectAllMessages,
        ),
      ],
    );
  }

  AppBar buildSearchAppbar() {
    return AppBar(
      leadingWidth: 50,
      leading: InkWell(
        onTap: _screenController.toggleSearchingMode,
        child: const Icon(
          Icons.arrow_back,
          size: 22,
          // color: Colors.white,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SearchTextField(
          controller: _screenController.searchFeildController,
          onTextChanged: (value) =>
              _screenController.onSearchTextFieldChanged(value),
          focusNode: _screenController.searchFeildFocusNode,
          // onSearchPressed: _screenController.searchInMessages,
        ),
      ),
      actions: [
        const SizedBox(width: 5),
        InkWell(
          onTap: _screenController.incrementIndex,
          child: const Icon(
            Icons.arrow_drop_up,
            // color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: _screenController.decrementIndex,
          child: const Icon(
            Icons.arrow_drop_down,
            // color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );

    // PreferredSize(
    //   preferredSize: Size(Get.width, 300),
    //   child: Card(
    //     color: Get.isDarkMode ? ChatColors.appBarDark : ChatColors.appBarLight,
    //     // color: ChatStyle.ownMessageColor,
    //     // color: Color.fromRGBO(25, 39, 52, 1),
    //     margin: const EdgeInsets.only(top: 53, bottom: 10),
    //     child: Row(
    //       children: [
    //         const SizedBox(width: 7),
    //         InkWell(
    //           onTap: _screenController.toggleSearchingMode,
    //           child: const Icon(
    //             Icons.arrow_back,
    //             size: 22,
    //             // color: Colors.white,
    //           ),
    //         ),
    //         const SizedBox(width: 5),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Expanded(
    //             child: SearchTextField(
    //               controller: _screenController.searchFeildController,
    //               // onSearchPressed: _screenController.searchInMessages,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(width: 5),
    //         InkWell(
    //           onTap: _screenController.incrementIndex,
    //           child: const Icon(
    //             Icons.arrow_drop_up,
    //             // color: Colors.white,
    //             size: 27,
    //           ),
    //         ),
    //         const SizedBox(width: 7),
    //         InkWell(
    //           onTap: _screenController.decrementIndex,
    //           child: const Icon(
    //             Icons.arrow_drop_down,
    //             // color: Colors.white,
    //             size: 27,
    //           ),
    //         ),
    //         const SizedBox(width: 7),
    //       ],
    //     ),
    //   ),
    // );
  }

  AppBar buildNormalAppBar(LocalConversation conversation) {
    return AppBar(
      centerTitle: false,
      // backgroundColor: ChatStyle.ownMessageColor,
      // backgroundColor: Color.fromRGBO(25, 39, 52, 1),
      elevation: 2,
      leadingWidth: 100,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 9),
          PressableIconBackground(
            child: const Icon(
              Icons.arrow_back_ios_new,
            ),
            onTap: () => Get.back(),
          ),
          const SizedBox(width: 8),
          UserImageAvatarWithStatusWidget(
            userId: conversation.userId,
            userName: conversation.userName,
            raduis: 23,
            boderThickness: 0,
            imageUrl: conversation.userImageUrl,
            statusBorderColor: Colors.white54,
          ),
        ],
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conversation.userName,
            // style: const TextStyle(
            //   fontWeight: FontWeight.w500,
            //   fontSize: 20,
            //   // color: Colors.white,
            // ),
          ),
          const SizedBox(height: 5),
          UserStatusTextWidget(
            userId: conversation.userId,
            offlineColor:
                Get.isPlatformDarkMode ? Colors.white70 : Colors.black45,
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            // color: Colors.white,
          ),
          onPressed: _screenController.toggleSearchingMode,
        ),
        buildAppbarDropDownMenuOptions()
      ],
    );
  }

  PopupMenuButton<ConversationPopupMenuItemsValues>
      buildAppbarDropDownMenuOptions() {
    return PopupMenuButton<ConversationPopupMenuItemsValues>(
      onSelected: _screenController.popupMenuButtonOnSelected,
      itemBuilder: (BuildContext ctx) {
        return [
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.search,
            child: Text(ConversationPopupMenuItemsValues.search.value),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.media,
            child: Text(ConversationPopupMenuItemsValues.media.value),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.goToFirstMessage,
            child:
                Text(ConversationPopupMenuItemsValues.goToFirstMessage.value),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.clearChat,
            child: Text(ConversationPopupMenuItemsValues.clearChat.value),
          ),
          PopupMenuItem(
            value: ConversationPopupMenuItemsValues.block,
            child: Text(ConversationPopupMenuItemsValues.block.value),
          ),
        ];
      },
    );
  }
}
