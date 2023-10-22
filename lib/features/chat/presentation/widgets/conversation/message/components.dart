import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/video_message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

enum MessageStatus {
  notSent,
  sent,
  received,
  read,
}

class IconBorder extends StatelessWidget {
  const IconBorder({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: ChatColors.secondary,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
            color: Theme.of(context).cardColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: icon,
        ),
      ),
    );
  }
}

class PressableIconBackground extends StatelessWidget {
  const PressableIconBackground({
    Key? key,
    this.icon,
    this.child,
    required this.onTap,
    this.borderRadius = 6,
    this.padding = 6,
  }) : super(key: key);
  final double borderRadius;
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      // color: Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: ChatColors.secondary,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: icon != null
              ? Icon(
                  icon,
                  size: 22,
                )
              : child,
        ),
      ),
    );
  }
}

class MessageStatusIcon extends StatelessWidget {
  final LocalMessage message;
  const MessageStatusIcon({super.key, required this.message});

  MessageStatus get messageStatus {
    if (message.sentAt != null) {
      if (message.recievedAt != null) {
        if (message.readAt != null) {
          return MessageStatus.read;
        }
        return MessageStatus.received;
      }
      return MessageStatus.sent;
    }
    return MessageStatus.notSent;
  }

  @override
  Widget build(BuildContext context) {
    return messageStatus == MessageStatus.read
        ? const Icon(
            FontAwesomeIcons.checkDouble,
            color: Colors.blue,
            size: 16,
          )
        : messageStatus == MessageStatus.received
            ? Icon(
                FontAwesomeIcons.checkDouble,
                // color: ,
                size: 16,
              )
            : messageStatus == MessageStatus.sent
                ? const Icon(
                    FontAwesomeIcons.check,
                    // color: Colors.black87,
                    size: 16,
                  )
                : const Icon(
                    Icons.access_time,
                    // color: Colors.black87,
                    size: 18,
                  );
  }
}

class MessageCtreatedAtTextWidget extends StatelessWidget {
  final DateTime date;
  const MessageCtreatedAtTextWidget({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(AppUtil.getHourMinuteDateFormat(date));
  }
}

class MessageBodyTextWidget extends StatelessWidget {
  final String? body;
  final bool isMine;
  const MessageBodyTextWidget({super.key, this.body, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Text(
      body ?? "",
      overflow: TextOverflow.visible,
      softWrap: true,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 17,
        color: isMine
            ? ChatStyle.ownMessageTextColor
            : Get.isPlatformDarkMode
                ? ChatStyle.otherMessageTextDarkColor
                : ChatStyle.otherMessageTextLightColor,
      ),
    );
  }
}

class DownloadUploadIconWithSizeWidget extends StatelessWidget {
  const DownloadUploadIconWithSizeWidget({
    super.key,
    required this.isMine,
    required UploadDownloadController controller,
    required this.size,
  }) : _controller = controller;

  final bool isMine;
  final UploadDownloadController _controller;
  final int size;

  @override
  Widget build(BuildContext context) {
    return PressableCircularContianerWidget(
      onPress: () {
        if (isMine) {
          _controller.startUploading();
        } else {
          _controller.startDownload();
        }
      },
      childPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DownloadUploadIconWidget(isMine: isMine),
          const SizedBox(width: 5),
          MultimediaSizeTextWidget(
            size: size,
            isMine: isMine,
          )
        ],
      ),
      // borderRaduis: 50,
    );
  }
}

class MultimediaSizeTextWidget extends StatelessWidget {
  const MultimediaSizeTextWidget({
    super.key,
    required this.size,
    required this.isMine,
    this.fontSize = 14,
  });

  final int size;
  final double fontSize;
  final bool isMine;
  @override
  Widget build(BuildContext context) {
    return Text(
      AppUtil.getFormatedFileSize(size),
      style: TextStyle(
        color: isMine
            ? ChatStyle.ownMessageTextColor.withOpacity(0.7)
            : Get.isPlatformDarkMode
                ? ChatStyle.otherMessageTextDarkColor.withOpacity(0.7)
                : ChatStyle.otherMessageTextLightColor.withOpacity(0.7),
        fontSize: fontSize,
      ),
    );
  }
}

class MultimediaExtentionTextWidget extends StatelessWidget {
  const MultimediaExtentionTextWidget({
    super.key,
    required this.path,
    required this.isMine,
    this.fontSize = 14,
  });

  final String path;
  final double fontSize;
  final bool isMine;
  @override
  Widget build(BuildContext context) {
    return Text(
      path.split('.').last,
      style: TextStyle(
        color: isMine
            ? ChatStyle.ownMessageTextColor.withOpacity(0.7)
            : Get.isPlatformDarkMode
                ? ChatStyle.otherMessageTextDarkColor.withOpacity(0.7)
                : ChatStyle.otherMessageTextLightColor.withOpacity(0.7),
        fontSize: fontSize,
      ),
    );
  }
}

class DownloadUploadIconWidget extends StatelessWidget {
  const DownloadUploadIconWidget({
    super.key,
    required this.isMine,
  });

  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isMine ? Icons.upload : Icons.download,
      color: Colors.white,
      size: 18,
    );
  }
}

class DownloadinUploadingCicrularWidget extends StatelessWidget {
  const DownloadinUploadingCicrularWidget({
    super.key,
    required UploadDownloadController controller,
  }) : _controller = controller;

  final UploadDownloadController _controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: 0.7,
          child: CircularProgressIndicator(
            value: _controller.progress.value,
            // strokeWidth: 3,
            // backgroundColor: Colors.grey,
            // valueColor: const AlwaysStoppedAnimation<Color>(
            //   Colors.blue,
            // ),
          ),
        ),
        const Icon(
          FontAwesomeIcons.x,
          color: Colors.white,
          size: 16,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 50),
        //   child: Text(
        //     (_controller.progress.value * 100).toStringAsFixed(2),
        //     style: const TextStyle(fontSize: 12),
        //   ),
        // ),
      ],
    );
  }
}

class ImageVideoDeletedPlaceHolderWidget extends StatelessWidget {
  const ImageVideoDeletedPlaceHolderWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const ImageVideoPlaceHolderWidget(),
        Container(
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageVideoPlaceHolderWidget extends StatelessWidget {
  const ImageVideoPlaceHolderWidget({
    super.key,
    this.loadingPlaceHolder = false,
  });
  final bool loadingPlaceHolder;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(
        loadingPlaceHolder
            ? AppImages.circularLoading
            : AppImages.imagePlaceholder,
        fit: BoxFit.contain,
      ),
    );

    //  Container(
    //   // height: double.infinity,
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     color: Colors.grey,
    //     borderRadius: BorderRadius.circular(8),
    //     image: DecorationImage(
    //       onError: (_, s) {
    //         // _controller.fileExists.value = false;
    //       },
    //       image: const AssetImage(AppImages.imagePlaceholder),
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    // );
    // Container(
    //   // height: double.infinity,
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     color: Colors.grey,
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    //   child: message != null ? Center(child: Text(message)) : null,
    // );
  }
}

class PressableCircularContianerWidget extends StatelessWidget {
  final void Function() onPress;

  final double borderRaduis;
  final EdgeInsetsGeometry childPadding;
  final Widget child;
  final Color color;
  const PressableCircularContianerWidget({
    super.key,
    required this.onPress,
    required this.child,
    this.borderRaduis = 50,
    this.childPadding = const EdgeInsets.all(10),
    this.color = ChatStyle.iconsBackColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRaduis),
        ),
        child: Padding(padding: childPadding, child: child),
      ),
    );
  }
}
