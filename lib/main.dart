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
  double _fabOffset = 60;
  bool _newStore = false;

  @override
  void initState() {
    super.initState();

    mappage = MapPage(
      controller: controller,
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
        if (_newStore) {
          return Icon(Icons.cancel);
        } else {
          return Icon(Icons.add);
        }
        break;
      case 'List':
        return Icon(Icons.add);
    }
  }

  _getActions() {
    switch (fragment) {
      case 'Map':
        return <Widget>[
          IconButton(
            icon: Icon(Icons.refresh,
                color: Colors.white),
            onPressed: () {
              if (controller.reload != null) {
                controller.reload();
              }
            },
          )
        ];
      default:
        return null;
    }
  }

  _getAction() {
    debugPrint("Clicked");
    switch (fragment) {
      case 'Map':
        if (controller.setNewStore != null){
          controller.setNewStore();
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
        actions: _getActions()
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
                    _fabOffset = 60;
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
                    _fabOffset = 0;
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          )
      ),
      floatingActionButton: Stack(
        children: <Widget>[AnimatedPositioned(
            bottom: _fabOffset, right: 0,
            duration: Duration(milliseconds: 100),
            child: FloatingActionButton(
              child: _getIcon(),
              onPressed: () {
                _getAction();
              },
              heroTag: 'Variable'
            )
        ),]//
        )
    );
  }
}
