import 'package:get/get.dart';

import '/data/repositories/users/user_repository.dart';
import '/features/authentication/models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final isLoading = false.obs;
  final _userRepositories = Get.put(UserRepository());

  Rx<UserModel> user = UserModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      final fetchedUser = await _userRepositories.getUser();
      user.value = fetchedUser; // Update the user observable
    } catch (e) {
      // Handle errors appropriately (e.g., show a snackbar)
      print('Error fetching user: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
