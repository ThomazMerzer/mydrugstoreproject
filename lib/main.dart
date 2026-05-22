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

  // Пул препаратов для случайного добавления
  final List<Map<String, dynamic>> _drugPool = [
    {'name': 'Парацетамол', 'price': 50.0},
    {'name': 'Сальбутамол', 'price': 120.0},
    {'name': 'Пластырь', 'price': 80.0},
    {'name': 'Бинт', 'price': 45.0},
    {'name': 'Крем для рук', 'price': 150.0},
    {'name': 'Нафтизин', 'price': 60.0},
    {'name': 'Анальгин', 'price': 40.0},
  ];

  final Random _random = Random();

  // Ширины столбцов (независимые)
  late double _nameColumnWidth;
  late double _quantityColumnWidth;
  late double _priceColumnWidth;

  // Флаг для отслеживания первой отрисовки
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Инициализация будет выполнена после первого фрейма
  }

  // Показать диалог с сообщением
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Очистить чек
  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _calculateTotal();
    });
    _showMessage('Чек очищен');
  }

  // Удалить последнюю позицию
  void _removeLastItem() {
    if (_cartItems.isEmpty) return;
    setState(() {
      _cartItems.removeLast();
      _calculateTotal();
    });
    _showMessage('Позиция удалена');
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

  // Обработчик изменения ширины столбца
  void _resizeColumn(String column, double delta) {
    setState(() {
      switch (column) {
        case 'name':
          _nameColumnWidth = (_nameColumnWidth + delta).clamp(80.0, double.infinity);
          break;
        case 'quantity':
          _quantityColumnWidth = (_quantityColumnWidth + delta).clamp(60.0, double.infinity);
          break;
        case 'price':
          _priceColumnWidth = (_priceColumnWidth + delta).clamp(60.0, double.infinity);
          break;
      }
    });
  }

  // Построитель разделителя между столбцами
  Widget _buildSeparator(String column, {bool isRow = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onPanUpdate: (details) {
          _resizeColumn(column, details.delta.dx);
        },
        child: Container(
          width: 20,
          height: isRow ? 30 : 30,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: 1,
            height: 20,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
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
                // Заголовок таблицы с IntrinsicWidth для автоматического определения размеров
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[200],
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // При первой загрузке инициализируем ширины на основе доступного пространства
                      if (!_isInitialized) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              final availableWidth = constraints.maxWidth;
                              final baseWidth = availableWidth / 3;
                              _nameColumnWidth = baseWidth;
                              _quantityColumnWidth = baseWidth;
                              _priceColumnWidth = baseWidth;
                              _isInitialized = true;
                            });
                          }
                        });
                        // Показываем placeholder до инициализации
                        return const SizedBox(height: 40);
                      }

                      return Row(
                        children: [
                          // Столбец "Наименование"
                          SizedBox(
                            width: _nameColumnWidth,
                            child: const Text(
                              'Наименование',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Разделитель 1
                          _buildSeparator('name'),
                          // Столбец "Количество"
                          SizedBox(
                            width: _quantityColumnWidth,
                            child: const Text(
                              'Количество',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Разделитель 2
                          _buildSeparator('quantity'),
                          // Столбец "Цена" - гибкий, занимает оставшееся пространство
                          Expanded(
                            child: SizedBox(
                              width: _priceColumnWidth,
                              child: const Text(
                                'Цена',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                            final isEven = index % 2 == 1;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 1.0),
                              padding: const EdgeInsets.all(8.0),
                              color: isEven ? Colors.grey[200] : Colors.white,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: _nameColumnWidth,
                                    child: Text(
                                      item['name'],
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  _buildSeparator('name', isRow: true),
                                  SizedBox(
                                    width: _quantityColumnWidth,
                                    child: Text(
                                      '${item['quantity']}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  _buildSeparator('quantity', isRow: true),
                                  // Цена - гибкая колонка
                                  Expanded(
                                    child: SizedBox(
                                      width: _priceColumnWidth,
                                      child: Text(
                                        '${(item['price'] as double).toStringAsFixed(2)} ₽',
                                        textAlign: TextAlign.center,
                                      ),
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
                // Кнопка с разделенными иконкой и текстом
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showMessage('Кнопка "Режим продаж" нажата'),
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
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showMessage('Кнопка "Режим приемки" нажата'),
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
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showMessage('Кнопка "Энциклопедия" нажата'),
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
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showMessage('Кнопка "Настройки" нажата'),
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
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _addRandomDrug,
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
              onPressed: _removeLastItem,
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
              onPressed: _processPayment,
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
      ),
    );
  }
}