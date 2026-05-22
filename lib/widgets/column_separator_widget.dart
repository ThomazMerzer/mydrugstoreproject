import 'package:flutter/material.dart';

class ColumnSeparatorWidget extends StatelessWidget {
  const ColumnSeparatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 30,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Container(
        width: 1,
        height: 20,
        color: Colors.grey[400],
      ),
    );
  }
}
