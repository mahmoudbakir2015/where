import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../business_logic/cubit/maps/maps_cubit.dart';
import '../../widgets/place_item.dart';

void buildCameraNewPosition({required BuildContext context}) {
  MapsCubit mapsCubit = MapsCubit.get(context);
  mapsCubit.goToSearchedForPlace = CameraPosition(
    bearing: 0.0,
    tilt: 0.0,
    target: LatLng(
      mapsCubit.selectedPlace.result.geometry.location.lat,
      mapsCubit.selectedPlace.result.geometry.location.lng,
    ),
    zoom: 13,
  );
}

Widget buildMap({required BuildContext context}) {
  MapsCubit mapsCubit = MapsCubit.get(context);
  return GoogleMap(
    mapType: MapType.normal,
    myLocationEnabled: true,
    zoomControlsEnabled: false,
    myLocationButtonEnabled: false,
    markers: mapsCubit.markers,
    initialCameraPosition: MapsCubit.myCurrentLocationCameraPosition,
    onMapCreated: (GoogleMapController controller) {
      mapsCubit.mapController.complete(controller);
    },
    polylines: mapsCubit.placeDirections != null
        ? {
            Polyline(
              polylineId: const PolylineId('my_polyline'),
              color: Colors.black,
              width: 2,
              points: mapsCubit.polylinePoints,
            ),
          }
        : {},
  );
}

Widget buildDirectionsBloc({required BuildContext context}) {
  MapsCubit mapsCubit = MapsCubit.get(context);
  return BlocListener<MapsCubit, MapsState>(
    listener: (context, state) {
      if (state is DirectionsLoaded) {
        mapsCubit.placeDirections = (state).placeDirections;

        mapsCubit.getPolylinePoints();
      }
    },
    child: Container(),
  );
}

void buildCurrentLocationMarker({required BuildContext context}) {
  MapsCubit mapsCubit = MapsCubit.get(context);
  mapsCubit.currentLocationMarker = Marker(
    position:
        LatLng(MapsCubit.position!.latitude, MapsCubit.position!.longitude),
    markerId: const MarkerId('2'),
    onTap: () {},
    infoWindow: const InfoWindow(title: "Your current Location"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );
  mapsCubit.addMarkerToMarkersAndUpdateUI(mapsCubit.currentLocationMarker);
}

Widget buildSuggestionsBloc({required BuildContext context}) {
  MapsCubit mapsCubit = MapsCubit.get(context);
  return BlocBuilder<MapsCubit, MapsState>(
    builder: (context, state) {
      if (state is PlacesLoaded) {
        mapsCubit.places = (state).places;
        if (mapsCubit.places.isNotEmpty) {
          return buildPlacesList(context: context);
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    },
  );
}

Widget buildPlacesList({required BuildContext context}) {
  MapsCubit mapsCubit = MapsCubit.get(context);
  return ListView.builder(
      itemBuilder: (ctx, index) {
        return InkWell(
          onTap: () async {
            mapsCubit.placeSuggestion = mapsCubit.places[index];
            mapsCubit.controller.close();
            mapsCubit.getSelectedPlaceLocation(context: context);
            mapsCubit.polylinePoints.clear();
            mapsCubit.removeAllMarkersAndUpdateUI();
          },
          child: PlaceItem(
            suggestion: mapsCubit.places[index],
          ),
        );
      },
      itemCount: mapsCubit.places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics());
}
