# Place Picker for Flutter

[![pub package](https://img.shields.io/pub/v/place_picker_flutter.svg)](https://pub.dev/packages/place_picker_flutter)

A Flutter package that provide place picker functionality on custom map.

## Features
This package provide the following features:
* Indicate the selected place by a animated pin.
* Picking place can be done by dragging map.
* Picking place can be done by selecting a POI.
* The ability of searching POIs by keyword.

## Installation
In the ```dependencies:``` section of your ```pubspec.yaml```, add the following line:
``` yaml
place_picker_flutter: <latest_version>
```

## Usage
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: PlacePicker(
      placePickerController: placePickerController,
      iconWidget: SvgPicture.asset(
        "assets/location.svg",
        height: 60,
      ),
      onSelectPlace: <callback function when select POI>,
      onSearch: <callback function when search keyword>,
      map: <custom map widget>,
    ),
  );
```
```PlacePickerController``` can control place pin lifting up and down, also can refresh places list.
```iconWidget``` can custom place pin icon.
```onSelectPlace``` is a callback function when selecing a place from place list.
```onSearch``` is a callback function when search POIs by keyword entered in search bar.
```map``` is custom map widget to show map.

More detail usage can reference the example app.