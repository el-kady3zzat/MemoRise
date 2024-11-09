// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:memorise/controllers/view_note_controller.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/ui_components/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:memorise/ui_components/custom_note_text_form_field.dart';
import 'package:memorise/ui_components/ui_helper.dart';

class ViewNote extends StatelessWidget {
  ViewNote({super.key});

  late int pageValue = 0;

  final ViewNoteController controller = Get.put(ViewNoteController());

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      //
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          onPressed: () {
            UiHelper.showChooseImageDialog(
                true,
                () => controller.getImage(true),
                () => controller.getImage(false));
          },
          backgroundColor: Colors.blue[900],
          child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
        ),
      ),
      //
      body: SafeArea(
          child: Column(
        children: [
          //
          header(),
          //
          CustomNoteTextFormField(
            controller: controller.titleController,
            hint: 'title'.tr,
            hintFontSize: 34,
            fontSize: 34,
            keyboardType: TextInputType.text,
            isContent: false,
          ),
          //
          splitter(),
          //
          GetBuilder<ViewNoteController>(
            builder: (builder) => controller.imagesList.isNotEmpty
                ? imgViewer()
                : const SizedBox(height: 0),
          ),
          //
          splitter(),
          //
          Expanded(
            child: CustomNoteTextFormField(
              controller: controller.contentController,
              hint: 'type_your_note_here'.tr,
              hintFontSize: 16,
              fontSize: 16,
              keyboardType: TextInputType.multiline,
              isContent: true,
            ),
          )
          //
        ],
      )),
    );
  }

  Widget header() {
    return Card(
      elevation: 10,
      child: Row(
        children: [
          CustomBackButton(
              onPressed: () {
                Get.back();
              },
              icon: Icons.arrow_back_ios_new_rounded),
          //
          Expanded(
            child: Text(
                textAlign: TextAlign.center,
                timeFormat(controller.time.toDate())),
          ),
          //
          CustomBackButton(
              //save button
              onPressed: () {
                controller.saveNote();
              },
              icon: Icons.done_rounded),
        ],
      ),
    );
  }

  Widget splitter() {
    return Container(
      height: 1,
      color: const Color(0xb4b4b4b4),
      margin: const EdgeInsets.only(left: 50, right: 50, bottom: 8),
    );
  }

  Widget imgViewer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, left: 4.0),
          child: Stack(
            children: [
              ImageSlideshow(
                width: double.infinity,
                height: 220,
                initialPage: 0,
                indicatorColor: MemoRiseColors().mainBlue,
                indicatorBackgroundColor: Colors.grey,
                onPageChanged: (value) {
                  pageValue = value;
                },
                autoPlayInterval: controller.interval.value,
                isLoop: controller.isLoop.value,

                // Combine both images from Urls and Paths.
                children: [
                  ...controller.downloadUrls.map<Widget>((url) {
                    // Handle network images
                    return buildImageCard(
                      imageWidget: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  }).toList(),
                  ...controller.paths.map<Widget>((file) {
                    // Handle local files
                    return buildImageCard(
                      imageWidget: Image.file(
                        File(file.path),
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  }).toList(),
                ],
              ),
              //
              Opacity(
                opacity: 0.8,
                child: Container(
                  height: 50,
                  margin:
                      const EdgeInsets.only(right: 4.0, left: 4.0, top: 4.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Switch(
                          activeColor: MemoRiseColors().mainBlue,
                          value: controller.isLoop.value,
                          onChanged: (state) {
                            controller.toggleLoop(state);
                            if (!state) {
                              pageValue = controller.paths.length - 1;
                            }
                          },
                        ),
                        //
                        //Text('auto_loop'.tr),
                        //
                        const Expanded(
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        //
                        //Text('delete_image'.tr),
                        //
                        InkWell(
                          onTap: () {
                            controller.deleteImage(pageValue);
                          },
                          child: Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.blue[900],
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildImageCard({required Widget imageWidget}) {
    // Helper method to avoid code duplication for both Image.network and Image.file
    return SizedBox(
      width: 100,
      height: 140,
      child: InstaImageViewer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            elevation: 10,
            shadowColor: Colors.yellow,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: imageWidget,
            ),
          ),
        ),
      ),
    );
  }

  String timeFormat(time) {
    return DateFormat('d MMM yyyy h:mm a').format(time);
  }
}
