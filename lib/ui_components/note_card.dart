import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:memorise/controllers/all_notes_controller.dart';
import 'package:memorise/model/note_model.dart';
import 'package:memorise/theme/colors.dart';
import 'package:flutter/widgets.dart' as flutter;

class NoteCard extends StatelessWidget {
  final String catDocId;
  final String noteDocId;
  final NoteModel note;

  const NoteCard(
      {required this.catDocId,
      required this.noteDocId,
      required this.note,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MemoRiseColors().noteBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onLongPress: () {
              showDeleteDialog(context, catDocId, noteDocId);
            },
            onTap: () {
              Get.toNamed('/view_edit_note', arguments: {
                'note': note,
                'catDocId': catDocId,
                'noteDocId': noteDocId
              });
            },
            //
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                note.title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textDirection: note.title.contains(RegExp(r'[\u0600-\u06FF]'))
                    ? flutter.TextDirection.rtl
                    : flutter.TextDirection.ltr,
              ),
            ),
            //
            subtitle: Text(
              maxLines: 2,
              note.note,
              style: const TextStyle(color: Colors.white),
              textDirection: note.note.contains(RegExp(r'[\u0600-\u06FF]'))
                  ? flutter.TextDirection.rtl
                  : flutter.TextDirection.ltr,
            ),
          ),
          //
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              color: Colors.blue[900],
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 8, top: 6),
              child: Row(
                children: [
                  //
                  Text(
                    timeFormat(note.time),
                    style: const TextStyle(color: Colors.white),
                  ),
                  //
                  const Expanded(child: SizedBox()),
                  //
                  note.urls.isNotEmpty
                      ? const Icon(
                          Icons.image,
                          color: Colors.white,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  String timeFormat(time) {
    Timestamp timestamp = time;
    DateTime dateTime = timestamp.toDate();
    return DateFormat('d MMM yyyy h:mm a').format(dateTime);
  }

  showDeleteDialog(context, catDocId, noteDocId) {
    Dialogs.materialDialog(
      msg: 'delete_warning'.tr,
      title: "delete".tr,
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Get.back();
          },
          text: 'cancel'.tr,
          iconData: Icons.cancel_outlined,
          textStyle: const TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () {
            Get.back();
            AllNotesController noteController = Get.find();
            note.urls.isNotEmpty
                ? noteController.deleteImages(note.urls, catDocId, noteDocId)
                : noteController.deleteNote(catDocId, noteDocId);
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
