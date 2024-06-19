part of '../place_picker_flutter.dart';

/// Place picker is controlled with PlacePickerController.
/// Place pin is lifted up whenever mapStartMoving() is called,
/// and will be down when mapFinishMoving() is called.
/// Refresh places list when refreshPlaces(places) is called.
class PlacePickerController {
  /// An action when map start to move.
  VoidCallback? mapStartMoving;

  /// An action when map finish moving.
  VoidCallback? mapFinishMoving;

  /// An action when refresh list of places.
  Function(List<Place> places)? refreshPlaces;
}