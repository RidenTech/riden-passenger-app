// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Riden/config/constants.dart';

class AuthService {
  static Map<String, dynamic>? _decodeJsonBody(String body) {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(trimmedBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  // Login endpoint
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔵 Login Request:');
      print('Endpoint: ${ApiConstants.loginEndpoint}');
      print('Email: $email');

      final response = await http
          .post(
            Uri.parse(ApiConstants.loginEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(ApiConstants.connectTimeout);

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        final accessToken = data?['data']?['access_token'] ?? data?['token'];
        print('✅ Login Success. Token: ${accessToken?.substring(0, 20)}...');
        return {
          'success': true,
          'message': data?['message'] ?? 'Login successful',
          'data': data?['data'],
          'token': accessToken,
        };
      } else if (response.statusCode == 401) {
        print('❌ Invalid credentials');
        return {'success': false, 'message': 'Invalid email or password'};
      } else {
        print('❌ Login failed with status ${response.statusCode}');
        return {'success': false, 'message': 'Login failed. Please try again.'};
      }
    } catch (e) {
      print('🔴 Login Exception: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Register endpoint
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
  }) async {
    try {
      final requestBody = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
        'gender': gender,
      };

      print('🔵 Registration Request:');
      print('Endpoint: ${ApiConstants.registerEndpoint}');
      print('Body: $requestBody');

      final response = await http
          .post(
            Uri.parse(ApiConstants.registerEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(ApiConstants.connectTimeout);

      print('📊 Response Status: ${response.statusCode}');
      print('📋 Response Headers: ${response.headers}');
      print('📄 Response Body: ${response.body}');
      print('📏 Response Body Length: ${response.body.length}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        final accessToken = data?['data']?['access_token'] ?? data?['token'];
        return {
          'success': true,
          'message': data?['message'] ?? 'Registration successful',
          'data': data?['data'],
          'token': accessToken,
        };
      } else if (response.statusCode == 500) {
        print('❌ Server Error 500 - Backend Issue');
        print('💡 Check Laravel logs:');
        print('   storage/logs/laravel.log');
        return {
          'success': false,
          'message':
              'Server error. Contact support or check backend logs for details.',
        };
      } else if (response.statusCode == 422) {
        final error = _decodeJsonBody(response.body);
        final errorMessage =
            error?['message'] ??
            (error?['errors'] is Map && (error!['errors'] as Map).isNotEmpty
                ? (error['errors'] as Map).values
                      .expand((value) => value is List ? value : [value])
                      .map((value) => value.toString())
                      .join('\n')
                : 'Validation error');
        print('❌ Validation Error: $errorMessage');
        return {'success': false, 'message': errorMessage};
      } else {
        final error = _decodeJsonBody(response.body);
        final errorMessage =
            error?['message'] ??
            (error?['errors'] is Map && (error!['errors'] as Map).isNotEmpty
                ? (error['errors'] as Map).values
                      .expand((value) => value is List ? value : [value])
                      .map((value) => value.toString())
                      .join('\n')
                : null) ??
            'Registration failed (Status: ${response.statusCode})';
        print('❌ Error: $errorMessage');
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('🔴 Exception: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Logout endpoint
  static Future<Map<String, dynamic>> logout({required String token}) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.logoutEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Logged out successfully'};
      } else {
        return {'success': false, 'message': 'Logout failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Forgot Password endpoint
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      print('🔵 Forgot Password Request:');
      print('Endpoint: ${ApiConstants.forgotPasswordEndpoint}');
      print('Email: $email');

      final response = await http
          .post(
            Uri.parse(ApiConstants.forgotPasswordEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(ApiConstants.connectTimeout);

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        print('✅ Forgot Password Success');
        return {
          'success': true,
          'message':
              data?['message'] ??
              'Password reset link sent to your email. Check your inbox.',
          'data': data?['data'],
        };
      } else if (response.statusCode == 404) {
        print('❌ Email not found');
        return {'success': false, 'message': 'Email address not found'};
      } else if (response.statusCode == 422) {
        final error = _decodeJsonBody(response.body);
        final errorMessage =
            error?['message'] ??
            (error?['errors'] is Map && (error!['errors'] as Map).isNotEmpty
                ? (error['errors'] as Map).values
                      .expand((value) => value is List ? value : [value])
                      .map((value) => value.toString())
                      .join('\n')
                : 'Validation error');
        print('❌ Validation Error: $errorMessage');
        return {'success': false, 'message': errorMessage};
      } else if (response.statusCode == 500) {
        print('❌ Server Error 500');
        return {
          'success': false,
          'message': 'Server error. Please try again later.',
        };
      } else {
        print('❌ Failed with status ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to process request. Please try again.',
        };
      }
    } catch (e) {
      print('🔴 Exception: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}