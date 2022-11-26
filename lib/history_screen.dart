import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kirana_billing/bill_print_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('bills').get(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
            return const Center(child: Text('No Bills Yet'));
          }
          List<Widget> containers = [];
          for (var element in snapshot.data!.docs) {
            if (element.data().isEmpty) {
              containers.add(const Center(child: Text('No Bills Yet')));
            } else {
              List<Text> texts = [];
              late List rawData;
              late String customerName;
              late String billNumber;
              late String timeStamp;
              element.data().forEach((key, value) {
                if (key == 'rawData') {
                  rawData = value;
                } else if (key == 'customerName') {
                  customerName = value;
                } else if (key == 'billNumber') {
                  billNumber = value;
                } else if (key == 'time') {
                  timeStamp = value;
                }
                if (key != 'rawData') {
                  texts.add(Text('$key: $value'));
                }
              });
              containers.add(GestureDetector(
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillPrintScreen(
                        billNumber: billNumber,
                        customerName: customerName,
                        dataList: rawData,
                        timestamp: timeStamp,
                      ),
                    ),
                  );
                }),
                child: Card(
                  child: Column(children: texts),
                ),
              ));
            }
          }
          return ListView(
            children: containers,
          );
        },
      ),
    );
  }
}
