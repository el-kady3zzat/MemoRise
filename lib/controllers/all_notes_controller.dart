import 'package:get/get.dart';

import 'package:memorise/model/note_model.dart';
import 'package:memorise/services/firebase_services.dart';

class AllNotesController extends GetxController {
  final allnotes = <NoteModel>[].obs;
  late String catDocId;
  late NoteServices noteServices;
  late RxList<String> docIds = <String>[].obs;

  AllNotesController({required this.catDocId});

  @override
  void onInit() {
    super.onInit();
    noteServices = NoteServices(catDocId: catDocId);
    allnotes.bindStream(noteServices.noteStream());
    docIds.value = noteServices.docsIds();
  }

  void deleteImages(List<dynamic> urls, catDocId, noteDocId) =>
      noteServices.deleteImages(false, urls, catDocId, noteDocId);

  void deleteNote(catDocId, noteDocId) =>
      noteServices.deleteNote(catDocId, noteDocId);
}
