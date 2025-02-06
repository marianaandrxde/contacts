import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';  // Importando o pacote necessário
import 'package:contacts/models/contact.dart';
import 'package:contacts/controllers/contact_controller.dart'; // Importando o controller de contatos

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final ContactController _contactController = ContactController();  // Instância do controller de contatos

  Set<Marker> _markers = {};  // Set para armazenar os marcadores
  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(-5.091949, -42.803453),  // Posição inicial para Teresina
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _loadMarkers();  // Carregar os marcadores assim que o estado for iniciado
  }

  // Função para carregar os marcadores no mapa
  Future<void> _loadMarkers() async {
    // Buscar todos os contatos
    List<Contact> contacts = await _contactController.fetchAllContacts();

    // Criar um marcador para cada contato
    Set<Marker> markers = {};
    CameraPosition? firstMarkerPosition;

    for (var contact in contacts) {
      markers.add(Marker(
        markerId: MarkerId(contact.id.toString()),  // ID único para cada marcador
        position: LatLng(contact.latitude, contact.longitude),  // Posições do contato
        infoWindow: InfoWindow(title: contact.nome, snippet: contact.email),  //
      ));

      // Definir a posição da câmera para o primeiro marcador encontrado
      if (firstMarkerPosition == null) {
        firstMarkerPosition = CameraPosition(
          target: LatLng(contact.latitude, contact.longitude),
          zoom: 14.4746,  // Definir o zoom para o primeiro marcador
        );
      }
    }

    // Atualizar os marcadores no estado
    setState(() {
      _markers = markers;
      if (firstMarkerPosition != null) {
        _cameraPosition = firstMarkerPosition;
      }
    });

    // Mover a câmera para o primeiro marcador, se houver
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
        initialCameraPosition: _cameraPosition,  // Posição inicial do mapa
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);  // Completa o controller do Google Map
        },
        markers: _markers,  // Passando os marcadores para o mapa
      ),
    );
  }
}
