import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// ✅ PROFILE SIDEBAR CONTROLLER
class ProfileSidebarController extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  void toggleLight() {
    isDarkMode.value = false;
  }

  void toggleDark() {
    isDarkMode.value = true;
  }
}

// ✅ PROFILE SETTINGS CONTROLLER
class ProfileSettingsController extends GetxController {
  RxBool isEditHovered = false.obs;

  void setEditHovered(bool value) {
    isEditHovered.value = value;
  }

  void editProfileTap() {
    setEditHovered(true);
  }

  void editProfileRelease() {
    setEditHovered(false);
  }

  void editProfileCancel() {
    setEditHovered(false);
  }
}

// ✅ EDIT PROFILE CONTROLLER
class EditProfileController extends GetxController {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  RxString selectedGender = 'Male'.obs;
  RxBool isUpdatePressed = false.obs;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController(text: 'Jesse Showalter');
    emailController = TextEditingController(text: 'example@gmail.com');
    phoneController = TextEditingController(text: '4563728937');
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setUpdatePressed(bool value) {
    isUpdatePressed.value = value;
  }

  void updateProfile() {
    // Update logic here
    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      backgroundColor: Color(0xFFEA4242),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1200),
    );
  }

  void showNameEditDialog() {
    Get.dialog(NameEditRequestDialog(), barrierDismissible: false);
  }
}

// ✅ NAME EDIT REQUEST DIALOG CONTROLLER
class NameEditDialogController extends GetxController {
  RxBool isSendPressed = false.obs;
  RxBool isCancelPressed = false.obs;

  void setSendPressed(bool value) {
    isSendPressed.value = value;
  }

  void setCancelPressed(bool value) {
    isCancelPressed.value = value;
  }

  void sendRequest() {
    Get.back();
    Get.snackbar(
      'Success',
      'Name edit request sent to support',
      backgroundColor: Color(0xFFEA4242),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1000),
    );
  }

  void cancelRequest() {
    Get.back();
  }
}

// ✅ NAME EDIT REQUEST DIALOG
class NameEditRequestDialog extends StatelessWidget {
  const NameEditRequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NameEditDialogController());

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Name Edit Request',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),

            SizedBox(height: 16),

            // Description
            Text(
              'If you want to change your name,\nyou will need to send an edit\nrequest to support.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
                height: 1.6,
              ),
            ),

            SizedBox(height: 28),

            // Send Request Button
            Obx(
              () => GestureDetector(
                onTapDown: (_) {
                  controller.setSendPressed(true);
                },
                onTapUp: (_) {
                  controller.setSendPressed(false);
                  controller.sendRequest();
                },
                onTapCancel: () {
                  controller.setSendPressed(false);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 150),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: controller.isSendPressed.value
                        ? Color(0xFFEA4242).withOpacity(0.85)
                        : Color(0xFFEA4242),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEA4242).withOpacity(
                          controller.isSendPressed.value ? 0.5 : 0.3,
                        ),
                        blurRadius: controller.isSendPressed.value ? 15 : 10,
                        offset: Offset(
                          0,
                          controller.isSendPressed.value ? 8 : 4,
                        ),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Send Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            // Cancel Button
            Obx(
              () => GestureDetector(
                onTapDown: (_) {
                  controller.setCancelPressed(true);
                },
                onTapUp: (_) {
                  controller.setCancelPressed(false);
                  controller.cancelRequest();
                },
                onTapCancel: () {
                  controller.setCancelPressed(false);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 150),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: controller.isCancelPressed.value
                        ? Colors.white.withOpacity(0.15)
                        : Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: controller.isCancelPressed.value
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
