import 'package:flutter/material.dart';
import 'package:supplyreport/fragments/map.dart';
import 'package:supplyreport/fragments/list.dart';
import 'package:supplyreport/controllers/map_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supply Report',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Supply Report'),
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
  double _fabOffset = 60;
  bool _newStore = false;

  @override
  void initState() {
    super.initState();

    mappage = MapPage(
      controller: controller,
    );
  }

  _getMainFragment() {
    return mappage;
  }

  _getIcon() {
    if (_newStore) {
      return Icon(Icons.cancel);
    } else {
      return Icon(Icons.search);
    }
  }

  _getActions() {
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
  }

  _getAction() {
    if (controller.setNewStore != null){
      controller.setNewStore();
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
