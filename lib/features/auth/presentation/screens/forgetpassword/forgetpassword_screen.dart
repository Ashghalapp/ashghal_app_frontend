
import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_scaffold_widget.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/forgetpwd/forgetpassword_controller.dart';

class ForgetPassword extends GetView<ForgetPasswordController> {
  const ForgetPassword({super.key});
  
  @override
  Widget build(BuildContext context) {
    print("<>>>>>>>>>>>>>>>>in forget screen>");
    return AppScaffold(
      
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
               AppLocalization.checkEmail,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
               AppLocalization.enterYourEmailForOpt,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                key: controller.forgetPasswordFormKey,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      AppTextFormField(
                        hintText: AppLocalization.enterYourEmail,
                        // iconName: Icons.email_outlined,
                        iconName:AppIcons.email,
                        label: AppLocalization.email,
                        obscureText: false,
                        controller: controller.emailController,
                        validator: (val) {
                          return validInput(val!, 10, 50, 'email');
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppGesterDedector(
                        text: AppLocalization.next,
                        color:Theme.of(context).primaryColor,
                        onTap: () => controller.checkEmail(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
