import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/view/components/custom_material_button.dart';

class UiHelper {
  late final AwesomeDialog awesomeDialog;
  late SnackBar snackBar;
  final BuildContext context;
  final TextEditingController categoryNameController = TextEditingController();

  UiHelper(this.context);

  //////////////////////////////////////////////////////////////////////////////
  showAwesomeDialog(title, description, dialogType) {
    awesomeDialog = AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      title: title,
      dismissOnTouchOutside: false,
      desc: description,
      btnOkOnPress: () {
        awesomeDialog.dismiss();
      },
    );
    awesomeDialog.show();
  }

  dismissAwesomeDialog() {
    awesomeDialog.dismiss();
  }

  //////////////////////////////////////////////////////////////////////////////

  static showLoadingDialog(String message) {
    Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20.0),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ));
  }

  //////////////////////////////////////////////////////////////////////////////

  static getSnackBar(title, message) {
    Get.snackbar(
      title, message,
      duration: const Duration(seconds: 2),
      // margin: EdgeInsets.only(top: 32),
      titleText: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'PlayfairDisplay',
            fontSize: 20,
            fontWeight: FontWeight.w900),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'PlayfairDisplay',
            fontSize: 16,
            fontWeight: FontWeight.w900),
      ),
    );
  }

  // showSnackBar(ContentType type, title, message) {
  //   snackBar = SnackBar(
  //     /// need to set following properties for best effect of awesome_snackbar_content
  //     elevation: 0,
  //     behavior: SnackBarBehavior.floating,
  //     backgroundColor: Colors.transparent,
  //     content: AwesomeSnackbarContent(
  //       title: title,
  //       message: message,

  //       /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
  //       contentType: type,
  //     ),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  // dismissSnackBar() {
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // }

  //////////////////////////////////////////////////////////////////////////////
  ///
  static void showChooseImageDialog(isEdit, void Function()? onCameraPressed,
      void Function()? onGalleryPressed) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: MemoRiseColors().mainBlue,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Center(
                  child: Text('image_source'.tr,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18))),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomMaterialButton(
                    height: 45,
                    fontSize: 16,
                    text: 'camera'.tr,
                    onPressed: onCameraPressed,
                  ),
                  //
                  CustomMaterialButton(
                    height: 45,
                    fontSize: 16,
                    text: 'gallery'.tr,
                    onPressed: onGalleryPressed,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
