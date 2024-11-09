import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:memorise/services/firebase_services.dart';
import 'package:memorise/ui_components/custom_loading_dialog.dart';
import '../ui_components/custom_awesome_dialog.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passController;
  late CustomAwesomeDialog awesomeDialog;
  late LoginServices loginServices;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passController = TextEditingController();
    awesomeDialog = CustomAwesomeDialog();
    loginServices = LoginServices();
  }

  void checkInputFields(BuildContext context) {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      if (emailController.text.isEmpty && passController.text.isEmpty) {
        awesomeDialog.showDialog(
            context,
            'Error',
            'Ha ha ha, you\'re so funny. Enter your email and password.',
            DialogType.error,
            false,
            null);
      } else if (emailController.text.isEmpty) {
        awesomeDialog.showDialog(
            context,
            'Error',
            'Is this a joke? Enter your email first.',
            DialogType.error,
            false,
            null);
      } else if (passController.text.isEmpty) {
        awesomeDialog.showDialog(
            context,
            'Error',
            'Are you kidding me? Enter your password.',
            DialogType.error,
            false,
            null);
      }
    } else {
      CustomLoadingDialog().showLoadingDialog(context, 'Login...');
      _login(context);
    }
  }

  Future<void> _login(BuildContext context) async {
    try {
      final credential = await loginServices.signInWithEandP(
        emailController.text,
        passController.text,
      );

      if (!context.mounted) return;
      Get.back(); //closes loading dialog.

      if (credential?.user != null && credential!.user!.emailVerified) {
        Get.offNamed('/home');
      } else {
        awesomeDialog.showDialog(context, 'verification_required'.tr,
            'verification_msg'.tr, DialogType.info, false, null);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        awesomeDialog.showDialog(context, 'error'.tr,
            'no_user_found_for_that_email'.tr, DialogType.error, false, null);
      } else if (e.code == 'wrong-password') {
        awesomeDialog.showDialog(context, 'error'.tr, 'wrong_password'.tr,
            DialogType.error, false, null);
      }
    }
  }

  Future<void> resetPassword(BuildContext context) {
    if (emailController.text.isNotEmpty) {
      return loginServices.resetPassword(context, emailController.text);
    } else {
      return awesomeDialog.showDialog(context, 'error'.tr,
          'enter_email_first'.tr, DialogType.error, false, null);
    }
  }

  Future<void> signWithGoogle(context) async {
    var loginData = await loginServices.signInWithGoogle(context);
    loginData == true ? Get.offAllNamed('/home') : null;
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passController.dispose();
  }
}
