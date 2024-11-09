import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/view/category/category.dart';

class CategoryCard extends StatelessWidget {
  final String docId;
  final String catName;
  final Timestamp time;
  final Category category = Category();

  CategoryCard(this.docId, this.catName, this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/note',
          arguments: {'catName': catName, 'catDocId': docId}),
      onLongPress: () => showEditDeleteDialog(context, docId, catName),
      child: Card(
        shadowColor: Colors.yellow,
        elevation: 10,
        color: Colors.blue[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset('assets/images/notes_folder.png', height: 90),
              const SizedBox(height: 8),
              Text(
                catName,
                style: TextStyle(
                    color: MemoRiseColors().mainBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showEditDeleteDialog(
      BuildContext context, String docId, String categoryName) {
    Dialogs.materialDialog(
      msg: 'edit_or_delete_this_category'.tr,
      title: "edit_or_delete".tr,
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Get.back();
            category.showAddDialog(context, true, docId, catName);
          },
          text: 'edit'.tr,
          iconData: Icons.edit_document,
          color: MemoRiseColors().mainBlue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            Get.back();
            category.categoryController.deleteCategory(docId);
            category.categoryController.docIds.removeWhere((id) => id == docId);
          },
          text: 'delete'.tr,
          iconData: Icons.delete,
          color: Colors.red,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }
}
