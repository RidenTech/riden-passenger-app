import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Riden/config/constants.dart';
import 'package:Riden/models/passenger.dart';

class PassengerService {
  // Get all passengers with pagination
  static Future<Map<String, dynamic>> getPassengers({
    required String token,
    int page = 1,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.passengerListEndpoint}?page=$page'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final passengers =
            (data['data'] as List?)
                ?.map((p) => Passenger.fromJson(p))
                .toList() ??
            [];

        return {
          'success': true,
          'passengers': passengers,
          'total': data['total'] ?? 0,
          'currentPage': data['current_page'] ?? page,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch passengers',
          'passengers': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
        'passengers': [],
      };
    }
  }

  // Get single passenger by ID
  static Future<Map<String, dynamic>> getPassenger({
    required String token,
    required int passengerId,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.getPassengerEndpoint}/$passengerId'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final passenger = Passenger.fromJson(data['data']);

        return {'success': true, 'passenger': passenger};
      } else {
        return {'success': false, 'message': 'Passenger not found'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Create new passenger
  static Future<Map<String, dynamic>> createPassenger({
    required String token,
    required Passenger passenger,
    required String password,
  }) async {
    try {
      final body = {
        'first_name': passenger.firstName,
        'last_name': passenger.lastName,
        'email': passenger.email,
        'phone': passenger.phone,
        'gender': passenger.gender,
        'password': password,
        'password_confirmation': password, // Laravel requires confirmation
      };

      final response = await http
          .post(
            Uri.parse(ApiConstants.createPassengerEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Passenger created successfully',
          'passenger': Passenger.fromJson(data['data']),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to create passenger',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Update passenger
  static Future<Map<String, dynamic>> updatePassenger({
    required String token,
    required int passengerId,
    required Passenger passenger,
    String? password,
  }) async {
    try {
      final body = {
        'first_name': passenger.firstName,
        'last_name': passenger.lastName,
        'email': passenger.email,
        'phone': passenger.phone,
        'gender': passenger.gender,
        if (password != null && password.isNotEmpty) 'password': password,
      };

      final response = await http
          .put(
            Uri.parse('${ApiConstants.updatePassengerEndpoint}/$passengerId'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Passenger updated successfully',
          'passenger': Passenger.fromJson(data['data']),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to update passenger',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Delete passenger
  static Future<Map<String, dynamic>> deletePassenger({
    required String token,
    required int passengerId,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConstants.deletePassengerEndpoint}/$passengerId'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Passenger deleted successfully'};
      } else {
        return {'success': false, 'message': 'Failed to delete passenger'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Toggle passenger status (Block/Unblock)
  static Future<Map<String, dynamic>> toggleStatus({
    required String token,
    required int passengerId,
  }) async {
    try {
      final response = await http
          .patch(
            Uri.parse('${ApiConstants.toggleStatusEndpoint}/$passengerId'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Status updated successfully',
          'passenger': Passenger.fromJson(data['data']),
        };
      } else {
        return {'success': false, 'message': 'Failed to update status'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}