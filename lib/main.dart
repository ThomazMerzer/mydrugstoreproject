import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/top_header_widget.dart';
import 'widgets/cart_table_widget.dart';
import 'widgets/right_buttons_widget.dart';
import 'widgets/bottom_buttons_widget.dart';

void main() {
  runApp(const PharmacistWorkplaceApp());
}

class PharmacistWorkplaceApp extends StatelessWidget {
  const PharmacistWorkplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Рабочее место фармацевта',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;
  final Random _random = Random();
  bool _isInitialized = false;

  final List<Map<String, dynamic>> _drugPool = [
    {'name': 'Парацетамол', 'price': 50.0},
    {'name': 'Сальбутамол', 'price': 120.0},
    {'name': 'Пластырь', 'price': 80.0},
    {'name': 'Бинт', 'price': 45.0},
    {'name': 'Крем для рук', 'price': 150.0},
    {'name': 'Нафтизин', 'price': 60.0},
    {'name': 'Анальгин', 'price': 40.0},
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _calculateTotal();
    });
    _showMessage('Чек очищен');
  }

  void _removeLastItem() {
    if (_cartItems.isEmpty) return;
    setState(() {
      _cartItems.removeLast();
      _calculateTotal();
    });
    _showMessage('Позиция удалена');
  }

  void _calculateTotal() {
    double sum = 0.0;
    for (var item in _cartItems) {
      sum += (item['price'] as double) * (item['quantity'] as int);
    }
    setState(() {
      _totalAmount = sum;
    });
  }

  void _addRandomDrug() {
    final drug = _drugPool[_random.nextInt(_drugPool.length)];
    setState(() {
      _cartItems.add({
        'name': drug['name'],
        'quantity': 1,
        'price': drug['price'],
      });
      _calculateTotal();
    });
    _showMessage('Добавлен препарат: ${drug['name']}');
  }

  void _processPayment() {
    if (_cartItems.isEmpty) {
      _showMessage('Чек пуст!');
      return;
    }
    _showMessage('Переход к оплате. Сумма: ${_totalAmount.toStringAsFixed(2)} ₽');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рабочее место фармацевта'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const TopHeaderWidget(),
                Expanded(
                  child: CartTableWidget(cartItems: _cartItems),
                ),
              ],
            ),
          ),
          RightButtonsWidget(
            onSalesMode: () => _showMessage('Кнопка "Режим продаж" нажата'),
            onReceptionMode: () => _showMessage('Кнопка "Режим приемки" нажата'),
            onEncyclopedia: () => _showMessage('Кнопка "Энциклопедия" нажата'),
            onSettings: () => _showMessage('Кнопка "Настройки" нажата'),
            onAddProduct: _addRandomDrug,
          ),
        ],
      ),
      bottomNavigationBar: BottomButtonsWidget(
        totalAmount: _totalAmount,
        onClearCart: _clearCart,
        onRemoveLastItem: _removeLastItem,
        onPayment: _processPayment,
      ),
    );
  }
}