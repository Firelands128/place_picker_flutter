part of '../map_picker_flutter.dart';

/// MapPicker widget is main widget that gets map as a child.
/// It does not restrict user from using maps other than google map.
/// [MapPicker] is controlled with [MapPickerController] class object
class MapPicker extends StatefulWidget {
  /// Map widget, Google, Yandex Map or any other map can be used, see example
  final Widget map;

  /// [MapPicker] can be controller with [MapPickerController] object.
  /// you can call mapPickerController.mapMoving!() and
  /// mapPickerController.mapFinishedMoving!() for controlling the Map Pin.
  final MapPickerController mapPickerController;

  final ValueChanged<Place> onSelectPlace;

  final Future<List<Place>?> Function(String value) onSearch;

  /// Map pin widget in the center of the screen. [iconWidget] is used with
  /// animation controller
  final Widget? iconWidget;

  /// default value is true, defines, if there is a dot, at the bottom of the pin
  final bool showDot;

  const MapPicker({
    super.key,
    required this.map,
    required this.mapPickerController,
    required this.onSelectPlace,
    required this.onSearch,
    this.iconWidget,
    this.showDot = true,
  });

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker>
    with SingleTickerProviderStateMixin {
  static const double _dotRadius = 2.2;

  late AnimationController animationController;
  late Animation<double> translateAnimation;

  List<Place>? places;
  Place? selectedPlace;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    widget.mapPickerController.mapStartMoving = mapStartMoving;
    widget.mapPickerController.mapFinishMoving = mapFinishMoving;
    widget.mapPickerController.refreshPlaces = refreshPlaces;

    translateAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    ));
  }

  /// Start of animation when map starts dragging by user, checks the state
  /// before firing animation, thus optimizing for rendering purposes
  void mapStartMoving() {
    if (!animationController.isAnimating && !animationController.isCompleted) {
      animationController.forward();
    }
  }

  /// down the Pin whenever the map is released and goes to idle position
  void mapFinishMoving() {
    animationController.reverse();
  }

  void refreshPlaces(List<Place> places) {
    setState(() {
      this.places = places;
      selectedPlace = places.first;
    });
  }

  void onSearch(String value) async {
    final List<Place>? placeList = await widget.onSearch(value);
    setState(() => places = placeList);
  }

  void onSelectPlace(Place place) {
    setState(() => selectedPlace = place);
    widget.onSelectPlace(place);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    widget.map,
                    Positioned(
                      bottom: constraints.maxHeight * 0.5,
                      child: AnimatedBuilder(
                          animation: animationController,
                          builder: (context, snapshot) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                if (widget.showDot)
                                  Container(
                                    width: _dotRadius,
                                    height: _dotRadius,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(_dotRadius),
                                    ),
                                  ),
                                Transform.translate(
                                  offset:
                                      Offset(0, -15 * translateAnimation.value),
                                  child: widget.iconWidget,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.4,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    onSubmitted: onSearch,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PlaceList(
                    places: places,
                    selectedPlace: selectedPlace,
                    onSelectPlace: onSelectPlace,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
