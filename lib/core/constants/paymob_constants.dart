import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymobConstants {

  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'fallback_url'; // Use a fallback or use get() for required values
  static final String apiKey = dotenv.env['API_KEY'] ?? 'fallback_key';
  static final String secretKey = dotenv.env['SECRET_KEY'] ?? 'fallback_key';
  static final String publicKey = dotenv.env['PUBLIC_KEY'] ?? 'fallback_key';
  static final String password = dotenv.env['password'] ?? 'fallback_key';
  static final String iframeId = dotenv.env['iframeId'] ?? 'fallback_key';
  static final String webapikey = dotenv.env['WEB_API_KEY'] ?? 'fallback_key';
  static final String androidapikey = dotenv.env['ANROID_API_KEY'] ?? 'fallback_key';
  static final String paymentKey = dotenv.env['PAYMENT_KEY'] ?? 'fallback_key';

/////////////////////////////////////////////////////////////////////////////////////

  static final String integrationId = dotenv.env['integrationId'] ?? 'fallback_key';
  static const String authEndpoint = '/auth/tokens';
  static const String orderEndpoint = '/ecommerce/orders';
  static const String paymentKeyEndpoint = '/acceptance/payment_keys';
}
