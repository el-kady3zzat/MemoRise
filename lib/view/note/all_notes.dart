// ignore_for_file: must_be_immutable

import 'package:get/get.dart';
import 'package:memorise/controllers/all_notes_controller.dart';
import 'package:memorise/model/note_model.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/ui_components/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:memorise/ui_components/note_card.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class AllNotes extends StatelessWidget {
  AllNotes({super.key});

  final TextEditingController filteredTextController = TextEditingController();
  late RxList<NoteModel> filteredList = <NoteModel>[].obs;

  @override
  Widget build(BuildContext context) {
    MemoRiseColors().changeStatusColor();
    //
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    final String catName = data.values.first;
    final String catDocId = data.values.last;
    //

    final AllNotesController noteController =
        Get.put(AllNotesController(catDocId: catDocId));

    //
    filteredTextController.addListener(() {
      final query = filteredTextController.text.toLowerCase();
      filteredList.value = noteController.allnotes
          .where((note) => note.title.toLowerCase().contains(query))
          .toList();
      filteredList.refresh();
    });
    //

    return Scaffold(
        //
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/add_note', arguments: {'catDocId': catDocId});
          },
          backgroundColor: MemoRiseColors().mainBlue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        //
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //
              header(catName, noteController, context),
              //
              Obx(
                () {
                  if (noteController.allnotes.isEmpty) {
                    return noNotes(context, catDocId);
                  }
                  return Expanded(
                    child: filteredList.isEmpty &&
                            filteredTextController.text.isNotEmpty
                        ? Center(
                            child: Image.asset(
                            'assets/images/nothing_found.gif',
                            width: 150,
                          ))
                        : ListView.builder(
                            itemCount: filteredList.isEmpty
                                ? noteController.allnotes.length
                                : filteredList.length,
                            itemBuilder: (context, index) {
                              final note = filteredList.isEmpty &&
                                      filteredTextController.text.isEmpty
                                  ? noteController.allnotes[index]
                                  : filteredList[index];

                              final noteDocId = filteredList.isEmpty &&
                                      filteredTextController.text.isEmpty
                                  ? noteController.docIds[index]
                                  : noteController.docIds[
                                      noteController.allnotes.indexOf(note)];

                              return NoteCard(
                                catDocId: catDocId,
                                noteDocId: noteDocId,
                                note: note,
                              );
                            },
                          ),
                  );
                },
              ),
              //
            ],
          ),
        ));
  }

  Widget header(catName, AllNotesController noteController, context) {
    return Card(
      elevation: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomBackButton(
            onPressed: () {
              Get.back();
            },
            icon: Icons.arrow_back_ios_new_rounded,
          ),
          //
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 180) / 2,
                  child: Text(
                    catName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MemoRiseColors().mainBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(
                  () {
                    return Text(
                      noteController.allnotes.length == 1
                          ? '${noteController.allnotes.length} ${'note'.tr}'
                          : '${noteController.allnotes.length} ${'notes'.tr}',
                      style: TextStyle(
                          color: MemoRiseColors().mainBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          //
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0),
              child: SearchBarAnimation(
                textEditingController: filteredTextController,
                isOriginalAnimation: true,
                buttonBorderColour: MemoRiseColors().mainBlue,
                buttonColour: MemoRiseColors().mainBlue,
                searchBoxColour: MemoRiseColors().mainBlue,
                cursorColour: MemoRiseColors().noteTextWhite,
                durationInMilliSeconds: 3000,
                enteredTextStyle:
                    TextStyle(color: MemoRiseColors().noteTextWhite),
                isSearchBoxOnRightSide: true,
                buttonWidget: Icon(
                  Icons.search,
                  color: MemoRiseColors().noteTextWhite,
                ),
                trailingWidget: Transform.translate(
                  offset: const Offset(0, -1),
                  child: Icon(
                    Icons.search,
                    size: 25,
                    color: MemoRiseColors().noteTextWhite,
                  ),
                ),
                secondaryButtonWidget: Icon(
                  Icons.close,
                  color: MemoRiseColors().noteTextWhite,
                ),
                enableKeyboardFocus: true,
                onPressButton: (isPressed) {
                  if (!isPressed) {
                    filteredTextController.clear();
                    filteredList.clear();
                  }
                },
              ),
            ),
          )
          //
        ],
      ),
    );
  }

  Widget noNotes(context, catDocId) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: () {
            Get.toNamed('/add_note', arguments: {'catDocId': catDocId});
          },
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'u_donot_have_any_notes'.tr,
                    style: const TextStyle(fontSize: 18)),
                TextSpan(
                    text: 'add_a_note'.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.blue)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
