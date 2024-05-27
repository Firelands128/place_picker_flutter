part of '../map_picker_flutter.dart';

/// Map picker is controlled with MapPickerController.
/// Map pin is lifted up whenever mapStartMoving() is called,
/// and will be down when mapFinishMoving() is called.
/// Refresh places list when refreshPlaces(places) is called.
class MapPickerController {
  /// An action when map start to move.
  VoidCallback? mapStartMoving;

  /// An action when map finish moving.
  VoidCallback? mapFinishMoving;

  /// An action when refresh list of places.
  Function(List<Place> places)? refreshPlaces;
}