import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: QuoteList(),
  ));
}

class QuoteList extends StatefulWidget {
  const QuoteList({Key? key}) : super(key: key);

  @override
  State<QuoteList> createState() => _QuoteListState();
}

List<String> quotes = [
  "Amount credited 50 AED",
  "Amount debited 20 AED",
  "Amount debited 10 AED",
];

class _QuoteListState extends State<QuoteList> {
  List<String> messages = quotes;
  String fromDate = "";
  String toDate = "";

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Smart Expense Track'),
      ),
      body: Column(children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 180,
                child: TextField(
                  controller: fromDateController,
                  decoration: const InputDecoration(
                    labelText: 'From Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 180,
                child: TextField(
                  controller: toDateController,
                  decoration: const InputDecoration(
                    labelText: 'To Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
                width: 100, // <-- Your width
                height: 50, // <-- Your height
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        fromDate = fromDateController.text.toString();
                        toDate = toDateController.text.toString();
                      });
                      debugPrint(fromDate);
                      debugPrint(toDate);
                      messages = quotes.where((element) => element.contains(fromDate)).toList();
                    },
                    child: const Text("Filter")))
          ],
        ),
        Column(
          children: messages.map((msg) => Text(msg)).toList(),
        )
      ]),
    );
  }
}
