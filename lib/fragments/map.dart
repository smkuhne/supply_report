import 'package:flutter/material.dart';
import 'package:preliminary/models/store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:preliminary/controllers/map_controller.dart';

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

  void initState() {
    super.initState();
    _updateCurrentPosition();
    _populateStores();
    _getMarkers();
  }

  _MapPageState(MapController _controller) {
    _controller.updateCurrentPosition = _updateCurrentPosition;
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

  void _getMarkers() {
    setState(() {
      _markers.clear();
      for (final store in _stores) {
        final marker = Marker(
          markerId: MarkerId(store.name),
          position: LatLng(store.latitude, store.longitude),
          infoWindow: InfoWindow(
            title: store.name,
            snippet: store.address,
          ),
        );
        _markers["${store.id}"] = marker;
      }
    });
  }

  Widget _getContent() {
    if (_loaded) {
      return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _position,
            zoom: 13.0,
          ),
          markers: _markers.values.toSet()
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _getContent()
    );
  }
}