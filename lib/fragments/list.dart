import 'package:flutter/material.dart';

import '../models/store.dart';
import '../fragments/store_page.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final currentStore = Store(
    id: 0,
    name: 'Safeway',
    address: '1234 pizza road\nBig City, CA 12345',
    latitude: 123,
    longitude: 123,
    currentOccupancy: 1211231231231231233,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(currentStore.name),
              subtitle: Text(currentStore.address),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StorePage(currentStore.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}