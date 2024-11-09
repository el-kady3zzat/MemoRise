import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorise/model/note_model.dart';
import 'package:memorise/services/firebase_services.dart';
import 'package:memorise/ui_components/ui_helper.dart';

class ViewNoteController extends GetxController {
  late String catDocId;
  late String noteDocId;
  late NoteServices noteServices;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  //EditNote
  late Map data;
  late NoteModel? note;
  Timestamp time = Timestamp.now();
  List<XFile> paths = [];
  final ImagePicker picker = ImagePicker();
  var isLoop = true.obs; // Observable for loop switch
  var interval = 5000.obs; // Observable for interval value
  late Map<int, int> pathIndex = {};
  late List imagesList = [];
  List<dynamic> downloadUrls = [];
  List deletedUrls = [];

  @override
  void onInit() {
    super.onInit();
    data = Get.arguments as Map;
    catDocId = data['catDocId'];
    noteDocId = data['noteDocId'];
    noteServices = NoteServices(catDocId: catDocId);

    fetchNote();
  }

  fetchNote() async {
    data.containsKey('note')
        ? note = data['note'] //the note that sent from AllNotes().
        : note = await noteServices.getNote(catDocId, noteDocId);

    titleController.text = note!.title;
    contentController.text = note!.note;
    time = note!.time;
    downloadUrls = note!.urls;
    imagesList = [...downloadUrls, ...paths];
    update();
  }

  getImage(isCamera) async {
    XFile? xFile;
    List<XFile>? xFiles;
    if (isCamera) {
      xFile = await picker.pickImage(source: ImageSource.camera);
      if (xFile != null) {
        paths.add(xFile);
        pathIndex = {imagesList.length: paths.length};
      }
    } else {
      xFiles = await picker.pickMultiImage();
      paths.addAll(xFiles);
      for (int i = 0; i < xFiles.length; i++) {
        pathIndex[imagesList.length + i] = i;
      }
    }

    Get.back();
    imagesList = [...downloadUrls, ...paths];
    update();
  }

  void toggleLoop(bool value) {
    isLoop(value);
    interval(value ? 5000 : 0); // Adjust interval based on isLoop
    update();
  }

  void deleteImage(pageValue) {
    final currentImage = imagesList[pageValue];

    if (currentImage is XFile) {
      // Image is from local paths, delete from paths
      paths.removeAt(pathIndex[pageValue]!);
      pathIndex.remove(pageValue);
      imagesList.removeAt(pageValue);

      pageValue != 0 ? pageValue -= 1 : null;
    } else if (currentImage is String && downloadUrls.contains(currentImage)) {
      // Image is from remote (Firebase), delete from downloadUrls
      deletedUrls.add(currentImage);
      downloadUrls.removeAt(pageValue);
      imagesList.removeAt(pageValue);

      pageValue != 0 ? pageValue -= 1 : null;
    }

    // After deletion, update the list
    imagesList = [...downloadUrls, ...paths];
    if (imagesList.isEmpty) {
      //reset the switch
      isLoop.value = true;
    }

    update();
  }

  void updateUrlsList(urls) =>
      noteServices.updateUrlsList(urls, catDocId, noteDocId);

  saveNote() async {
    //if no data in fields.
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      UiHelper.getSnackBar('warning'.tr, 'enter_data_first'.tr);
      return;
    }

    //if no data changes.
    if (paths.isEmpty &&
        deletedUrls.isEmpty &&
        titleController.text == note!.title &&
        contentController.text == note!.note) {
      UiHelper.getSnackBar('saved'.tr, 'no_data_has_changed'.tr);
      return;
    }

    //if the user added new images.
    if (paths.isNotEmpty) {
      downloadUrls =
          await noteServices.uploadImages(paths, catDocId, noteDocId);
      updateNote();
    }

    //if the user deleted images from urls.
    if (deletedUrls.isNotEmpty) {
      updateUrlsList(deletedUrls);
    }
  }

  updateNote() {
    bool isTitleChanged = (note!.title != titleController.text);
    bool isContentChanged = (note!.note != contentController.text);

    //checking for updated elements so, i don't update what hasn't changed.
    Map<String, dynamic> updatedData = {}; // Initialize an empty map

    // Check if title changed
    if (isTitleChanged) {
      updatedData['title'] = titleController.text;
    }

    // Check if content changed
    if (isContentChanged) {
      updatedData['note'] = contentController.text;
    }

    // Check if URLs (images) changed
    if (paths.isNotEmpty) {
      updatedData['urls'] = downloadUrls;
    }

    if (updatedData.isNotEmpty) {
      // If any data has changed, proceed to update the note
      editNote(updatedData);
      paths.clear();
    }
  }

  void editNote(data) {
    noteServices.editNote(catDocId, noteDocId, data);

    if (this.data.isNotEmpty) this.data.remove('note');
    fetchNote();
  }
}
