import 'package:flutter/material.dart';
import 'package:preliminary/fragments/map.dart';
import 'package:preliminary/fragments/list.dart';
import 'package:preliminary/controllers/map_controller.dart';

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
  final MapController controller = MapController();
  MapPage mappage = MapPage();
  ListPage listpage = ListPage();

  @override
  void initState() {
    super.initState();

    mappage = MapPage(
      controller: controller
    );
    listpage = ListPage();
  }

  _getMainFragment() {
    switch (fragment) {
      case 'Map':
        return mappage;
      case 'List':
        return listpage;

      default:
        return new Text("Cannot find Page");
    }
  }

  _getIcon() {
    switch (fragment) {
      case 'Map':
        return Icon(Icons.my_location);
      case 'List':
        return Icon(Icons.add);
    }
  }

  _getAction() {
    debugPrint("Clicked");
    switch (fragment) {
      case 'Map':
        if (controller.updateCurrentPosition != null){
          controller.updateCurrentPosition();
        }
        break;
      case 'List':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _getMainFragment()
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
        child: _getIcon(),
        onPressed: () {
          _getAction();
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
