import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/presentation/pages/payment_gateway_view.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  testWidgets('shows transaction details and the proceed button', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PaymentGatewayView(
          paymentResult: PaymentResultEntity(
            success: true,
            paymentUrl: 'https://pay.example.test/session/1',
            transactionId: 'TX-1',
            reference: 'REF-9',
          ),
          orderId: '42',
          amount: 150.0,
        ),
      ),
    );

    expect(find.text('Payment Session Ready'), findsOneWidget);
    expect(find.text('#42'), findsOneWidget);
    expect(find.text('TX-1'), findsOneWidget);
    expect(find.text('REF-9'), findsOneWidget);
    expect(find.text('LE 150.00'), findsOneWidget);
    expect(find.text('Proceed to Payment'), findsOneWidget);
    expect(find.text('100% Secure & Encrypted Payments'), findsOneWidget);
  });

  testWidgets('warns instead of showing the button when there is no payment link', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const PaymentGatewayView(
          paymentResult: PaymentResultEntity(
            success: false,
            paymentUrl: '',
            transactionId: '',
            reference: '',
          ),
        ),
      ),
    );

    expect(find.text('Proceed to Payment'), findsNothing);
    expect(find.byIcon(Icons.link_off_rounded), findsOneWidget);
  });
}
