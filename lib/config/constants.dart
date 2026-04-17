// API Configuration
class ApiConstants {
  static const String baseUrl =
      'https://riden-web-portal.itimium.com.pk/api/passenger';

  // Auth Endpoints
  static const String registerEndpoint = '$baseUrl/register';
  static const String loginEndpoint = '$baseUrl/login';
  static const String logoutEndpoint = '$baseUrl/logout';
  static const String forgotPasswordEndpoint = '$baseUrl/forgot-password';

  // Passenger Management Endpoints
  static const String passengerListEndpoint = '$baseUrl/all';
  static const String createPassengerEndpoint = '$baseUrl/store';
  static const String getPassengerEndpoint = '$baseUrl/detail';
  static const String updatePassengerEndpoint = '$baseUrl/update';
  static const String deletePassengerEndpoint = '$baseUrl/delete';
  static const String toggleStatusEndpoint = '$baseUrl/status';

  // Google Places API Configuration
  // ⚠️ IMPORTANT: Replace with your actual Google Places API key
  // Get your key from: https://console.cloud.google.com/
  static const String googlePlacesApiKey =
      'AIzaSyD3Tw1rkB9PWTx_7vRUrGvgQfxIrBbNYkg';

  static const String googlePlacesAutocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  static const String googlePlacesDetailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
