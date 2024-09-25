part of '../place_picker_flutter.dart';

/// PlacePicker widget is main widget that receives any map as a child.
/// It does not restrict user from using maps other than google map.
/// [PlacePicker] is controlled with [PlacePickerController].
class PlacePicker extends StatefulWidget {
  const PlacePicker({
    super.key,
    required this.map,
    required this.placePickerController,
    required this.onSelectPlace,
    required this.onSearch,
    this.iconWidget,
    this.showDot = true,
  });

  /// Custom map widget
  final Widget map;

  /// [PlacePicker] can be controller with [PlacePickerController] object.
  /// you can call placePickerController.mapStartMoving!() and
  /// placePickerController.mapFinishMoving!() for controlling the Map Pin.
  final PlacePickerController placePickerController;

  /// A callback function that inform parent widget which place is selected.
  final ValueChanged<Place> onSelectPlace;

  /// A callback function that inform parent widget to search places by keywords.
  final Future<List<Place>?> Function(String value) onSearch;

  /// Place pin widget in the center of the screen.
  /// [iconWidget] is used with animation controller.
  final Widget? iconWidget;

  /// Default value is true, defines, if there is a dot, at the bottom of the pin
  final bool showDot;

  @override
  State<PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker>
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

    widget.placePickerController.mapStartMoving = mapStartMoving;
    widget.placePickerController.mapFinishMoving = mapFinishMoving;
    widget.placePickerController.refreshPlaces = refreshPlaces;

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

  /// Down the Pin whenever the map is released and goes to idle position
  void mapFinishMoving() {
    animationController.reverse();
  }

  /// Refresh provided places.
  void refreshPlaces(List<Place> places) {
    setState(() {
      this.places = places;
      selectedPlace = places.isNotEmpty ? places.first : null;
    });
  }

  /// A callback function when search places by keywords.
  void onSearch(String value) async {
    final List<Place>? placeList = await widget.onSearch(value);
    setState(() => places = placeList);
  }

  /// A callback function when select a place.
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
