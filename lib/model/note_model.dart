import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  late Timestamp time;
  late String title;
  late String note;
  late List<dynamic> urls;

  NoteModel.fromFirestore(data) {
    time = data['time'];
    title = data['title'];
    note = data['note'];
    urls = data['urls'];
  }
}
