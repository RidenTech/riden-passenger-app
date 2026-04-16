import 'package:get/get.dart';
import 'package:Riden/models/passenger.dart';
import 'package:Riden/services/passenger_service.dart';

class PassengerController extends GetxController {
  var passengers = <Passenger>[].obs;
  var isLoading = false.obs;
  var selectedPassenger = Rxn<Passenger>();
  var totalPassengers = 0.obs;
  var currentPage = 1.obs;

  // This should be set after login (get it from AuthController)
  late String authToken;

  // Set auth token
  void setAuthToken(String token) {
    authToken = token;
  }

  // Get all passengers
  Future<void> fetchPassengers({int page = 1}) async {
    try {
      isLoading.value = true;
      final result = await PassengerService.getPassengers(
        token: authToken,
        page: page,
      );

      if (result['success']) {
        passengers.value = result['passengers'];
        totalPassengers.value = result['total'] ?? 0;
        currentPage.value = page;
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch passengers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get single passenger
  Future<void> fetchPassenger(int passengerId) async {
    try {
      isLoading.value = true;
      final result = await PassengerService.getPassenger(
        token: authToken,
        passengerId: passengerId,
      );

      if (result['success']) {
        selectedPassenger.value = result['passenger'];
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch passenger: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Create passenger
  Future<bool> createPassenger({
    required Passenger passenger,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final result = await PassengerService.createPassenger(
        token: authToken,
        passenger: passenger,
        password: password,
      );

      if (result['success']) {
        passengers.add(result['passenger']);
        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create passenger: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update passenger
  Future<bool> updatePassenger({
    required int passengerId,
    required Passenger passenger,
    String? password,
  }) async {
    try {
      isLoading.value = true;
      final result = await PassengerService.updatePassenger(
        token: authToken,
        passengerId: passengerId,
        passenger: passenger,
        password: password,
      );

      if (result['success']) {
        final index = passengers.indexWhere((p) => p.id == passengerId);
        if (index != -1) {
          passengers[index] = result['passenger'];
        }
        selectedPassenger.value = result['passenger'];
        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update passenger: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete passenger
  Future<bool> deletePassenger(int passengerId) async {
    try {
      isLoading.value = true;
      final result = await PassengerService.deletePassenger(
        token: authToken,
        passengerId: passengerId,
      );

      if (result['success']) {
        passengers.removeWhere((p) => p.id == passengerId);
        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete passenger: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle passenger status
  Future<bool> togglePassengerStatus(int passengerId) async {
    try {
      isLoading.value = true;
      final result = await PassengerService.toggleStatus(
        token: authToken,
        passengerId: passengerId,
      );

      if (result['success']) {
        final index = passengers.indexWhere((p) => p.id == passengerId);
        if (index != -1) {
          passengers[index] = result['passenger'];
        }
        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar('Error', result['message']);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle status: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}