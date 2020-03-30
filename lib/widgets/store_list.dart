import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';
import '../widgets/store_list_item.dart';

class StoreList extends StatefulWidget {
  final String storeID;
  final ScrollController scrollController;

  StoreList(this.storeID, this.scrollController);

  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  var _isLoading = false;

  Future<void> _refreshItems(BuildContext context) async {
    await Provider.of<Items>(context, listen: false)
        .fetchAndSetItems(widget.storeID);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Items>(context, listen: false)
        .fetchAndSetItems(widget.storeID)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<Items>(context);
    final currentItems = itemsData.items;
    return _isLoading
        ? Center(heightFactor: 5.0, child: const CircularProgressIndicator())
        : currentItems.isEmpty
            ? Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _refreshItems(context),
                  child: const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: FittedBox(
                        child: Text(
                          'There are currently no inputted items.',
                          style: TextStyle(fontSize: 25.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _refreshItems(context),
                  child: ListView.builder(
                    controller: widget.scrollController,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: currentItems[index],
                        child: StoreListItem(widget.storeID),
                      );
                    },
                    itemCount: currentItems.length,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                  ),
                ),
              );
  }
}
