// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:name_bar_animation/searchbar_animation.dart';

import 'package:memorise/controllers/categories_controller.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/ui_components/category_card.dart';
import 'package:memorise/ui_components/custom_back_button.dart';
import 'package:memorise/ui_components/custom_material_button.dart';
import 'package:memorise/ui_components/custom_text_form_field.dart';
import 'package:memorise/ui_components/ui_helper.dart';

class Category extends StatelessWidget {
  Category({super.key});

  final CategoriesController categoryController =
      Get.put(CategoriesController());
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  late SearchBarAnimation searchBar;
  late Timer expandTimer;

  void startAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expandTimer = Timer(const Duration(seconds: 1), () {
        if (Get.isRegistered<CategoriesController>()) {
          searchBar.expand();
        }
      });
      expandTimer = Timer(const Duration(seconds: 10), () {
        if (Get.isRegistered<CategoriesController>()) {
          searchBar.expand();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MemoRiseColors().changeStatusColor();
    //
    startAnimation();
    //
    return Scaffold(
      //
      floatingActionButton: FloatingActionButton(
          onPressed: () => showAddDialog(context, false, '', ''),
          backgroundColor: MemoRiseColors().mainBlue,
          child: const Icon(Icons.add, color: Colors.white)),
      //
      body: SafeArea(
        child: Column(
          children: [
            //
            header(context),
            //
            Obx(
              () {
                if (categoryController.allCategories.isEmpty) {
                  return noCategories(context);
                }

                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 150,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: categoryController.allCategories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        categoryController.docIds[index],
                        categoryController.allCategories[index].catName,
                        categoryController.allCategories[index].time,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget header(context) {
    return Card(
      elevation: 10,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 17.5),
            child: Center(
              child: Text(
                'MemoRise',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: MemoRiseColors().mainBlue),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //
              Expanded(child: animatedNameWidget()),
              //
              Padding(
                padding: const EdgeInsets.only(right: 4.0, bottom: 4),
                child: CustomBackButton(
                  onPressed: () {
                    expandTimer.cancel();
                    logoutDialog(context, () {
                      categoryController.signOut();
                    });
                  },
                  icon: Icons.exit_to_app_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget animatedNameWidget() {
    // Initialize the SearchBarAnimation widget
    searchBar = SearchBarAnimation(
      buttonElevation: 10,
      textEditingController: nameController,
      isOriginalAnimation: true,
      buttonBorderColour: MemoRiseColors().mainBlue,
      enteredTextStyle: TextStyle(
          color: MemoRiseColors().mainBlue,
          fontSize: 18,
          fontWeight: FontWeight.bold),
      buttonWidget: Icon(
        Icons.person,
        color: MemoRiseColors().mainBlue,
      ),
      trailingWidget: const SizedBox(
        width: 50,
        height: 50,
      ),
      secondaryButtonWidget: Icon(
        Icons.favorite,
        color: MemoRiseColors().mainBlue,
      ),
      enableKeyboardFocus: false,
      durationInMilliSeconds: 5000,
      textAlignToRight: false,
      searchBoxBorderColour: MemoRiseColors().mainBlue,
      enableBoxBorder: true,
    );

    // Return the SearchBarAnimation instance within a Padding widget
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 8.0, bottom: 4.0, right: 8),
      child: Obx(() {
        // Update text controller here if needed
        nameController.text = 'Welcome ${categoryController.userName.value}';
        return searchBar;
      }),
    );
  }

  Widget noCategories(context) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: () => showAddDialog(context, false, '', ''),
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

  void showAddDialog(
      BuildContext context, bool isEdit, String docId, String categoryName) {
    if (isEdit) categoryNameController.text = categoryName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: MemoRiseColors().mainBlue,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(
                      isEdit ? 'edit_category'.tr : 'add_new_category'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                          controller: categoryNameController,
                          hint: isEdit ? categoryName : 'ex_home_needs'.tr,
                          label: 'category_name'.tr,
                          keyboardType: TextInputType.text),
                      //
                      const SizedBox(height: 6.0),
                      //
                      CustomMaterialButton(
                        height: 40,
                        fontSize: 16,
                        text: isEdit ? 'edit_with_space'.tr : 'add'.tr,
                        onPressed: () {
                          if (categoryNameController.text == '') {
                            UiHelper.getSnackBar(
                                'error'.tr, 'enter_cat_name_first'.tr);
                            return;
                          }

                          Get.back(); //to dismiss AddDialog.
                          UiHelper.showLoadingDialog('loading...'.tr);

                          isEdit
                              ? categoryController.editCategory(
                                  docId, categoryNameController.text.trim())
                              : categoryController.addCategory(
                                  categoryNameController.text.trim(),
                                );
                          categoryNameController.clear();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  logoutDialog(context, void Function()? logout) {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'logout'.tr,
      dismissOnTouchOutside: false,
      desc: 'r_u_sure?'.tr,
      btnOkText: 'logout'.tr,
      btnOkOnPress: logout,
      btnCancelText: 'cancel'.tr,
      btnCancelOnPress: () {
        dialog.dismiss();
      },
    );
    dialog.show();
  }
}
