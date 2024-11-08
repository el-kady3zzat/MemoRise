import 'package:awesome_dialog/awesome_dialog.dart';

class CustomAwesomeDialog {
  late AwesomeDialog dialog;

  showDialog(context, title, description, dialogType, withBtn,
      void Function()? onPress) {
    dialog = AwesomeDialog(
        context: context,
        dialogType: dialogType,
        animType: AnimType.scale,
        title: title,
        dismissOnTouchOutside: false,
        desc: description,
        btnOkOnPress: withBtn
            ? onPress
            : () {
                dialog.dismiss;
              });

    dialog.show();
  }
}
