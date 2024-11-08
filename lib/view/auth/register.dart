import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memorise/controllers/login_controller.dart';
import 'package:memorise/controllers/register_controller.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/view/components/custom_back_button.dart';
import 'package:memorise/view/components/custom_loading_dialog.dart';
import 'package:memorise/view/components/custom_login_providers.dart';
import 'package:memorise/view/components/custom_logo.dart';
import 'package:memorise/view/components/custom_material_button.dart';
import 'package:memorise/view/components/custom_text_form_field.dart';

class Register extends StatelessWidget {
  Register({super.key});
  //
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    MemoRiseColors().changeStatusColor();

    return Scaffold(
      body: Form(
        key: controller.registerFormKey,
        child: Container(
          padding:
              const EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 16),
          child: ListView(
            children: [
              //
              CustomBackButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icons.arrow_back_ios_new_rounded,
              ),
              //
              const CustomLogo(),
              //
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'register'.tr,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MemoRiseColors().mainBlue),
                ),
              ),
              //
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'welcome_to_app'.tr,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              //
              CustomTextFormField(
                controller: controller.usernameController,
                label: 'username'.tr,
                hint: 'enter_username'.tr,
                keyboardType: TextInputType.text,
              ),
              //
              CustomTextFormField(
                controller: controller.emailController,
                label: 'email'.tr,
                hint: 'enter_your_email'.tr,
                keyboardType: TextInputType.emailAddress,
              ),
              //
              CustomTextFormField(
                controller: controller.passController,
                label: 'password'.tr,
                hint: 'enter_your_password'.tr,
                keyboardType: TextInputType.visiblePassword,
              ),
              //
              CustomTextFormField(
                controller: controller.passConfirmController,
                label: 'confirm_password'.tr,
                hint: 'confirm_your_password'.tr,
                keyboardType: TextInputType.visiblePassword,
              ),
              //
              const SizedBox(height: 20),
              //
              CustomMaterialButton(
                height: 0,
                text: 'register'.tr,
                onPressed: () {
                  controller.registerUser(context);
                },
                fontSize: 20,
              ),
              //
              const SizedBox(height: 20),
              //
              Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, bottom: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(height: 2, color: Colors.black12)),
                    Text('or_register_with'.tr,
                        style: const TextStyle(fontSize: 16)),
                    Expanded(child: Container(height: 2, color: Colors.black12))
                  ],
                ),
              ),
              //
              CustomLoginMethods(
                  onFacebookPressed: () {},
                  onGooglePressed: () {
                    CustomLoadingDialog()
                        .showLoadingDialog(context, 'Login...');
                    final LoginController controller =
                        Get.put(LoginController());
                    controller.signWithGoogle(context);
                  },
                  onApplePressed: () {}),
              //
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'already_have_an_account'.tr,
                              style: const TextStyle(fontSize: 18)),
                          TextSpan(
                              text: 'login'.tr,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.blue))
                        ]))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
