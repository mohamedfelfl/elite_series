import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../generated/locale_keys.g.dart';

@RoutePage()
class PaymentFormScreen extends StatelessWidget {
  const PaymentFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Payment form is handled via the dialog in PaymentListScreen.
    // This exists as a route placeholder.
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.use_payment_list.tr()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.router.maybePop(),
              child: Text(LocaleKeys.go_back.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
