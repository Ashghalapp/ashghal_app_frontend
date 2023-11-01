import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/Auth/singup_controller.dart';
import '../../widgets/social_icons.dart';
import 'login_screen.dart';

class SignUpScreen extends GetView<SignUpController> {
  SignUpScreen({super.key});
  final RxBool isLoading = RxBool(false);
  final bool? isProviderSignUp = Get.arguments?['isProvider'] ?? false;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignUpController());
    Size size = MediaQuery.of(context).size;
    return AppScaffold(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: [
            const LogoWidget(),
            const SizedBox(
              height: 30,
            ),
            Text(
              textAlign: TextAlign.center,
              AppLocalization.createNewAccount,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 30
            ),
            Form(
              key: controller.signUpFormKey,
              child: Column(
                children: [
                  AppTextFormField(
                    // labelText: AppLocalization.fullName,
                    // iconName: Icons.person_outline_outlined,
                    iconName: AppIcons.user,
                    hintText: AppLocalization.fullName,
                    obscureText: false,
                    controller: controller.nameController,
                    validator: (val) {
                      return validInput(val!, 5, 20, 'name');
                    },
                  ),
                  const SizedBox(height: 20),

                  // MyTextFormField(
                  //   textInputtype: TextInputType.number,
                  //   inputformater: <TextInputFormatter>[
                  //     FilteringTextInputFormatter.digitsOnly
                  //   ],
                  //   prefixtext: "+967 ",
                  //   hintText: '22'.tr,
                  //   iconData: Icons.phone_iphone_rounded,
                  //   lable: '56'.tr,
                  //   obscureText: false,
                  //   controller: controller.phoneController,
                  //   validator: (val) {
                  //     return validInput(val!, 9, 9, 'phonenumber');
                  //   },
                  // ),
                  // const SizedBox(height: 20),

                  AppTextFormField(
                    // labelText: AppLocalization.email,
                    // iconName: Icons.email_outlined,
                    iconName: AppIcons.email,
                    hintText: AppLocalization.enterYourEmail,
                    obscureText: false,
                    controller: controller.emailController,
                    validator: (val) {
                      return validInput(val!, 10, 50, 'email');
                    },
                  ),
                  const SizedBox(height: 20),

                  GetBuilder<SignUpController>(
                    init: SignUpController(),
                    initState: (_) {},
                    builder: (_) {
                      return AppTextFormField(
                        sufficxIconDataName: controller.isVisible
                            // ? Icons.visibility_off_outlined
                            // : Icons.visibility_outlined,
                            ? AppIcons.hide
                            : AppIcons.show,
                        obscureText: controller.isVisible,
                        onSuffixIconPressed: () => controller.changVisible(),
                        // labelText: AppLocalization.password,
                        // iconName: Icons.lock_open_outlined,
                        iconName: AppIcons.lock,
                        hintText: AppLocalization.password,
                        controller: controller.passwordController,
                        validator: (val) {
                          return validInput(val!, 6, 50, 'password');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  AppGesterDedector(
                    text: AppLocalization.signIn,
                    color: Theme.of(context).primaryColor,
                    onTap: () async => await controller
                        .submitEmailNamePass(isProviderSignUp ?? false),
                  ),
                  SizedBox(height: size.height * 0.04),
                  const OrContiueWithWidget(),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcons(
                        icon: 'facebook',
                        press: () {},
                      ),
                      SocialIcons(
                        icon: 'google',
                        press: () {},
                      ),
                      SocialIcons(
                        icon: 'apple',
                        press: () {},
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: Theme.of(context).textTheme.labelSmall,
                        AppLocalization.alreadyHaveAcc,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(shadowColor: Colors.white),
                        onPressed: () => Get.offAllNamed(AppRoutes.logIn,),
                        child: Text(
                          AppLocalization.login,
                          style:Get.textTheme.labelMedium
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// class SingUpScreenEmail extends GetView<SignUpController> {
//   const SingUpScreenEmail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: MyAppBar().myappbar('18'),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
//         child: SingleChildScrollView(
//           child: Column(children: [
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             Text(
//               textAlign: TextAlign.center,
//               ' Email Verfication',
//               style: Theme.of(context).textTheme.displayMedium,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Text(
//               'Please Enter your Email To Send The Verfication Code  ',
//               style: TextStyle(color: AppColors.gray),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             const SizedBox(height: 30),
//             MyTextFormField(
//               hintText: '12'.tr,
//               iconData: Icons.email_outlined,
//               lable: '18'.tr,
//               obscureText: false,
//               controller: controller.emailController,
//               validator: (val) {
//                 return validInput(val!, 10, 50, 'email');
//               },
//             ),
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             MyGesterDedector(
//               text: '17'.tr,
//               color:Theme.of(context).primaryColor,
//               onTap: () {
//                 Get.toNamed(AppRoutes.verficationSignUp);
//               },
//             ),
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             TextButton(
//               style: TextButton.styleFrom(shadowColor: Colors.white),
//               onPressed: () => Get.offNamed(AppRoutes.succesSignUp),
//               child: Text(
//                 '58'.tr,
//                 style: const TextStyle(
//                   color: AppColors.darkPrimaryColor,
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// class SignUpScreenLocation extends StatefulWidget {
//   const SignUpScreenLocation({super.key});

//   @override
//   State<SignUpScreenLocation> createState() => _SignUpScreenLocationState();
// }

// class _SignUpScreenLocationState extends State<SignUpScreenLocation> {
//   final TextEditingController _locationController = TextEditingController();
//   // LatLng? _selectedLocation;
//   // Location location = new Location();

//   // Future<LocationData?> getLocation() async {
//   //   bool _serviceEnabled;
//   //   PermissionStatus _permissionGranted;
//   //   LocationData? _locationData;
//   //   try {
//   //     _serviceEnabled = await location.serviceEnabled();
//   //     if (!_serviceEnabled) {
//   //       _serviceEnabled = await location.requestService();
//   //       if (!_serviceEnabled) {
//   //         return null;
//   //       }
//   //     }
//   //     _permissionGranted = await location.hasPermission();
//   //     if (_permissionGranted == PermissionStatus.denied) {
//   //       _permissionGranted = await location.requestPermission();
//   //       if (_permissionGranted != PermissionStatus.granted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //             const SnackBar(content: Text('لم يتم السماح بالوصول للموقع')));
//   //         return null;
//   //       }
//   //     }
//   //     _locationData = await location.getLocation();
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context)
//   //         .showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء تحديد الموقع')));
//   //     print('حدث خطأ أثناء تحديد الموقع: $e');
//   //     return null;
//   //   }
//   //   return _locationData;
//   // }

//   // void _selectLocation() async {
//   //   LocationData? result = await getLocation();
//   //   if (result != null) {
//   //     LatLng location = LatLng(result.latitude!, result.longitude!);
//   //     _mapController?.animateCamera(
//   //       CameraUpdate.newCameraPosition(
//   //         CameraPosition(target: location, zoom: 15),
//   //       ),
//   //     );
//   //     setState(() {
//   //       _selectedLocation = location;
//   //       _locationController.text =
//   //         'Latitude: ${_selectedLocation?.latitude}, Longitude: ${_selectedLocation?.longitude}';
//   //     });
//   //   }
//   // }

//   // void _confirmLocation() {
//   //   if (_selectedLocation != null) {
//   //     _locationController.text =
//   //         'Latitude: ${_selectedLocation?.latitude}, Longitude: ${_selectedLocation?.longitude}';
//   //     // CircularNotchedRectangle();
//   //     // Future.delayed(Duration(seconds: 3), () {
//   //     //   Navigator.pop(context, _selectedLocation.toString());
//   //     // });
//   //   }
//   // }
//   // void _onMapCreated(GoogleMapController controller) {
//   //   _mapController = controller;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar().myappbar('59'.tr),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: TextField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 labelText: '61'.tr,
//               ),
//             ),
//           ),
//           Expanded(
//             child: GoogleMap(
//               // onMapCreated: _onMapCreated,
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(37.7749, -122.4194),
//                 zoom: 12,
//               ),
//               markers: _selectedLocation != null
//                   ? {
//                       Marker(
//                         markerId: const MarkerId('selectedLocation'),
//                         position: _selectedLocation!,
//                         icon: BitmapDescriptor.defaultMarker,
//                       ),
//                     }
//                   : {},
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 FloatingActionButton(
//                   onPressed: () {
//                     // _selectLocation();
//                   },
//                   child: const Icon(Icons.add_location),
//                 ),
//                 const SizedBox(width: 10),
//                 FloatingActionButton(
//                   onPressed: () {
//                     // _confirmLocation();
//                   },
//                   child: const Icon(Icons.check),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }