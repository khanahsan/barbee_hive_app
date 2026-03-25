import 'package:geolocator/geolocator.dart';

enum LocationErrorCode { serviceDisabled, permissionDenied, permissionDeniedForever }

class LocationException implements Exception {
  LocationException(this.code, this.message);

  final LocationErrorCode code;
  final String message;

  @override
  String toString() => message;
}

class LocationService {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Do not auto-redirect to Settings. Let UI decide how to prompt.
      throw LocationException(
        LocationErrorCode.serviceDisabled,
        'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException(
          LocationErrorCode.permissionDenied,
          'Location permissions are denied.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Do not auto-redirect to Settings after denial.
      throw LocationException(
        LocationErrorCode.permissionDeniedForever,
        'Location permissions are permanently denied.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
