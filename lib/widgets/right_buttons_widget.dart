import 'package:flutter/material.dart';

class RightButtonsWidget extends StatelessWidget {
  final VoidCallback onSalesMode;
  final VoidCallback onReceptionMode;
  final VoidCallback onEncyclopedia;
  final VoidCallback onSettings;
  final VoidCallback onAddProduct;

  const RightButtonsWidget({
    super.key,
    required this.onSalesMode,
    required this.onReceptionMode,
    required this.onEncyclopedia,
    required this.onSettings,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Режимы работы',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildButton(
            icon: Icons.point_of_sale,
            label: 'Режим продаж',
            onPressed: onSalesMode,
          ),
          const SizedBox(height: 12),
          _buildButton(
            icon: Icons.inventory,
            label: 'Режим приемки',
            onPressed: onReceptionMode,
          ),
          const SizedBox(height: 12),
          _buildButton(
            icon: Icons.book,
            label: 'Энциклопедия',
            onPressed: onEncyclopedia,
          ),
          const SizedBox(height: 12),
          _buildButton(
            icon: Icons.settings,
            label: 'Настройки',
            onPressed: onSettings,
          ),
          const SizedBox(height: 12),
          _buildButton(
            icon: Icons.add_shopping_cart,
            label: 'Добавить товар',
            onPressed: onAddProduct,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Icon(icon),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
