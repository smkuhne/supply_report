import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preliminary/models/store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:preliminary/controllers/map_controller.dart';
import 'package:preliminary/fragments/store_page.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.controller}) : super(key: key);

  final MapController controller;

  @override
  _MapPageState createState() => _MapPageState(controller);
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;
  LatLng _position;
  bool _loaded = false;
  List<Store> _stores = [];
  Map<String, Marker> _markers = {};
  int id = 0;
  double _info = -100;
  String _name = "Location";
  double _latitude = 0;
  double _longitude = 0;
  Store _current = null;
  bool _newStore = false;


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
    _stores.add(Store(
        id: 0,
        name: 'Safeway',
        address: 'Branham',
        latitude: 37.267237,
        longitude: -121.833264,
        currentOccupancy: 0));
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

  void _reload() {

  }

  void _getMarkers() {
    setState(() {
      _markers.clear();
      for (final store in _stores) {
        final marker = Marker(
          markerId: MarkerId(store.name),
          position: LatLng(store.latitude, store.longitude),
          onTap: () {
            setState(() {
              _info = 0;
              _name = store.name;
              _latitude = store.latitude;
              _longitude = store.longitude;
              _current = store;
            });
          }
        );
        _markers["${store.id}"] = marker;
      }
    });
  }

  _setNewStore(bool enabled) {
    _newStore = enabled;
    
    if (!_newStore) {
      setState(() {
        _markers.remove('current');
        _info = -100;
        _current = null;
      });
    }
  }

  void _setMarker(latlng) {
    setState(() {
      final marker = Marker(
        markerId: MarkerId('New Location'),
        position: LatLng(latlng.latitude, latlng.longitude),
        onTap: () {
          setState(() {
            _info = 0;
            _name = 'New Location';
            _latitude = latlng.latitude;
            _longitude = latlng.longitude;
            _current = null;
          });
        }
      );
      _markers['current'] = marker;
    });
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
            if (_newStore) {
              _setMarker(latlng);
            }
            setState(() {
              _info = -100;
              _current = null;
            });
          },
          initialCameraPosition: CameraPosition(
            target: _position,
            zoom: 13.0,
          ),
          markers: _markers.values.toSet()),
        AnimatedPositioned(
          top: _info, right: 0, left: 0,
          duration: Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.topCenter,
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
                      onPressed: () {
                          if (_current != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StorePage(_current)
                              )
                            );
                        }
                      },
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
                            Text(_name),
                            Text("$_latitude"),
                            Text("$_longitude")
                          ]
                      )
                    )
                  )
                ],
              )
            )  // end of Container
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