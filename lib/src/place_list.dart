import 'package:flutter/material.dart';

import '../place_picker_flutter.dart';

/// [PlaceList] widget is a [ListView] widget that contains places list.
class PlaceList extends StatelessWidget {
  const PlaceList({
    super.key,
    required this.places,
    required this.selectedPlace,
    required this.onSelectPlace,
  });

  /// List of places to show.
  final List<Place>? places;

  /// Selected place that show checked icon on tailing.
  final Place? selectedPlace;

  /// A callback function when select a place.
  final ValueChanged<Place> onSelectPlace;

  @override
  Widget build(BuildContext context) {
    if (places == null || places!.isEmpty) {
      return Container();
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: places!
          .map(
            (place) => ListTile(
              title: Text(place.name),
              subtitle: Text(place.address),
              trailing: selectedPlace?.id == place.id
                  ? const Icon(Icons.check_circle)
                  : null,
              onTap: () => onSelectPlace(place),
            ),
          )
          .toList(),
    );
  }
}
