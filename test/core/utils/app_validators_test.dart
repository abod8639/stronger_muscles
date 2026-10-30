import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/utils/validators/app_validators.dart';

void main() {
  group('AppValidators', () {
    test('validateEmail', () {
      String? validate(String? v) =>
          AppValidators.validateEmail(v, emptyMessage: 'empty', invalidMessage: 'invalid');
      expect(validate(''), 'empty');
      expect(validate('nope'), 'invalid');
      expect(validate('a@b.co'), isNull);
    });

    test('validatePassword enforces min length', () {
      String? validate(String? v) =>
          AppValidators.validatePassword(v, emptyMessage: 'empty', tooShortMessage: 'short');
      expect(validate(''), 'empty');
      expect(validate('123'), 'short');
      expect(validate('123456'), isNull);
    });

    test('validateConfirmPassword', () {
      expect(
        AppValidators.validateConfirmPassword('a', 'b', emptyMessage: 'e', mismatchMessage: 'm'),
        'm',
      );
      expect(
        AppValidators.validateConfirmPassword('a', 'a', emptyMessage: 'e', mismatchMessage: 'm'),
        isNull,
      );
    });
  });
}
