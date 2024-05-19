part of '../map_picker_flutter.dart';

class Place {
  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
  });

  final String id;
  final String name;
  final String address;
  final LatLng location;
}
