import 'package:flutter/material.dart';
import 'package:preliminary/fragments/map.dart';
import 'package:preliminary/fragments/list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preliminary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Preliminary'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fragment = 'Map';

  @override
  void initState() {
    super.initState();
  }

  _getMainFragment(fragment) {
    switch (fragment) {
      case 'Map':
        return new MapPage();
      case 'List':
        return new ListPage();

      default:
        return new Text("Cannot find Page");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _getMainFragment(fragment)
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white
                )
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.map,
                color: Colors.blue,
                size: 24.0,
                semanticLabel: 'Map view',
              ),
              title: Text('Map'),
              onTap: () {
                setState(() {
                  fragment = 'Map';
                });

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.local_grocery_store,
                color: Colors.blue,
                size: 24.0,
                semanticLabel: 'List view',
              ),
              title: Text('Stores'),
              onTap: () {
                setState(() {
                  fragment = 'List';
                });

                Navigator.pop(context);
              },
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
