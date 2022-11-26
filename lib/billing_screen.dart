import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kirana_billing/widgets/table_header.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<TableRow> rowList = [];
  List<Map<String, String>> rawData = [];
  int indexController = 0;
  List<double> finalPriceslist = [];
  double sum = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController billNumberController = TextEditingController();

  addPrices() {
    double temp = 0;
    for (var element in finalPriceslist) {
      temp = temp + element;
    }
    setState(() {
      sum = temp;
    });
  }

  void calculatePriceAfterDiscount({
    required int index,
    required TextEditingController quantityController,
    required TextEditingController priceController,
    required TextEditingController discountController,
  }) {
    if (discountController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        quantityController.text.isNotEmpty) {
      var disVal = (int.parse(quantityController.text) *
              double.parse(priceController.text)) *
          (double.parse(discountController.text) / 100);
      setState(() {
        finalPriceslist[index] = (int.parse(quantityController.text) *
                double.parse(priceController.text)) -
            disVal;
      });
    } else if (priceController.text.isEmpty &&
        quantityController.text.isEmpty) {
      setState(() {
        finalPriceslist[index] = 0;
      });
    } else {
      setState(() {
        finalPriceslist[index] = (int.parse(quantityController.text) *
            double.parse(priceController.text));
      });
    }
    addPrices();
  }

  submit({
    required String billNumber,
    required String customerName,
    required List<Map<String, String>> rawData,
  }) {
    if (billNumber != '' && customerName != '' && rawData.isNotEmpty) {
      final billsRef = FirebaseFirestore.instance.collection('bills');
      billsRef.doc(DateTime.now().toString()).set({
        'billNumber': billNumber,
        'customerName': customerName,
        'rawData': rawData,
        'time': DateTime.now().toString(),
      });
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    rowList.add(TableRowsProvider.tableRowHeader());
    super.initState();
  }

  String getDateTime() {
    DateTime datetime = DateTime.now();
    String currentTime =
        '${datetime.day}/${datetime.month}/${datetime.year} ${datetime.hour}:${datetime.minute}:${datetime.second}';
    return currentTime;
  }

  void addRow({required int rowIndex}) {
    rawData.add({});
    finalPriceslist.add(0);

    TextEditingController priceController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController totController = TextEditingController();

    TableRow tableRow = TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('${rowIndex + 1}'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TextField(
            onChanged: (val) {
              rawData[rowIndex]['Name'] = val;
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TextField(
            controller: quantityController,
            onChanged: (val) {
              rawData[rowIndex]['Quantity'] = val;
              calculatePriceAfterDiscount(
                index: rowIndex,
                quantityController: quantityController,
                priceController: priceController,
                discountController: discountController,
              );
              totController.text = finalPriceslist[rowIndex].toString();
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TextField(
            controller: priceController,
            onChanged: (val) {
              rawData[rowIndex]['Price'] = val;
              calculatePriceAfterDiscount(
                index: rowIndex,
                quantityController: quantityController,
                priceController: priceController,
                discountController: discountController,
              );
              totController.text = finalPriceslist[rowIndex].toString();
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TextField(
            controller: discountController,
            onChanged: (val) {
              rawData[rowIndex]['Discount'] = val;
              calculatePriceAfterDiscount(
                index: rowIndex,
                quantityController: quantityController,
                priceController: priceController,
                discountController: discountController,
              );
              totController.text = finalPriceslist[rowIndex].toString();
            },
          ),
        ),
      ),
      Center(
        child: TextField(
          readOnly: true,
          controller: totController,
        ),
      ),
    ]);
    rowList.add(tableRow);
    setState(() {
      rowList;
    });
  }

  buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: billNumberController,
                decoration: InputDecoration(
                  helperText: "Bill Number",
                  hintText: 'Enter Bill Number',
                  errorText: billNumberController.text.isEmpty
                      ? 'This field is required'
                      : null,
                ),
                onChanged: ((value) {
                  setState(() {
                    billNumberController.text;
                  });
                }),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  helperText: "Customer Name",
                  hintText: 'Enter Customer Name',
                  errorText: nameController.text.isEmpty
                      ? 'This field is required'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    nameController.text;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(getDateTime()),
          ),
        ],
      ),
    );
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
                children: rowList,
              ),
              Text('Total: $sum'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    addRow(rowIndex: indexController);
                    indexController++;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildTable(),
            ElevatedButton(
              onPressed: nameController.text.isNotEmpty &&
                      billNumberController.text.isNotEmpty
                  ? () {
                      submit(
                        billNumber: billNumberController.text,
                        customerName: nameController.text,
                        rawData: rawData,
                      );
                    }
                  : null,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Create Bill'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
