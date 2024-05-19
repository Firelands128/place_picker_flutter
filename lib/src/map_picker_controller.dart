part of '../map_picker_flutter.dart';

/// Map picker is controlled with MapPickerController. Map pin is lifted up
/// whenever mapMoving() is called, and will be down when mapFinishedMoving()
/// is called.
class MapPickerController {
  VoidCallback? mapStartMoving;
  VoidCallback? mapFinishMoving;
  Function(List<Place> places)? refreshPlaces;
}