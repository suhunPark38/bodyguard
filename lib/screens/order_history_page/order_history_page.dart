import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shopping_provider.dart';
import '../shopping_page/widgets/payment_history_tab_widget.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 내역'),
      ),
      body: Consumer<ShoppingProvider>(
        builder: (context, provider, child) {
          return PaymentHistoryTabWidget(provider: provider);
        },
      ),
    );
  }
}
