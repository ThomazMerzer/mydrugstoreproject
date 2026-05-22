import 'package:flutter/material.dart';
import 'column_separator_widget.dart';

class CartItemWidget extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;
  final bool isEven;

  const CartItemWidget({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      padding: const EdgeInsets.all(8.0),
      color: isEven ? Colors.grey[200] : Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ColumnSeparatorWidget(),
          SizedBox(
            width: 100,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
            ),
          ),
          const ColumnSeparatorWidget(),
          Expanded(
            child: Text(
              '${price.toStringAsFixed(2)} ₽',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
