import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:http/http.dart' as http; // Import for making HTTP requests

class UserProfileService {
  // Base URL of your API
  static const String baseUrl = 'https://example.com/api';

  // Method to update user profile
  Future<void> updateUserProfile(
      String fullName, String email, String phoneNo, String password) async {
    try {
      // Example API endpoint for updating user profile
      const String apiUrl = '$baseUrl/update_profile';

      // Example JSON payload for the request body
      Map<String, String> requestBody = {
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNo,
        'password': password,
      };

      // Encode the request body into JSON format
      String requestBodyJson = json.encode(requestBody);

      // Make a PUT request to update user profile
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Add any required headers (e.g., authorization token)
        },
        body: requestBodyJson,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Successful update
        print('User profile updated successfully');
      } else {
        // Handle other status codes (e.g., 4xx, 5xx)
        throw Exception(
            'Failed to update user profile (${response.statusCode})');
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error updating user profile: $e');
      throw e; // Propagate the error up for UI handling
    }
  }
}
