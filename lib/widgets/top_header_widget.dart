import 'package:flutter/material.dart';
import 'column_separator_widget.dart';

class TopHeaderWidget extends StatelessWidget {
  const TopHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: const Text(
              'Наименование',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ColumnSeparatorWidget(),
          SizedBox(
            width: 100,
            child: const Text(
              'Количество',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ColumnSeparatorWidget(),
          const Expanded(
            child: Text(
              'Цена',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
