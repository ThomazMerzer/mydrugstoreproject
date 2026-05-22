import 'package:flutter/material.dart';

class BottomButtonsWidget extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onClearCart;
  final VoidCallback onRemoveLastItem;
  final VoidCallback onPayment;

  const BottomButtonsWidget({
    super.key,
    required this.totalAmount,
    required this.onClearCart,
    required this.onRemoveLastItem,
    required this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Общая сумма: ${totalAmount.toStringAsFixed(2)} ₽',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 32),
          ElevatedButton.icon(
            onPressed: onClearCart,
            icon: const Icon(Icons.clear),
            label: const Text('Очистить чек'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onRemoveLastItem,
            icon: const Icon(Icons.delete),
            label: const Text('Удалить позицию'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onPayment,
            icon: const Icon(Icons.payment),
            label: const Text('Оплата'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
