import 'package:flutter/material.dart';

import '../map_picker_flutter.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({
    super.key,
    required this.places,
    required this.selectedPlace,
    required this.onSelectPlace,
  });

  final List<Place>? places;
  final Place? selectedPlace;
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
