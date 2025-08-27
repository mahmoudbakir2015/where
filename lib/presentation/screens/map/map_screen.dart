import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:where/presentation/screens/map/items.dart';
import '../../../business_logic/cubit/maps/maps_cubit.dart';
import '../../../constants/my_colors.dart';
import '../../../helpers/location_helper.dart';
import '../../widgets/distance_and_time.dart';
import '../../widgets/drawer/my_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // these variables for getDirections

  @override
  initState() {
    super.initState();
    getMyCurrentLocation();
  }

  Widget buildSelectedPlaceLocationBloc({required BuildContext context}) {
    MapsCubit mapsCubit = MapsCubit.get(context);
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          mapsCubit.selectedPlace = (state).place;

          goToMySearchedForLocation();
          mapsCubit.getDirections(context: context);
        }
      },
      child: Container(),
    );
  }

  Widget buildFloatingSearchBar({required BuildContext context}) {
    MapsCubit mapsCubit = MapsCubit.get(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: mapsCubit.controller,
      elevation: 6,
      hintStyle: const TextStyle(fontSize: 18),
      queryStyle: const TextStyle(fontSize: 18),
      hint: 'Find a place..',
      border: const BorderSide(style: BorderStyle.none),
      margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      progress: mapsCubit.progressIndicator,
      onQueryChanged: (query) {
        mapsCubit.getPlacesSuggestions(query, context: context);
      },
      onFocusChanged: (_) {
        // hide distance and time row
        setState(() {
          mapsCubit.isTimeAndDistanceVisible = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
              icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6)),
              onPressed: () {}),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(context: context),
              buildSelectedPlaceLocationBloc(context: context),
              buildDirectionsBloc(context: context),
            ],
          ),
        );
      },
    );
  }

  void buildSearchedPlaceMarker({required BuildContext context}) {
    MapsCubit mapsCubit = MapsCubit.get(context);
    mapsCubit.searchedPlaceMarker = Marker(
      position: mapsCubit.goToSearchedForPlace.target,
      markerId: const MarkerId('1'),
      onTap: () {
        buildCurrentLocationMarker(context: context);
        // show time and distance
        setState(() {
          mapsCubit.isSearchedPlaceMarkerClicked = true;
          mapsCubit.isTimeAndDistanceVisible = true;
        });
      },
      infoWindow: InfoWindow(title: mapsCubit.placeSuggestion.description),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    mapsCubit.addMarkerToMarkersAndUpdateUI(mapsCubit.searchedPlaceMarker);
  }

  Future<void> getMyCurrentLocation() async {
    MapsCubit.position =
        await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> goToMySearchedForLocation() async {
    MapsCubit mapsCubit = MapsCubit.get(context);
    buildCameraNewPosition(context: context);
    final GoogleMapController controller = await mapsCubit.mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(mapsCubit.goToSearchedForPlace));
    // ignore: use_build_context_synchronously
    buildSearchedPlaceMarker(context: context);
  }

  @override
  Widget build(BuildContext context) {
    MapsCubit mapsCubit = MapsCubit.get(context);
    return Scaffold(
      // drawer: const MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapsCubit.position != null
              ? buildMap(context: context)
              : const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.blue,
                  ),
                ),
          buildFloatingSearchBar(context: context),
          mapsCubit.isSearchedPlaceMarkerClicked
              ? DistanceAndTime(
                  isTimeAndDistanceVisible: mapsCubit.isTimeAndDistanceVisible,
                  placeDirections: mapsCubit.placeDirections,
                )
              : Container(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: MyColors.blue,
          onPressed: mapsCubit.goToMyCurrentLocation,
          child: const Icon(Icons.place, color: Colors.white),
        ),
      ),
    );
  }
}
