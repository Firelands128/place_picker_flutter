import 'package:amap_flutter/amap_flutter.dart';
import 'package:amap_webservice/amap_webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_picker_flutter/map_picker_flutter.dart';

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
  final mapPickerController = MapPickerController();
  final textController = TextEditingController();
  final aMapWebService = AMapWebService(
    apiKey: "0e2f6cd577c7b01f2f10e8a8a4cdf153",
    secretKey: "36b5528aecd3e4aba379e1ef352820fd",
  );
  late AMapController aMapController;

  CameraPosition cameraPosition = CameraPosition(
    position: Position(latitude: 34.24001, longitude: 108.912078),
    zoom: 14,
  );

  void refreshNearBy() async {
    Position? position = cameraPosition.position;
    if (position != null) {
      final response = await aMapWebService.searchAround(LatLng(
        position.latitude,
        position.longitude,
      ));
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
        mapPickerController.refreshPlaces?.call(places);
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
    final position = Position(
      latitude: place.location.latitude,
      longitude: place.location.longitude,
    );
    aMapController.moveCamera(CameraPosition(
      position: position,
      heading: cameraPosition.heading,
      skew: cameraPosition.skew,
      zoom: cameraPosition.zoom,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            mapPickerController: mapPickerController,
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
              onCameraChangeStart: (_) {
                mapPickerController.mapStartMoving!();
              },
              onCameraChange: (cameraPosition) {
                this.cameraPosition = cameraPosition;
                textController.text = "${cameraPosition.position?.latitude}, "
                    "${cameraPosition.position?.longitude}";
              },
              onCameraChangeFinish: (_) {
                mapPickerController.mapFinishMoving!();
                refreshNearBy();
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            width: 220,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300]!.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                maxLines: 2,
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                controller: textController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
