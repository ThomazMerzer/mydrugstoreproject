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
  
  // Скидка в процентах
  double _discountPercent = 0.0;

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
      _totalAmount = sum * (1 - _discountPercent / 100);
    });
  }

  // Применить скидку
  void _applyDiscount(double percent) {
    setState(() {
      _discountPercent = percent;
      _calculateTotal();
    });
    _showMessage('Скидка $percent% применена');
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
                // Заголовок таблицы
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: Text('Наименование', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 1, child: Text('Кол-во', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Цена', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 1, child: Text('Действие', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
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
                                  Expanded(flex: 4, child: Text(item['name'], overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 1, child: Text('${item['quantity']}', textAlign: TextAlign.center)),
                                  Expanded(flex: 2, child: Text('${(item['price'] as double).toStringAsFixed(2)} ₽', textAlign: TextAlign.right)),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _removeItem(index),
                                      tooltip: 'Удалить',
                                    ),
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
                ElevatedButton.icon(
                  onPressed: () => _showMessage('Кнопка "Режим продаж" нажата'),
                  icon: const Icon(Icons.point_of_sale),
                  label: const Text('Режим продаж'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showMessage('Кнопка "Режим приемки" нажата'),
                  icon: const Icon(Icons.inventory),
                  label: const Text('Режим приемки'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showMessage('Кнопка "Энциклопедия" нажата'),
                  icon: const Icon(Icons.book),
                  label: const Text('Энциклопедия'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showMessage('Кнопка "Настройки" нажата'),
                  icon: const Icon(Icons.settings),
                  label: const Text('Настройки'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Строка с суммой и скидками
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Общая сумма:',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      '${_totalAmount.toStringAsFixed(2)} ₽',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Скидки:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _applyDiscount(5),
                      child: const Text('5%'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _applyDiscount(10),
                      child: const Text('10%'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _applyDiscount(15),
                      child: const Text('15%'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _discountPercent = 0.0;
                          _calculateTotal();
                        });
                        _showMessage('Скидка снята');
                      },
                      child: const Text('Сброс'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Кнопки действий
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
          ],
        ),
      ),
    );
  }
}
