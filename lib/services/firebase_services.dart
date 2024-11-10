// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'; // For handling file names

import 'package:memorise/model/cat_model.dart';
import 'package:memorise/model/note_model.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/ui_components/custom_awesome_dialog.dart';
import 'package:memorise/ui_components/ui_helper.dart';

class LoginServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomAwesomeDialog awesomeDialog = CustomAwesomeDialog();

  Future<UserCredential?> signInWithEandP(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      awesomeDialog.showDialog(context, 'reset_password'.tr, 'reset_link'.tr,
          DialogType.success, false, null);
    } catch (e) {
      if (e.toString().contains('user-not-found')) {
        awesomeDialog.showDialog(context, 'error'.tr,
            'no_user_found_for_that_email'.tr, DialogType.error, false, null);
      }
    }
  }

  Future signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().onError((e, s) {
      return awesomeDialog.showDialog(
          context, 'error'.tr, e.toString(), DialogType.error, false, null);
    });

    //Stop if the user dismissed the login proccess
    if (googleUser == null) {
      Get.back();
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);

    // If email doesn't exist, save it.
    if (!await doesEmailExist(googleUser.email)) {
      debugPrint('============\n${_auth.currentUser!.uid}\n=================');
      RegisterServices().saveUser(
          _auth.currentUser!.uid, googleUser.displayName!, googleUser.email);
    }

    Get.back();
    return true;
  }

  Future<bool> doesEmailExist(String email) async {
    try {
      // Query the users collection for the email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Check if any documents were found
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that occur during the query
      UiHelper.getSnackBar('error'.tr, e.toString());
      return false; // Or handle it as needed
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class RegisterServices {
  final CustomAwesomeDialog awesomeDialog = CustomAwesomeDialog();

  Future registerUser(context, email, pass, name) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      saveUser(FirebaseAuth.instance.currentUser!.uid, name, email);

      Get.back();
      awesomeDialog.showDialog(context, 'verification_required'.tr,
          'verification_msg'.tr, DialogType.info, true, () {
        Get.back();
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'weak-password') {
        awesomeDialog.showDialog(
          context,
          'warning'.tr,
          'password_is_weak'.tr,
          DialogType.error,
          false,
          null,
        );
      } else if (e.code == 'email-already-in-use') {
        awesomeDialog.showDialog(
          context,
          'error'.tr,
          'account_exists'.tr,
          DialogType.error,
          false,
          null,
        );
      }
    } catch (e) {
      Get.back();
      awesomeDialog.showDialog(context, 'unknown_error'.tr, e.toString(),
          DialogType.error, false, null);
    }
  }

  saveUser(String uId, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').doc().set(
      {
        'name': name,
        'email': email,
        'uId': uId,
      },
    ).then(
      (_) {
        UiHelper.getSnackBar('success'.tr, 'user_saved_successfully'.tr);
      },
      onError: (e) {
        UiHelper.getSnackBar('error'.tr, 'error_adding_the_user'.tr);
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class CategoryServices {
  final db = FirebaseFirestore.instance;
  String uId = FirebaseAuth.instance.currentUser!.uid;
  late List<String> docs = [];

  Stream<List<CategoryModel>> catStream() {
    return db
        .collection('categories')
        .where('uId', isEqualTo: uId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<CategoryModel> cats = [];
      docs.clear();
      for (var element in query.docs) {
        cats.add(CategoryModel.fromFirestore(element));
        docs.add(element.id);
      }
      return cats;
    });
  }

  Future<String> getName() async {
    return await db
        .collection('users')
        .where('uId', isEqualTo: uId)
        .get()
        .then((data) {
      String name = data.docs.first['name'];
      name = name.substring(0, name.indexOf(' '));
      return name;
    });
  }

  List<String> docIds() {
    return docs;
  }

  Future<void> addCategory(String categoryName) async {
    await db.collection('categories').doc().set(
      {
        'catName': categoryName.trim(),
        'uId': uId,
        'time': Timestamp.now(),
      },
    ).then(
      (_) {
        Get.back();
        UiHelper.getSnackBar('success'.tr, 'category_added_successfully'.tr);
      },
      onError: (e) {
        Get.back();
        UiHelper.getSnackBar('error'.tr, 'error_adding_the_category'.tr);
      },
    );
  }

  Future<void> editCategory(String docId, String categoryName) async {
    await db.collection('categories').doc(docId).update(
      {
        'catName': categoryName,
      },
    ).then(
      (_) {
        Get.back();
        UiHelper.getSnackBar('success'.tr, 'category_updated_successfully'.tr);
      },
      onError: (e) {
        Get.back();
        UiHelper.getSnackBar('error'.tr, 'error_updating_the_category'.tr);
      },
    );
  }

  Future<void> deleteCategory(String docId) async {
    UiHelper.showLoadingDialog('loading...'.tr);
    await db.collection('categories').doc(docId).delete().then(
      (_) {
        Get.back();
        deleteImages(docId);
      },
      onError: (e) {
        Get.back();
        UiHelper.getSnackBar('error'.tr, 'error_deleting_the_category'.tr);
      },
    );
  }
}

Future<void> deleteImages(catId) async {
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  ValueNotifier<double> deleteProgress = ValueNotifier<double>(0.0);

  FirebaseStorage storage = FirebaseStorage.instance;
  ListResult result = await storage.ref('images').listAll();
  List<Reference> matchingFiles =
      result.items.where((file) => file.name.contains(catId)).toList();

  if (matchingFiles.isEmpty) {
    UiHelper.getSnackBar('success'.tr, 'category_deleted_successfully'.tr);
    return;
  }

  // Show the dialog for deletion progress
  NoteServices.showProgressDialog(
      currentIndex, matchingFiles.length, deleteProgress, true);

  for (int i = 0; i < matchingFiles.length; i++) {
    currentIndex.value = i;
    Reference fileRef = matchingFiles[i];

    try {
      await fileRef.delete();
      deleteProgress.value = (i + 1) / matchingFiles.length;
    } catch (e) {
      UiHelper.getSnackBar('error'.tr, e.toString());
    }
  }

  // Close the dialog after all images are deleted
  Get.back();
  Get.back(canPop: true);
  UiHelper.getSnackBar('success'.tr, 'category_deleted_successfully'.tr);
}

////////////////////////////////////////////////////////////////////////////////

class NoteServices {
  final db = FirebaseFirestore.instance;
  final String catDocId;
  late List<String> docs = [];
  String uId = FirebaseAuth.instance.currentUser!.uid;
  NoteServices({
    required this.catDocId,
  });

  Stream<List<NoteModel>> noteStream() {
    return db
        .collection('categories')
        .doc(catDocId)
        .collection('notes')
        .orderBy('time', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<NoteModel> notes = [];
      docs.clear();
      for (var element in query.docs) {
        notes.add(NoteModel.fromFirestore(element));
        docs.add(element.id);
      }
      return notes;
    });
  }

  List<String> docsIds() {
    return docs;
  }

  Future<void> deleteImages(isEditing, urls, catDocId, noteDocId) async {
    ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
    ValueNotifier<double> deleteProgress = ValueNotifier<double>(0.0);

    // Show the dialog for deletion progress
    showProgressDialog(currentIndex, urls.length, deleteProgress, true);

    for (int i = 0; i < urls.length; i++) {
      currentIndex.value = i;
      String url = urls[i];
      Reference storageRef = FirebaseStorage.instance.refFromURL(url);

      try {
        await storageRef.delete();
        deleteProgress.value = (i + 1) / urls.length;
      } catch (e) {
        UiHelper.getSnackBar('error'.tr, e.toString());
      }
    }
    // Close the dialog after all images are deleted
    Get.back();
    UiHelper.getSnackBar('success'.tr, 'note_updated_successfully'.tr);

    if (!isEditing) {
      deleteNote(catDocId, noteDocId);
    }
  }

  deleteNote(catDocId, noteDocId) {
    db
        .collection('categories')
        .doc(catDocId)
        .collection('notes')
        .doc(noteDocId)
        .delete()
        .then(
      (onValue) {
        UiHelper.getSnackBar('success'.tr, 'note_deleted_successfully'.tr);
      },
      onError: (e) {
        UiHelper.getSnackBar('error'.tr, 'error_deleting_note'.tr);
      },
    );
  }

  String? addNotes(
      {required String catDocId,
      required Map<String, dynamic> data,
      showSnack}) {
    DocumentReference docRef =
        db.collection('categories').doc(catDocId).collection('notes').doc();

    docRef.set(data).onError(
      (e, _) {
        UiHelper.getSnackBar('error'.tr, 'error_adding_the_note'.tr);
      },
    ).then((onValue) {
      if (showSnack) {
        UiHelper.getSnackBar('success'.tr, 'success_adding_the_note'.tr);
      }
    });

    if (docRef.id.isNotEmpty) {
      return docRef.id;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> uploadImages(files, catDocId, noteDocId) async {
    List<String> downloadUrls = [];
    ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
    ValueNotifier<double> uploadProgress = ValueNotifier<double>(0.0);

    showProgressDialog(currentIndex, files.length, uploadProgress, false);

    for (int i = 0; i < files.length; i++) {
      currentIndex.value = i;
      XFile file = files[i];

      // Extract the file name from the path
      String fileName = basename(file.path);

      // Set the storage path
      // I'm storing uId and catDocId so, if the user deleted any main category,
      // those make me able to delete any images related to this category.
      String storagePath = 'images/${uId}_${catDocId}_${noteDocId}_$fileName';

      // Create a reference to the location to upload to
      Reference storageRef = FirebaseStorage.instance.ref().child(storagePath);

      try {
        // Start file upload with progress listener
        UploadTask uploadTask = storageRef.putFile(File(file.path));
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          uploadProgress.value =
              snapshot.bytesTransferred / snapshot.totalBytes;
        });

        await uploadTask;

        // Get the download URL of the uploaded file
        String downloadUrl = await storageRef.getDownloadURL();
        downloadUrls.add(downloadUrl); // Add the download URL to the list
      } catch (e) {
        UiHelper.getSnackBar('success'.tr, e.toString());
      }
    }

    Get.back();

    return downloadUrls; // Return the list of download URLs
  }

  Future<NoteModel?> getNote(String catDocId, String noteDocId) async {
    try {
      DocumentSnapshot doc = await db
          .collection('categories')
          .doc(catDocId)
          .collection('notes')
          .doc(noteDocId)
          .get();

      if (doc.exists) {
        return NoteModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      UiHelper.getSnackBar('error'.tr, '$e');
      return null;
    }
  }

  updateUrlsList(urls, String catDocId, String noteDocId) async {
    db
        .collection('categories')
        .doc(catDocId)
        .collection('notes')
        .doc(noteDocId)
        .update({'urls': FieldValue.arrayRemove(urls)}).then((onValue) {
      deleteImages(true, urls, catDocId, noteDocId);
    }, onError: (e) {
      UiHelper.getSnackBar('error'.tr, 'error_updating_note'.tr);
    });
    //////////////////////////////////////////////////////////////////////////
  }

  editNote(catDocId, noteDocId, data) {
    // If there are new images, use FieldValue.arrayUnion
    //to add them to the existing 'urls' array
    if (data['urls'] != null) {
      data['urls'] = FieldValue.arrayUnion(data['urls']);
    }

    db
        .collection('categories')
        .doc(catDocId)
        .collection('notes')
        .doc(noteDocId)
        .update(data)
        .then((onValue) {
      UiHelper.getSnackBar('success'.tr, 'note_updated_successfully'.tr);
    }, onError: (e) {
      UiHelper.getSnackBar('error'.tr, 'error_updating_note'.tr);
    });
  }

  static showProgressDialog(currentIndex, filesCount, progress, isDeleting) {
    return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: MemoRiseColors().mainBlue,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Center(
                  child: Text(isDeleting ? 'deleting'.tr : 'uploading'.tr,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18))),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: currentIndex,
                    builder: (context, index, child) {
                      return isDeleting
                          ? Text(
                              '${'Deleting image'.tr} ${index + 1} ${'of'.tr} $filesCount',
                              style: const TextStyle(fontSize: 16))
                          : Text(
                              '${'Uploading image'.tr} ${index + 1} ${'of'.tr} $filesCount',
                              style: const TextStyle(fontSize: 16));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<double>(
                      valueListenable: progress,
                      builder: (context, progress, child) {
                        return Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 5,
                                color: MemoRiseColors().mainBlue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Text('  ${(progress * 100).toInt()}%')
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
