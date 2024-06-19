import 'package:amap_flutter/amap_flutter.dart';
import 'package:amap_webservice/amap_webservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:place_picker_flutter/place_picker_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AMapFlutter.init(
      apiKey: ApiKey(
        iosKey: "a4a1394fe817c2f86a424b897b4a9af4",
        androidKey: "d0065c21d2aedd0b234bfb7b88e5d6b2",
      ),
      agreePrivacy: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final placePickerController = PlacePickerController();
  final aMapWebService = AMapWebService(
    apiKey: "0e2f6cd577c7b01f2f10e8a8a4cdf153",
    secretKey: "36b5528aecd3e4aba379e1ef352820fd",
  );
  AMapController? aMapController;

  CameraPosition cameraPosition = CameraPosition(
    position: const LatLng(34.24001, 108.912078),
    zoom: 14,
  );

  void refreshNearBy() async {
    LatLng? position = cameraPosition.position;
    if (position != null) {
      final response = await aMapWebService.searchAround(position);
      if (response.pois != null) {
        List<Place> places = [];
        for (var poi in response.pois!) {
          if (poi.id != null &&
              poi.name != null &&
              poi.address != null &&
              poi.location != null) {
            places.add(Place(
              id: poi.id!,
              name: poi.name!,
              address: poi.address!,
              location: poi.location!,
            ));
          }
        }
        placePickerController.refreshPlaces?.call(places);
      }
    }
  }

  Future<List<Place>?> onSearch(String value) async {
    final response = await aMapWebService.textSearch(keywords: value);
    if (response.pois != null) {
      List<Place> places = [];
      for (var poi in response.pois!) {
        if (poi.id != null &&
            poi.name != null &&
            poi.address != null &&
            poi.location != null) {
          places.add(Place(
            id: poi.id!,
            name: poi.name!,
            address: poi.address!,
            location: poi.location!,
          ));
        }
      }
      return places;
    }
    return null;
  }

  void onSelectPoi(Place place) {
    final position = place.location;
    cameraPosition = CameraPosition(
      position: position,
      heading: cameraPosition.heading,
      skew: cameraPosition.skew,
      zoom: cameraPosition.zoom,
    );
    aMapController?.moveCamera(cameraPosition);
  }

  void onCameraChange(CameraPosition position) {
    placePickerController.mapStartMoving!();
    setState(() {
      cameraPosition = position;
    });
  }

  void onCameraChangeFinish(CameraPosition _) {
    placePickerController.mapFinishMoving!();
    refreshNearBy();
  }

  void onMapMove(LatLng latLng) {
    placePickerController.mapStartMoving!();
    setState(() {
      cameraPosition = cameraPosition.copyWith(position: latLng);
    });
  }

  void onMapMoveEnd(LatLng latLng) {
    placePickerController.mapFinishMoving!();
    refreshNearBy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          PlacePicker(
            placePickerController: placePickerController,
            iconWidget: SvgPicture.asset(
              "assets/location.svg",
              height: 60,
            ),
            onSelectPlace: onSelectPoi,
            onSearch: onSearch,
            map: AMapFlutter(
              initCameraPosition: cameraPosition,
              logoPosition: UIControlPosition(
                anchor: UIControlAnchor.bottomLeft,
                offset: UIControlOffset(x: 10, y: 10),
              ),
              compassControlEnabled: false,
              scaleControlEnabled: false,
              zoomControlEnabled: false,
              hawkEyeControlEnabled: false,
              mapTypeControlEnabled: false,
              geolocationControlEnabled: false,
              showUserLocation: false,
              onMapCreated: (controller) => aMapController = controller,
              onMapCompleted: refreshNearBy,
              onCameraChange: kIsWeb ? null : onCameraChange,
              onCameraChangeFinish: kIsWeb ? null : onCameraChangeFinish,
              onMapMove: kIsWeb ? onMapMove : null,
              onMapMoveEnd: kIsWeb ? onMapMoveEnd : null,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300]!.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                "${cameraPosition.position?.latitude}, "
                "${cameraPosition.position?.longitude}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
