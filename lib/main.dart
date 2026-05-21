import 'dart:math';
import 'package:flutter/material.dart';

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
  // Список товаров в чеке
  final List<Map<String, dynamic>> _cartItems = [];
  
  // Общая сумма
  double _totalAmount = 0.0;
  
  // Ширина столбцов (в логических пикселях)
  double _nameColumnWidth = 300;
  double _quantityColumnWidth = 100;
  double _priceColumnWidth = 150;
  
  // Флаг для отслеживания перетаскивания
  bool _isDraggingName = false;
  bool _isDraggingQuantity = false;
  
  // Пул препаратов для случайного добавления
  final List<Map<String, dynamic>> _drugPool = [
    {'name': 'Парацетамол', 'price': 50.0},
    {'name': 'Сальбутамол', 'price': 120.0},
    {'name': 'Пластырь', 'price': 80.0},
    {'name': 'Бинт', 'price': 45.0},
    {'name': 'Крем для рук', 'price': 150.0},
  ];

  final Random _random = Random();

  // Показать диалог с сообщением
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Удалить позицию из чека
  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _calculateTotal();
    });
    _showMessage('Позиция удалена');
  }

  // Очистить чек
  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _calculateTotal();
    });
    _showMessage('Чек очищен');
  }

  // Рассчитать общую сумму
  void _calculateTotal() {
    double sum = 0.0;
    for (var item in _cartItems) {
      sum += (item['price'] as double) * (item['quantity'] as int);
    }
    setState(() {
      _totalAmount = sum;
    });
  }

  // Добавить случайный препарат
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

  // Оплата
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
          // Левая часть - окно набора чека
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Заголовок таблицы с изменяемой шириной столбцов
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      SizedBox(
                        width: _nameColumnWidth,
                        child: const Text('Наименование', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      // Разделитель для изменения ширины первого столбца
                      MouseRegion(
                        cursor: SystemMouseCursors.resizeLeftRight,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _nameColumnWidth = (_nameColumnWidth + details.delta.dx).clamp(100, 600);
                            });
                          },
                          child: Container(
                            width: 8,
                            height: 30,
                            color: _isDraggingName ? Colors.blue : Colors.grey[400],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _quantityColumnWidth,
                        child: const Text('Количество', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      // Разделитель для изменения ширины второго столбца
                      MouseRegion(
                        cursor: SystemMouseCursors.resizeLeftRight,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _quantityColumnWidth = (_quantityColumnWidth + details.delta.dx).clamp(50, 200);
                            });
                          },
                          child: Container(
                            width: 8,
                            height: 30,
                            color: _isDraggingQuantity ? Colors.blue : Colors.grey[400],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text('Цена', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // Список товаров в чеке
                Expanded(
                  child: _cartItems.isEmpty
                      ? Center(
                          child: Text(
                            'Чек пуст. Отсканируйте штрихкод или QR-код товара.',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: _nameColumnWidth,
                                    child: Text(item['name'], overflow: TextOverflow.ellipsis),
                                  ),
                                  SizedBox(
                                    width: _quantityColumnWidth,
                                    child: Text('${item['quantity']}', textAlign: TextAlign.center),
                                  ),
                                  Expanded(
                                    child: Text('${(item['price'] as double).toStringAsFixed(2)} ₽', textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          // Правая часть - кнопки режимов
          Container(
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
                // Кнопка с разделенными иконкой и текстом
                ButtonStyleButton(
                  onPressed: () => _showMessage('Кнопка "Режим продаж" нажата'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ).copyWith(
                    alignment: Alignment.centerLeft,
                  ),
                  builder: (context, states) {
                    return SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 12,
                            top: 0,
                            bottom: 0,
                            child: Icon(Icons.point_of_sale),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text('Режим продаж'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ButtonStyleButton(
                  onPressed: () => _showMessage('Кнопка "Режим приемки" нажата'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ).copyWith(
                    alignment: Alignment.centerLeft,
                  ),
                  builder: (context, states) {
                    return SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 12,
                            top: 0,
                            bottom: 0,
                            child: Icon(Icons.inventory),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text('Режим приемки'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ButtonStyleButton(
                  onPressed: () => _showMessage('Кнопка "Энциклопедия" нажата'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ).copyWith(
                    alignment: Alignment.centerLeft,
                  ),
                  builder: (context, states) {
                    return SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 12,
                            top: 0,
                            bottom: 0,
                            child: Icon(Icons.book),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text('Энциклопедия'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ButtonStyleButton(
                  onPressed: () => _showMessage('Кнопка "Настройки" нажата'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ).copyWith(
                    alignment: Alignment.centerLeft,
                  ),
                  builder: (context, states) {
                    return SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 12,
                            top: 0,
                            bottom: 0,
                            child: Icon(Icons.settings),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text('Настройки'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ButtonStyleButton(
                  onPressed: _addRandomDrug,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ).copyWith(
                    alignment: Alignment.centerLeft,
                  ),
                  builder: (context, states) {
                    return SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 12,
                            top: 0,
                            bottom: 0,
                            child: Icon(Icons.add_shopping_cart),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text('Добавить товар'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Общая сумма: ${_totalAmount.toStringAsFixed(2)} ₽',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(width: 32),
            ElevatedButton.icon(
              onPressed: _clearCart,
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
              onPressed: _cartItems.isEmpty 
                ? null 
                : () => _showMessage('Кнопка "Удалить последнюю позицию" нажата'),
              icon: const Icon(Icons.remove_shopping_cart),
              label: const Text('Удалить позицию'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _processPayment,
              icon: const Icon(Icons.payment),
              label: const Text('Оплата'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
