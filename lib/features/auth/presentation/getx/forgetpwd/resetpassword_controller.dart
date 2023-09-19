import 'package:ashghal_app_frontend/features/auth/domain/Requsets/reset_password_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/reset_password_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../core/services/dependency_injection.dart' as di;

import '../../../../../config/app_routes.dart';

import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/util/app_util.dart';
import 'successresetpassword_controller.dart';

class ResetPasswordController extends GetxController {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey();
  bool isVisible = true;
  bool isConfirmVisible = true;

  checkResetPassword() async {
    String code = Get.arguments['otpCode'];
    String email = Get.arguments['email'];

    if (!(resetPasswordFormKey.currentState?.validate() ?? false)) return;

    EasyLoading.show(status: LocalizationString.loading);
    final resetPasswordRequest = ResetPasswordRequest.withEmail(
      email: email,
      code: code,
      newPassword: passwordController.text.trim(),
    );
    ResetPasswordUseCase resetPasswordUseCase = di.getIt();
    final result = await resetPasswordUseCase(resetPasswordRequest);

    result.fold(
      (failure) {
        AppUtil.hanldeAndShowFailure(failure, prefixText: 'Reset Password failed:');
      },
      (success) {
        AppUtil.showMessage(LocalizationString.success, Colors.greenAccent);
        goToSuccessResetPassword();
      },
    );
    EasyLoading.dismiss();
  }

  goToSuccessResetPassword() {
    Get.lazyPut(() => SuccessResetPasswordControllerImp());
    Get.offAllNamed(AppRoutes.succesResetPassword);
  }

  @override
  void onInit() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }

  changVisible() {
    isVisible = !isVisible;
    update();
  }

  changConfirmVisible() {
    isConfirmVisible = !isConfirmVisible;
    update();
  }
}
