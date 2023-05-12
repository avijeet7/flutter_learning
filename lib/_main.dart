import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  List<SmsMessage> items = [];

  @override
  void initState() {
    items = _messages;
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      items = _messages
          .where((item) => item.body.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int i) {
                var message = items[i];

                return ListTile(
                  title: Text('${message.sender} [${message.date}]'),
                  subtitle: Text('${message.body}'),
                );
              },
            ),
          ),
        ],
      ),
      // body: Container(
      //   padding: const EdgeInsets.all(10.0),
      //   child: ListView.builder(
      //     shrinkWrap: true,
      //     itemCount: _messages.length,
      //     itemBuilder: (BuildContext context, int i) {
      //       var message = _messages[i];
      //
      //       return ListTile(
      //         title: Text('${message.sender} [${message.date}]'),
      //         subtitle: Text('${message.body}'),
      //       );
      //     },
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission = await Permission.sms.status;
          if (permission.isGranted) {
            List<SmsMessage> messages = await _query.querySms(
              kinds: [SmsQueryKind.inbox],
              // address: '+254712345789',
              count: 1000,
            );
            debugPrint('sms inbox messages: ${messages.length}');
            messages = messages
                .where((msg) => (msg.date != null &&
                    DateTime.parse("2023-04-01").compareTo(msg.date!) < 0))
                .toList();

            setState(() => _messages = messages);
          } else {
            await Permission.sms.request();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class MyCustomForm extends StatelessWidget {
//   const MyCustomForm({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: 'Enter a search term',
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: items.length,
//             itemBuilder: (BuildContext context, int i) {
//               var message = items[i];
//
//               return ListTile(
//                 title: Text('${message.sender} [${message.date}]'),
//                 subtitle: Text('${message.body}'),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
