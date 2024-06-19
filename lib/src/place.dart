part of '../place_picker_flutter.dart';

/// [Place] data class
class Place {
  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
  });

  /// The identification of place
  final String id;

  /// The name of place
  final String name;

  /// The address of place
  final String address;

  /// The location of place
  final LatLng location;
}
