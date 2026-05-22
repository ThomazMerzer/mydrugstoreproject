import 'package:flutter/material.dart';

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
          _buildSeparator(),
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
          _buildSeparator(),
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

  Widget _buildSeparator() {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onPanUpdate: (details) {},
        child: Container(
          width: 20,
          height: 30,
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
}
