import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'fallback_url'; // Use a fallback or use get() for required values
  final String apiKey = dotenv.env['API_KEY'] ?? 'fallback_key';
  final String secretKey = dotenv.env['SECRET_KEY'] ?? 'fallback_key';
  final String publicKey = dotenv.env['PUBLIC_KEY'] ?? 'fallback_key';
  final String password = dotenv.env['password'] ?? 'fallback_key';

  // Use baseUrl and apiKey in your API calls
}
