import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memorise/model/cat_model.dart';
import 'package:memorise/services/firebase_services.dart';
import 'package:memorise/view/category/category.dart';

class CategoriesController extends GetxController {
  final allCategories = <CategoryModel>[].obs;
  CategoryServices categoryServices = CategoryServices();
  late RxList<String> docIds = <String>[].obs;
  var userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    allCategories.bindStream(categoryServices.catStream());
    docIds.value = categoryServices.docIds();
    getUserName();
  }

  void getUserName() async => userName.value = await categoryServices.getName();
  //
  void addCategory(String categoryName) =>
      categoryServices.addCategory(categoryName);
  //
  void editCategory(String docId, String categoryName) =>
      categoryServices.editCategory(docId, categoryName);
  //
  void deleteCategory(String docId) => categoryServices.deleteCategory(docId);
  //
  signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.disconnect();
    }
    await FirebaseAuth.instance.signOut();
    Get.offNamed('/login');
  }

  @override
  void onClose() {
    super.onClose();
    Category category = Category();
    category.categoryNameController.dispose();
    category.nameController.dispose();
  }
}
