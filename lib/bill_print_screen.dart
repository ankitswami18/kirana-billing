import 'package:flutter/material.dart';
import 'package:kirana_billing/widgets/table_header.dart';

class BillPrintScreen extends StatefulWidget {
  const BillPrintScreen({
    required this.billNumber,
    required this.customerName,
    required this.dataList,
    required this.timestamp,
    Key? key,
  }) : super(key: key);
  final String customerName;
  final String billNumber;
  final List dataList;
  final String timestamp;

  @override
  State<BillPrintScreen> createState() => _BillPrintScreenState();
}

class _BillPrintScreenState extends State<BillPrintScreen> {
  double grandTotal = 0;

  double calculatePriceAfterDiscount({
    required int quantity,
    required double price,
    required double discount,
  }) {
    if (discount != 0 && price != 0 && quantity != 0) {
      var disVal = (discount * price) * (discount / 100);
      return (quantity * price) - disVal;
    } else if (price == 0 && quantity == 0) {
      return 0;
    } else {
      return (quantity * price);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> addRow() {
      List<TableRow> rows = [];
      int temp = 0;
      rows.add(TableRowsProvider.tableRowHeader());
      for (Map e in widget.dataList) {
        temp++;
        if (e != {}) {
          Map dataMap = e;
          String discount = '';
          String name = '';
          String price = '';
          String quantity = '';
          double total = 0;
          dataMap.forEach(
            (key, value) {
              if (key == 'Discount') {
                discount = value;
              } else if (key == 'Total') {
                total = value;
              } else if (key == 'Name') {
                name = value;
              } else if (key == 'Price') {
                price = value;
              } else if (key == 'Quantity') {
                quantity = value;
              }
            },
          );
          total = calculatePriceAfterDiscount(
            quantity: int.parse(quantity),
            price: double.parse(price),
            discount: double.parse(discount),
          );
          grandTotal = grandTotal + total;
          TableRow tableRow = TableRow(
            children: [
              Text(temp.toString()),
              Text(name),
              Text(quantity),
              Text(price),
              Text(discount),
              Text(total.toString()),
            ],
          );
          rows.add(tableRow);
        }
      }
      return rows;
    }

    buildTable() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FractionColumnWidth(0.05),
                    1: FractionColumnWidth(0.19),
                    2: FractionColumnWidth(0.19),
                    3: FractionColumnWidth(0.19),
                    4: FractionColumnWidth(0.19),
                    5: FractionColumnWidth(0.19),
                    6: FractionColumnWidth(0.19),
                  },
                  children: addRow(),
                ),
                Text('Total: $grandTotal'),
              ],
            ),
          ),
        ),
      );
    }

    buildHeader() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('customerName: ${widget.customerName}'),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('billNumber: ${widget.billNumber}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.timestamp),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        children: [
          buildHeader(),
          buildTable(),
        ],
      ),
    );
  }
}
