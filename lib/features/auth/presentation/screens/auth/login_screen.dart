import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../../config/app_colors.dart';

import '../../../../../config/app_images.dart';
import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/Auth/login_controller.dart';
import '../../widgets/social_icons.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppScaffold(
      // appBarTitle:  LocalizationString.signIn,
      onBack: () => AppUtil.exitApp(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: ListView(
      
          children: [
Image.asset(AppImages.logo,fit: BoxFit.contain,width: 200,height: 150,), const SizedBox(
              height: 30,
            ),
            Text(
              textAlign: TextAlign.center,
              LocalizationString.logintoyouraccount,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            // Text(
            //   LocalizationString.signInMessage,
            //   style:Theme.of(context).textTheme.bodyMedium,
            //   textAlign: TextAlign.center,
            // ),
        
            Form(
              key: controller.loginFormKey,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    MyTextFormField(
                      hintText: LocalizationString.enterYourEmail,
                      iconData:Icons.email_outlined,
                      lable: LocalizationString.email,
                      obscureText: false,
                      controller: controller.emailController,
                      validator: (val) {
                        return validInput(val!, 10, 50, 'email');
                      },

                      
                    ),
                  
                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<LoginController>(
                      init: LoginController(),
                      initState: (_) {},
                      builder: (_) {
                        return MyTextFormField(
                          sufficxIconData: controller.isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          obscureText: controller.isVisible,
                          onPressed: () => controller.changVisible(),
                          hintText: LocalizationString.pleaseEnterPassword,
                          iconData: Iconsax.lock,
                          lable: LocalizationString.password,
                          controller: controller.passwordController,
                          validator: (val) {
                            return validInput(val!, 6, 50, 'password');
                          },
                        );
                      },
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () =>
                                Get.toNamed(AppRoutes.forgetPassword),
                            child: Text(
                              LocalizationString.forgotPwd,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.labelMedium,
                            ))
                      ],
                    ),

                    MyGesterDedector(
                      text: LocalizationString.signIn,
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        controller.login();
                      },
                    ),

                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          style: Theme.of(context).textTheme.labelSmall,
                           LocalizationString.dontHaveAccount,
                        ),
                        TextButton(
                          style:
                              TextButton.styleFrom(shadowColor: Colors.white),
                          onPressed: () =>
                              Get.offNamed(AppRoutes.chooseUserTypeScreen),
                          child: Text(
                            LocalizationString.signUp,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialIcons(
                          icon: 'facebook',
                          press: () {},
                        ), SocialIcons(icon: 'google', press: () {}),
                        SocialIcons(icon: 'apple', press: () {}),
                       
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(shadowColor: Colors.white),
                      onPressed: () {
                        Get.offNamed(AppRoutes.mainScreen);
                      },
                      child: Text(
                        "Guest",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
