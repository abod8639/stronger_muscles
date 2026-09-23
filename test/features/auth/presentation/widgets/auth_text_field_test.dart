import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  group('AuthTextField Widget Tests', () {
    testWidgets('renders label, icon, and accepts text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              controller: controller,
              label: 'Email Address',
              icon: const Icon(Icons.email),
            ),
          ),
        ),
      );

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);

      await tester.enterText(find.byType(AuthTextField), 'user@strongermuscles.com');
      await tester.pump();

      expect(controller.text, 'user@strongermuscles.com');
      expect(find.text('user@strongermuscles.com'), findsOneWidget);
    });

    testWidgets('obscures text when isPassword is true', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              controller: controller,
              label: 'Password',
              icon: const Icon(Icons.lock),
              isPassword: true,
            ),
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.obscureText, isTrue);
    });

    testWidgets('displays validation error message when invalid', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AuthTextField(
                controller: controller,
                label: 'Required Field',
                icon: const Icon(Icons.star),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Trigger validation on empty field
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}
