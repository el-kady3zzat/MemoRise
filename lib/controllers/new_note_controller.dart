import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorise/services/firebase_services.dart';
import 'package:memorise/ui_components/ui_helper.dart';

class NewNoteController extends GetxController {
  late String catDocId;
  late NoteServices noteServices;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final Timestamp time = Timestamp.now();
  late Map data;

  List<XFile>? paths = [];
  final ImagePicker picker = ImagePicker();
  var isLoop = true.obs; // Observable for loop switch
  var interval = 5000.obs; // Observable for interval value

  @override
  void onInit() {
    super.onInit();
    data = Get.arguments as Map;
    catDocId = data['catDocId'];
    noteServices = NoteServices(catDocId: catDocId);
  }

  getImage(isCamera) async {
    XFile? xFile;
    List<XFile>? xFiles;
    if (isCamera) {
      xFile = await picker.pickImage(source: ImageSource.camera);
      if (xFile != null) paths!.add(xFile);
    } else {
      xFiles = await picker.pickMultiImage();
      paths!.addAll(xFiles);
    }

    Get.back();
    update();
  }

  void toggleLoop(bool value) {
    isLoop(value);
    interval(value ? 5000 : 0); // Adjust interval based on isLoop
    update();
  }

  removeImage(pageValue) {
    if (paths!.isNotEmpty) {
      paths!.removeAt(pageValue);
      pageValue != 0 ? pageValue -= 1 : null;
      update();
    }
  }

  saveNote() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      UiHelper.getSnackBar('warning'.tr, 'enter_data_first'.tr);
      return;
    }

    List downloadUrls = [];
    final String? noteDocId = noteServices.addNotes(
        catDocId: catDocId,
        data: {
          'title': titleController.text,
          'note': contentController.text,
          'time': time,
          'urls': downloadUrls
        },
        showSnack: paths!.isEmpty);

    if (paths!.isEmpty) {
      Get.offNamed('/view_edit_note',
          arguments: {'catDocId': catDocId, 'noteDocId': noteDocId});
    }

    if (paths!.isNotEmpty) {
      Map<String, dynamic> urls = {};
      downloadUrls =
          await noteServices.uploadImages(paths!, catDocId, noteDocId);

      urls['urls'] = downloadUrls;
      noteServices.editNote(catDocId, noteDocId!, urls);
    }
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    contentController.dispose();
  }
}
