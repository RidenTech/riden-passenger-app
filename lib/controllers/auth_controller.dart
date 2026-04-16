import 'package:get/get.dart';
import 'package:Riden/services/auth_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userToken = ''.obs;
  var userEmail = ''.obs;
  var userFirstName = ''.obs;
  var userLastName = ''.obs;
  var userFullName = ''.obs;

  // Login method
  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      final result = await AuthService.login(email: email, password: password);

      if (result['success']) {
        isLoggedIn.value = true;
        userEmail.value = email;

        // Store token if backend returns one
        if (result['token'] != null) {
          userToken.value = result['token'];
        }

        // Store user name from response data - handle both snake_case and camelCase
        final userData = result['data'] as Map<String, dynamic>?;
        if (userData != null) {
          // Try multiple field name variations
          String firstName =
              userData['first_name']?.toString() ??
              userData['firstName']?.toString() ??
              userData['name']?.toString() ??
              '';

          String lastName =
              userData['last_name']?.toString() ??
              userData['lastName']?.toString() ??
              '';

          userFirstName.value = firstName;
          userLastName.value = lastName;
          userFullName.value = '$firstName $lastName'.trim();

          print('👤 User Data Retrieved:');
          print('   First Name: $firstName');
          print('   Last Name: $lastName');
          print('   Full Name: ${userFullName.value}');
          print('   Raw userData: $userData');
        } else {
          print('⚠️ No userData found in response. Setting name to User.');
          userFirstName.value = 'User';
          userLastName.value = '';
          userFullName.value = 'User';
        }

        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      print('🔴 Login Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Register method
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
  }) async {
    try {
      isLoading.value = true;
      final result = await AuthService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        gender: gender,
      );

      if (result['success']) {
        isLoggedIn.value = true;
        userEmail.value = email;
        userFirstName.value = firstName;
        userLastName.value = lastName;
        userFullName.value = '$firstName $lastName';

        // Store token if backend returns one
        if (result['token'] != null) {
          userToken.value = result['token'];
        }
        print('👤 User Registered: $userFullName');
        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      isLoading.value = true;
      final result = await AuthService.logout(token: userToken.value);

      isLoggedIn.value = false;
      userToken.value = '';
      userEmail.value = '';
      userFirstName.value = '';
      userLastName.value = '';
      userFullName.value = '';
      Get.snackbar('Success', result['message']);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot password
  Future<bool> forgotPassword({required String email}) async {
    try {
      isLoading.value = true;
      final result = await AuthService.forgotPassword(email: email);

      if (result['success']) {
        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}