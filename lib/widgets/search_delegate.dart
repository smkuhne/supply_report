import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemSearch extends SearchDelegate<Item> {
  final List<Item> searchItems;

  ItemSearch(this.searchItems);

  final legend = const {
    true: Icon(
      Icons.check,
      color: Colors.green,
    ),
    false: Icon(
      Icons.close,
      color: Colors.red,
    ),
  };

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: legend[results[index].availability],
          title: Text(results[index].name),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
      itemCount: results.length,
      physics: const BouncingScrollPhysics(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = searchItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: legend[results[index].availability],
          title: Text(results[index].name),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
      itemCount: results.length,
      physics: const BouncingScrollPhysics(),
    );
  }
}
