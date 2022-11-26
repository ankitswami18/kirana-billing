import 'package:flutter/material.dart';

class TableRowsProvider {
  static TableRow tableRowHeader() {
    List<String> headerList = [
      'S.no',
      'Item name',
      'Quantity',
      'Price',
      'Discount',
      'Total',
    ];
    return TableRow(
      children: headerList.map((e) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              e,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
