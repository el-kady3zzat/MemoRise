import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memorise/services/firebase_services.dart';
import 'package:memorise/ui_components/custom_awesome_dialog.dart';
import 'package:memorise/ui_components/custom_loading_dialog.dart';

class RegisterController extends GetxController {
  late GlobalKey<FormState> registerFormKey;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController passConfirmController;
  late CustomAwesomeDialog awesomeDialog;
  late RegisterServices registerModel;

  @override
  void onInit() {
    super.onInit();
    registerFormKey = GlobalKey();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    passConfirmController = TextEditingController();
    awesomeDialog = CustomAwesomeDialog();
    registerModel = RegisterServices();
  }

  registerUser(context) async {
    CustomLoadingDialog().showLoadingDialog(context, 'login...'.tr);
    if (!registerFormKey.currentState!.validate()) {
      Get.back();
      return;
    }

    if (passController.text != passConfirmController.text) {
      Get.back();
      awesomeDialog.showDialog(context, 'error'.tr, 'password_do_not_match'.tr,
          DialogType.error, false, () {});
      return;
    }

    await registerModel.registerUser(context, emailController.text,
        passController.text, usernameController.text);
  }

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    passConfirmController.dispose();
  }
}
