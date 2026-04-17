// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Riden/config/constants.dart';

class LocationSuggestion {
  final String placeId;
  final String mainText;
  final String secondaryText;
  final double? latitude;
  final double? longitude;

  LocationSuggestion({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    this.latitude,
    this.longitude,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      placeId: json['place_id'] ?? '',
      mainText: json['structured_formatting']?['main_text'] ?? '',
      secondaryText: json['structured_formatting']?['secondary_text'] ?? '',
    );
  }

  @override
  String toString() {
    return 'LocationSuggestion(placeId: $placeId, mainText: $mainText, secondaryText: $secondaryText)';
  }
}

class LocationSearchService {
  /// Search for places using Google Places API Autocomplete
  /// Returns a list of location suggestions based on the search query
  static Future<List<LocationSuggestion>> searchPlaces({
    required String query,
    String? sessionToken,
    double? latitude,
    double? longitude,
    int radiusMeters = 50000,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final String encodedQuery = Uri.encodeComponent(query);

      // Build location bias parameters
      String locationBias = '';
      if (latitude != null && longitude != null) {
        locationBias = '&location=$latitude,$longitude&radius=$radiusMeters';
      }

      // Construct API URL for Google Places Autocomplete
      final String url =
          '${ApiConstants.googlePlacesAutocompleteUrl}?'
          'input=$encodedQuery'
          '&key=${ApiConstants.googlePlacesApiKey}'
          '&components=country:pk'
          '&language=en'
          '$locationBias';

      if (sessionToken != null) {
        final String urlWithSession = '$url&sessionToken=$sessionToken';
        return await _performPlacesSearch(urlWithSession);
      }

      return await _performPlacesSearch(url);
    } catch (e) {
      print('❌ Error searching places: $e');
      return [];
    }
  }

  /// Private helper method to perform the actual API call
  static Future<List<LocationSuggestion>> _performPlacesSearch(
    String url,
  ) async {
    try {
      print('🌐 Fetching from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(ApiConstants.connectTimeout);

      print('📊 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'OK') {
          final predictions = json['predictions'] as List<dynamic>;

          final suggestions = predictions
              .map(
                (p) => LocationSuggestion.fromJson(p as Map<String, dynamic>),
              )
              .toList();

          print('✅ Found ${suggestions.length} suggestions for search');
          return suggestions;
        } else if (json['status'] == 'ZERO_RESULTS') {
          print('⚠️ No results found for search query');
          return [];
        } else {
          print('⚠️ API Status: ${json['status']}');
          print('Message: ${json['error_message']}');
          return [];
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('Body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Exception during places search: $e');
      return [];
    }
  }

  /// Get detailed information about a place (coordinates, address, etc.)
  /// using the placeId from a suggestion
  static Future<Map<String, dynamic>?> getPlaceDetails({
    required String placeId,
    String? sessionToken,
  }) async {
    try {
      final String url =
          '${ApiConstants.googlePlacesDetailsUrl}?'
          'place_id=$placeId'
          '&key=${ApiConstants.googlePlacesApiKey}'
          '&fields=geometry,formatted_address,address_components,name';

      if (sessionToken != null) {
        final String urlWithSession = '$url&sessionToken=$sessionToken';
        return await _performPlaceDetailsRequest(urlWithSession);
      }

      return await _performPlaceDetailsRequest(url);
    } catch (e) {
      print('❌ Error fetching place details: $e');
      return null;
    }
  }

  /// Private helper for place details request
  static Future<Map<String, dynamic>?> _performPlaceDetailsRequest(
    String url,
  ) async {
    try {
      print('🌐 Fetching place details from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(ApiConstants.connectTimeout);

      print('📊 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'OK') {
          final result = json['result'] as Map<String, dynamic>;
          print('✅ Place details fetched successfully');
          return result;
        } else {
          print('⚠️ API Status: ${json['status']}');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception during place details request: $e');
      return null;
    }
  }

  /// Extract coordinates from place details
  static Map<String, double>? extractCoordinates(
    Map<String, dynamic> placeDetails,
  ) {
    try {
      final geometry = placeDetails['geometry'] as Map<String, dynamic>?;
      final location = geometry?['location'] as Map<String, dynamic>?;

      if (location != null) {
        return {
          'latitude': (location['lat'] as num).toDouble(),
          'longitude': (location['lng'] as num).toDouble(),
        };
      }
      return null;
    } catch (e) {
      print('❌ Error extracting coordinates: $e');
      return null;
    }
  }

  /// Extract formatted address from place details
  static String? extractFormattedAddress(Map<String, dynamic> placeDetails) {
    try {
      return placeDetails['formatted_address'] as String?;
    } catch (e) {
      print('❌ Error extracting address: $e');
      return null;
    }
  }

  /// Generate a unique session token for grouping autocomplete and place
  /// details requests in the same session
  static String generateSessionToken() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
