import 'package:get/get.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedNavIndex = Rx<int>(0);

  void setSelectedIndex(int index) {
    selectedNavIndex.value = index;
  }

  int getSelectedIndex() => selectedNavIndex.value;
}
