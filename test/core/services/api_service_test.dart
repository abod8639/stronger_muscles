import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/errors/failures.dart';

void main() {
  group('Failure Model Tests', () {
    test('creates Failure with default unknown type', () {
      final failure = Failure(message: 'Something went wrong');
      expect(failure.message, 'Something went wrong');
      expect(failure.type, FailureType.unknown);
      expect(failure.isConnectionError, false);
      expect(failure.toString(), 'Something went wrong');
    });

    test('isConnectionError returns true only for network type', () {
      final netFailure = Failure(message: 'Network down', type: FailureType.network);
      expect(netFailure.isConnectionError, true);

      final authFailure = Failure(message: 'Unauthorized', type: FailureType.auth);
      expect(authFailure.isConnectionError, false);

      final serverFailure = Failure(message: 'Server error', type: FailureType.server);
      expect(serverFailure.isConnectionError, false);
    });
  });

  group('Dio Interceptor Header Logic', () {
    test('removes includeAuth header and properly configures options', () {
      final options = RequestOptions(
        path: '/test',
        headers: {'includeAuth': false},
      );

      final bool includeAuth = options.headers.remove('includeAuth') != false;
      expect(includeAuth, false);
      expect(options.headers.containsKey('includeAuth'), false);
    });

    test('defaults includeAuth to true when omitted', () {
      final options = RequestOptions(
        path: '/test',
        headers: {},
      );

      final bool includeAuth = options.headers.remove('includeAuth') != false;
      expect(includeAuth, true);
    });
  });
}
