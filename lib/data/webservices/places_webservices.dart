import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/strings.dart';

class PlacesWebservices {
  late Dio dio;

  PlacesWebservices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSuggestions(
      String place, String sessionToken) async {
    try {
      Response response = await dio.get(
        suggestionsBaseUrl,
        queryParameters: {
          'input': place,
          // جرب تشيل أو تغير types لو بيرجع []
          'types': 'address',
          'components': 'country:eg',
          'key': googleAPIKey,
          'sessiontoken': sessionToken,
        },
      );

      log("MahmoudBakir I'm testing suggestions");
      log("🔎 Full Response: ${response.data.toString()}");

      if (response.data is Map) {
        final status = response.data['status'];
        final errorMessage = response.data['error_message'];
        final predictions = response.data['predictions'];

        log("📌 Status: $status");
        log("⚠️ Error message: $errorMessage");
        log("📍 Predictions: ${predictions.toString()}");

        return predictions ?? [];
      } else {
        log("❌ Unexpected response format: ${response.data.runtimeType}");
        return [];
      }
    } catch (error) {
      log("🔥 Exception: $error");
      return [];
    }
  }

  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        placeLocationBaseUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': googleAPIKey,
          'sessiontoken': sessionToken
        },
      );
      return response.data;
    } catch (error) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }

  // origin equals current location
  // destination equals searched for location
  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(
        directionsBaseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleAPIKey,
        },
      );
      log("MahmoudBakir I'm testing directions");
      log(response.data);
      return response.data;
    } catch (error) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }
}
