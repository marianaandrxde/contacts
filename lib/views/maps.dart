import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:contacts/models/contact.dart';
import 'package:contacts/controllers/contact_controller.dart'; 

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final ContactController _contactController = ContactController();  
  Set<Marker> _markers = {};  
  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(-5.091949, -42.803453),  
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _loadMarkers(); 
  }

  Future<void> _loadMarkers() async {
    List<Contact> contacts = await _contactController.fetchAllContacts();

    Set<Marker> markers = {};
    CameraPosition? firstMarkerPosition;

    for (var contact in contacts) {
      markers.add(Marker(
        markerId: MarkerId(contact.id.toString()),  
        position: LatLng(contact.latitude, contact.longitude),  
        infoWindow: InfoWindow(title: contact.nome, snippet: contact.email),  
      ));

      if (firstMarkerPosition == null) {
        firstMarkerPosition = CameraPosition(
          target: LatLng(contact.latitude, contact.longitude),
          zoom: 14.4746,  
        );
      }
    }

    setState(() {
      _markers = markers;
      if (firstMarkerPosition != null) {
        _cameraPosition = firstMarkerPosition;
      }
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Contatos'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _cameraPosition,  
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);  
        },
        markers: _markers,  
      ),
    );
  }
}
