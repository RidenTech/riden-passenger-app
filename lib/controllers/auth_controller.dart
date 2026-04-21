import 'package:get/get.dart';
import 'package:Riden/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userToken = ''.obs;
  var userEmail = ''.obs;
  var userFirstName = ''.obs;
  var userLastName = ''.obs;
  var userFullName = ''.obs;
  var userPhone = ''.obs;
  var userGender = ''.obs;
  var userCountryCode = '+92'.obs;

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializePreferencesAsync();
  }

  /// Initialize SharedPreferences asynchronously
  Future<void> _initializePreferencesAsync() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      // Load saved user data if exists
      await loadSavedUserData();
      _isInitialized = true;
      print('✅ AuthController fully initialized with SharedPreferences');
    } catch (e) {
      print('❌ Error initializing AuthController: $e');
    }
  }

  /// Ensure initialization is complete before using data
  Future<void> ensureInitialized() async {
    int attempts = 0;
    while (!_isInitialized && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
    if (!_isInitialized) {
      print(
        '⚠️ AuthController initialization timeout - attempting to load data anyway',
      );
      try {
        _prefs = await SharedPreferences.getInstance();
        await loadSavedUserData();
      } catch (e) {
        print('❌ Error in timeout recovery: $e');
      }
    }
  }

  /// Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    try {
      await _prefs.setString('userEmail', userEmail.value);
      await _prefs.setString('userToken', userToken.value);
      await _prefs.setString('userFirstName', userFirstName.value);
      await _prefs.setString('userLastName', userLastName.value);
      await _prefs.setString('userFullName', userFullName.value);
      await _prefs.setString('userPhone', userPhone.value);
      await _prefs.setString('userGender', userGender.value);
      await _prefs.setString('userCountryCode', userCountryCode.value);
      await _prefs.setBool('isLoggedIn', true);
      print('✅ User data saved to SharedPreferences');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  /// Load user data from SharedPreferences
  Future<void> loadSavedUserData() async {
    try {
      userEmail.value = _prefs.getString('userEmail') ?? '';
      userToken.value = _prefs.getString('userToken') ?? '';
      userFirstName.value = _prefs.getString('userFirstName') ?? '';
      userLastName.value = _prefs.getString('userLastName') ?? '';
      userFullName.value = _prefs.getString('userFullName') ?? '';
      userPhone.value = _prefs.getString('userPhone') ?? '';
      userGender.value = _prefs.getString('userGender') ?? '';
      userCountryCode.value = _prefs.getString('userCountryCode') ?? '+92';

      bool savedLoginState = _prefs.getBool('isLoggedIn') ?? false;

      // Debug: Print all values loaded
      print('📦 SharedPreferences Values:');
      print('   userEmail: "${userEmail.value}"');
      print('   userFirstName: "${userFirstName.value}"');
      print('   userLastName: "${userLastName.value}"');
      print('   userFullName: "${userFullName.value}"');
      print('   userPhone: "${userPhone.value}"');
      print('   userGender: "${userGender.value}"');
      print('   isLoggedIn: $savedLoginState');

      if (savedLoginState && userEmail.value.isNotEmpty) {
        isLoggedIn.value = true;
        print(
          '✅ User data loaded from SharedPreferences: ${userFullName.value}',
        );
      } else {
        print('⚠️ No valid login state found in SharedPreferences');
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  /// Check if user is already logged in
  Future<bool> isUserLoggedIn() async {
    await loadSavedUserData();
    return isLoggedIn.value;
  }

  /// Clear user data from SharedPreferences
  Future<void> _clearUserData() async {
    try {
      await _prefs.remove('userEmail');
      await _prefs.remove('userToken');
      await _prefs.remove('userFirstName');
      await _prefs.remove('userLastName');
      await _prefs.remove('userFullName');
      await _prefs.remove('userPhone');
      await _prefs.remove('userGender');
      await _prefs.remove('userCountryCode');
      await _prefs.setBool('isLoggedIn', false);
      print('✅ User data cleared from SharedPreferences');
    } catch (e) {
      print('❌ Error clearing user data: $e');
    }
  }

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

        // Try to get user name from response data
        final userData = result['data'] as Map<String, dynamic>?;
        String firstName = '';
        String lastName = '';

        if (userData != null) {
          // Backend returns data.user object
          final userObject = userData['user'] as Map<String, dynamic>?;

          if (userObject != null) {
            firstName = userObject['first_name']?.toString() ?? '';
            lastName = userObject['last_name']?.toString() ?? '';
            print(
              '🔍 Extracted from data.user: firstName="$firstName", lastName="$lastName"',
            );
          }

          // Fallback to direct fields if no user object
          if (firstName.isEmpty && lastName.isEmpty) {
            firstName =
                userData['first_name']?.toString() ??
                userData['firstName']?.toString() ??
                userData['name']?.toString() ??
                '';
            lastName =
                userData['last_name']?.toString() ??
                userData['lastName']?.toString() ??
                '';
            print(
              '🔍 Extracted from direct fields: firstName="$firstName", lastName="$lastName"',
            );
          }
        }

        // If name is not in response, try to recover from SharedPreferences (from previous registration)
        if (firstName.isEmpty && lastName.isEmpty) {
          print(
            '⚠️ Backend did not return name. Checking SharedPreferences for recovery...',
          );
          final savedFirstName = _prefs.getString('userFirstName') ?? '';
          final savedLastName = _prefs.getString('userLastName') ?? '';

          // If we have saved names, use them
          if (savedFirstName.isNotEmpty || savedLastName.isNotEmpty) {
            firstName = savedFirstName;
            lastName = savedLastName;
            print(
              '✅ Recovered name from SharedPreferences: $firstName $lastName',
            );
          } else {
            // Fallback: use email prefix as display name
            final emailPrefix = email.split('@')[0];
            firstName =
                emailPrefix.replaceAll(RegExp(r'[._-]'), ' ').capitalize ?? '';
            lastName = '';
            print('✅ Using email prefix as name: $firstName');
          }
        }

        userFirstName.value = firstName;
        userLastName.value = lastName;
        userFullName.value = '$firstName $lastName'.trim();

        print('👤 User Logged In Successfully:');
        print('   Email: $email');
        print('   First Name: "$firstName"');
        print('   Last Name: "$lastName"');
        print('   Full Name: "${userFullName.value}"');
        print('   ✅ Names properly extracted from backend');

        // Save user data to SharedPreferences
        await _saveUserData();

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
        userPhone.value = phone;
        userGender.value = gender;

        // Extract country code from phone if available
        // Assume format is like: +92 followed by number
        if (phone.startsWith('+')) {
          // Extract country code (e.g., +92 from +923001234567)
          int spaceIndex = phone.indexOf(' ');
          if (spaceIndex != -1) {
            userCountryCode.value = phone.substring(0, spaceIndex);
          } else {
            // If no space, try to find where digits start
            int digitIndex = 0;
            for (int i = 1; i < phone.length; i++) {
              if (!phone[i].contains(RegExp(r'[0-9]'))) {
                digitIndex = i;
              } else if (digitIndex > 0) {
                userCountryCode.value = phone.substring(0, digitIndex);
                break;
              }
            }
          }
        }

        // Store token if backend returns one
        if (result['token'] != null) {
          userToken.value = result['token'];
        }

        // Save user data to SharedPreferences
        await _saveUserData();

        print('👤 User Registered Successfully:');
        print('   Email: $userEmail');
        print('   First Name: $userFirstName');
        print('   Last Name: $userLastName');
        print('   Full Name: $userFullName');
        print('   Phone: $userPhone');
        print('   Country Code: $userCountryCode');
        print('   Gender: $userGender');

        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      print('🔴 Register Error: $e');
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
      userPhone.value = '';
      userGender.value = '';
      userCountryCode.value = '+92';

      // Clear user data from SharedPreferences
      await _clearUserData();

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

  /// Diagnostic method to check what's saved in SharedPreferences
  Future<void> debugPrintSharedPreferences() async {
    try {
      print('\n🔍 ===== SharedPreferences Debug Info =====');
      print('All keys in SharedPreferences:');
      final keys = _prefs.getKeys();
      for (var key in keys) {
        final value = _prefs.get(key);
        print('  $key: $value');
      }
      print('Current Controller Values:');
      print('  userEmail: ${userEmail.value}');
      print('  userFirstName: ${userFirstName.value}');
      print('  userLastName: ${userLastName.value}');
      print('  userFullName: ${userFullName.value}');
      print('  userPhone: ${userPhone.value}');
      print('  userGender: ${userGender.value}');
      print('  userCountryCode: ${userCountryCode.value}');
      print('  isLoggedIn: ${isLoggedIn.value}');
      print('=====================================\n');
    } catch (e) {
      print('❌ Error debugging SharedPreferences: $e');
    }
  }

  /// Force reload user data from SharedPreferences
  Future<void> forceReloadUserData() async {
    print('🔄 Force reloading user data from SharedPreferences...');
    await loadSavedUserData();
    await debugPrintSharedPreferences();
  }
}
