import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  late Timestamp time;
  late String catName;

  CategoryModel.fromFirestore(data) {
    time = data['time'];
    catName = data['catName'];
  }
}
