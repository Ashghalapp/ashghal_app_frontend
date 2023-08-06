
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../core/widget/app_buttons.dart';





// class AppUtil {
//   static void hideKeyboard(BuildContext context) {
//     FocusScope.of(context).requestFocus(FocusNode());
//   }

//   static Widget addProgressIndicator(BuildContext context, double? size) {
//     return Center(
//         child: SizedBox(
//       width: size ?? 50,
//       height: size ?? 50,
//       child: CircularProgressIndicator(
//           strokeWidth: 2.0,
//           backgroundColor: Colors.black12,
//           valueColor:
//               AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
//     ));
//   }
  
// Future buildErrorDialog(String message) {
//     final size= Get.mediaQuery.size;
//     return Get.defaultDialog(
//       title: "Error!",
//       titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
//       content: Container(
//         width: size.width,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Text(message),
//       ),
//       confirm: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: MyGesterDedector(onTap: () => Get.back(), text: "Ok"),
//       ),
//     );
//   }
// ///دالة لفحص الانترنت
//  static Future<bool> checkInternet() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi;
//   }
//   static void showErrorToast(String title, String message) {
//     Get.snackbar(title, message,
//         duration: const Duration(seconds: 4),
//         padding: EdgeInsets.only(
//           right: 10,
//           left: 10,
//           top: title == "" ? 0 : 6,
//           bottom: title == "" ? 20 : 6,
//         ));
//   }

//   static void showMessage(String message, Color color) {
//     ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
//       content: Text(
//         message,
//         style: Get.textTheme.bodyMedium!.copyWith(color: Colors.white),      
//       ),
//       backgroundColor: color,
//       duration: const Duration(seconds: 4),
//     ));
//   }
// }