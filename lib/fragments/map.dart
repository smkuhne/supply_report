import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supplyreport/models/store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supplyreport/controllers/map_controller.dart';
import 'package:supplyreport/fragments/store_page.dart';
import 'package:supplyreport/tokens/places_api_key.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.controller}) : super(key: key);

  final MapController controller;

  @override
  _MapPageState createState() => _MapPageState(controller);
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: api_key);
  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;
  LatLng _position;
  bool _loaded = false;
  List<Store> _stores = [];
  Map<String, Marker> _markers = {};
  double _currentInfo = -100;
  String _currentName = "Location";
  String _currentAddress = "none";
  int _currentOccupancy = 0;
  Store _currentStore = null;
  List _acceptableTypes = [
    "bakery",
    "cafe",
    "drugstore",
    "meal_delivery",
    "meal_takeaway",
    "convenience_store",
    "department_store",
    "supermarket",
    "grocery_or_supermarket"
  ];


  void initState() {
    super.initState();
    _updateCurrentPosition();
    _populateStores();
    _getMarkers();
  }

  _MapPageState(MapController _controller) {
    _controller.setNewStore = _setNewStore;
    _controller.reload = _reload;
    debugPrint("Set up map page state");
  }

  // Temporary method
  void _populateStores() {
    _reload();
  }

  Map<String, String> _getMinMaxOffsets(double latitude, double longitude) {
    //Earth’s radius, sphere
    double radius = 6378137;

    //offsets in meters
    double offset = 50000;

    double dLatitude = offset/radius;
    double dLongitude = offset/(radius*cos(latitude * pi / 180));

    //OffsetPosition, decimal degrees
    double maxLatitude = latitude + (dLatitude * 180/pi);
    double maxLongitude = longitude + (dLongitude * 180/pi);

    double minLatitude = latitude - (dLatitude * 180/pi);
    double minLongitude = longitude - (dLongitude * 180/pi);

    return {
      'latmin': '$minLatitude',
      'longmin': '$minLongitude',
      'latmax': '$maxLatitude',
      'longmax': '$maxLongitude'
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateCurrentPosition() {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _position = new LatLng(position.latitude, position.longitude);
        _loaded = true;
      });
      
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: _position,
          tilt: 50.0,
          bearing: 0,
          zoom: 13.0,
        )
      ));
    }).catchError((e) {
      print(e);
    });
  }

  void _reload() async {
    Position position = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double latitude = position.latitude;
    double longitude = position.longitude;
    Map<String, String> offsets = _getMinMaxOffsets(latitude, longitude);

    var uri = Uri.https('pro-router-231219.appspot.com',
        '/api/v1/stores',
        offsets
    );

    final response = await http.get(uri);

    final json = jsonDecode(response.body);

    _stores.clear();

    for (Map store in json) {
      debugPrint(store['storeID']);
      _stores.add(Store(
          id: store['storeID'],
          name: store['storeName'],
          address: store['addr'],
          latitude: double.parse(store['latitude']),
          longitude: double.parse(store['longitude']),
          currentOccupancy: int.parse(store['occupancy'])));
    }

    _getMarkers();
  }

  void _getMarkers() {
    setState(() {
      _markers.clear();
      for (final store in _stores) {
        final marker = Marker(
          markerId: MarkerId(store.id),
          position: LatLng(store.latitude, store.longitude),
          onTap: () {
            setState(() {
              _currentInfo = 0;
              _currentName = store.name;
              _currentAddress = store.address;
              _currentOccupancy = store.currentOccupancy;
              _currentStore = store;
            });
          }
        );
        _markers["${store.id}"] = marker;
      }
    });
  }

  _setNewStore() async {
    Position position = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double latitude = position.latitude;
    double longitude = position.longitude;

    debugPrint('$latitude');
    debugPrint('$longitude');

    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: api_key,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        location: Location(latitude, longitude),
        radius: 100);

    if (p.placeId != null) {
      PlacesDetailsResponse place = await _places.getDetailsByPlaceId(p.placeId,
        fields: ['name', 'formatted_address', 'icon', 'geometry', 'types']);
      String name = place.result.name;
      String address = place.result.formattedAddress;
      latitude = place.result.geometry.location.lat;
      longitude = place.result.geometry.location.lng;
      String icon = place.result.icon;
      List types = place.result.types;
      bool acceptable = false;

      for (String type in _acceptableTypes) {
        if (types.contains(type)) {
          acceptable = true;
        }
      }

      if (acceptable) {
        _stores.add(Store(
            id: p.placeId,
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            currentOccupancy: 0));
        _getMarkers();

        var uri = Uri.https('pro-router-231219.appspot.com',
          '/api/v1/store/add',
            {
              'storeid': p.placeId,
              'storename': name,
              'address': address,
              'latitude': '$latitude',
              'longitude': '$longitude'
            }
        );
        await http.post(uri);

        debugPrint(uri.toString());
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Location'),
              content: Text('You can only add locations which serve essential supplies.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  List<Widget> _getContent() {
    if (_loaded) {
      return <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: true,
          onMapCreated: _onMapCreated,
          onTap: (latlng) {
            setState(() {
              _currentInfo = -100;
              _currentStore = null;
            });
          },
          initialCameraPosition: CameraPosition(
            target: _position,
            zoom: 13.0,
          ),
          markers: _markers.values.toSet()),
        AnimatedPositioned(
          top: _currentInfo, right: 0, left: 0,
          duration: Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              child: Container(
                  margin: EdgeInsets.all(20),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            blurRadius: 20,
                            offset: Offset.zero,
                            color: Colors.grey.withOpacity(0.5)
                        )]
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.store,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          heroTag: 'Store_Select',
                        ),
                      ), // first widget
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_currentName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    Text("$_currentAddress",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1)
                                  ]
                              )
                          )
                      )
                    ],
                  )
              ),
              onTap: () {
                if (_currentStore != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StorePage(_currentStore)
                      )
                  );
                }
              }
            )
          )  // end of Align
        )
      ];
    } else {
      return <Widget>[CircularProgressIndicator()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _getContent()
    );
  }
}