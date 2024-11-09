import 'package:get/get.dart';
import 'package:memorise/controllers/login_controller.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/ui_components/custom_loading_dialog.dart';
import 'package:memorise/ui_components/custom_login_providers.dart';
import 'package:memorise/ui_components/custom_logo.dart';
import 'package:memorise/ui_components/custom_material_button.dart';
import 'package:memorise/ui_components/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});
  //
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    MemoRiseColors().changeStatusColor();

    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(top: 50, left: 16, bottom: 16, right: 16),
        child: ListView(
          children: [
            //
            const CustomLogo(),
            //
            const SizedBox(height: 16),
            //
            Text(
              'login'.tr,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            //
            const SizedBox(height: 8),
            //
            Text('welcome_back'.tr,
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            //
            const SizedBox(height: 16),
            //
            CustomTextFormField(
                controller: controller.emailController,
                label: 'email'.tr,
                hint: 'enter_your_email'.tr,
                keyboardType: TextInputType.emailAddress),
            //
            CustomTextFormField(
              controller: controller.passController,
              hint: 'enter_your_password'.tr,
              label: 'password'.tr,
              keyboardType: TextInputType.visiblePassword,
            ),
            //
            InkWell(
              onTap: () => controller.resetPassword(context),
              child: Text('forgot_password'.tr,
                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                  textAlign: TextAlign.right),
            ),
            //
            const SizedBox(height: 20),
            //
            CustomMaterialButton(
              height: 0,
              fontSize: 20,
              text: 'login'.tr,
              onPressed: () => controller.checkInputFields(context),
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
                  Expanded(child: Container(height: 2, color: Colors.black12)),
                  Text('or_login_with'.tr,
                      style: const TextStyle(fontSize: 16)),
                  Expanded(child: Container(height: 2, color: Colors.black12))
                ],
              ),
            ),
            //
            CustomLoginMethods(
              onFacebookPressed: () {},
              onGooglePressed: () {
                CustomLoadingDialog().showLoadingDialog(context, 'Login...');
                controller.signWithGoogle(context);
              },
              onApplePressed: () {},
            ),
            //
            InkWell(
              onTap: () {
                Get.toNamed('/register');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: 'donot_have_an_account'.tr,
                        style: const TextStyle(fontSize: 18)),
                    TextSpan(
                        text: 'register'.tr,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.blue))
                  ]))
                ]),
              ),
            )
            //
          ],
        ),
      ),
    );
  }
}
