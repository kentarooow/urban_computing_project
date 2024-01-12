import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  String text = "";
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    reloadList();
  }

  void reloadList() {
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        List<String> list = pref.getStringList('widget_list') ?? [];
        widgets.clear();
        for (String element in list) {
          widgets.add(Card(
            child: ListTile(
              title: Text(element),
              leading: const Icon(Icons.star),
              onLongPress: () async {
                var newPref = await SharedPreferences.getInstance();
                List<String> newList = newPref.getStringList('widget_list') ?? [];
                newList.removeWhere((listElement) => listElement == element);
                newPref.setStringList("widget_list", newList);
                reloadList();
              },
            ),
          ));
        }
      });
    });
  }

  void _addNewText() {
    debugPrint(text);
    setState(() {
      SharedPreferences.getInstance().then((pref) {
        List<String> list = pref.getStringList('widget_list') ?? [];
        debugPrint(text);
        list.add(text);
        pref.setStringList('widget_list', list);
        reloadList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (inputValue) {
                text = inputValue;
              },
              onChanged: (inputValue) {
                text = inputValue;
              },
            ),
            Column(children: widgets)
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addNewText,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
