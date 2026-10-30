import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_text_form_field.dart';

void main() {
  group('AppTextFormField Widget Tests', () {
    testWidgets('renders label, icon, and accepts text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextFormField(
              controller: controller,
              label: 'Email Address',
              prefixIcon: const Icon(Icons.email),
            ),
          ),
        ),
      );

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'user@strongermuscles.com');
      await tester.pump();

      expect(controller.text, 'user@strongermuscles.com');
      expect(find.text('user@strongermuscles.com'), findsOneWidget);
    });

    testWidgets('obscures text when isPassword is true', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextFormField(
              controller: controller,
              label: 'Password',
              prefixIcon: const Icon(Icons.lock),
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
              child: AppTextFormField(
                controller: controller,
                label: 'Required Field',
                prefixIcon: const Icon(Icons.star),
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

    testWidgets('password visibility toggle reveals text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppTextFormField(label: 'Password', isPassword: true)),
        ),
      );

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      final editableText = tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.obscureText, isFalse);
    });

    testWidgets('forwards focusNode and onFieldSubmitted', (tester) async {
      final focusNode = FocusNode();
      String? submitted;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextFormField(
              focusNode: focusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => submitted = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'hello');
      expect(focusNode.hasFocus, isTrue);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submitted, 'hello');
      focusNode.dispose();
    });
  });
}
