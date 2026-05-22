import 'package:flutter/material.dart';
import '../widgets/cart_item_widget.dart';

class CartTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartTableWidget({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Center(
        child: Text(
          'Чек пуст. Отсканируйте штрихкод или QR-код товара.',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        final isEven = index % 2 == 1;
        return CartItemWidget(
          name: item['name'],
          quantity: item['quantity'],
          price: item['price'],
          isEven: isEven,
        );
      },
    );
  }
}
