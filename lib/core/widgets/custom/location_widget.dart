import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoder;

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.isReadable,
    required this.isEditable,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isReadable;
  final bool isEditable;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Logger logger = Logger();
  final Location _location = Location();
  LocationData? _currentLocation;
  late String _currentAddress = '';

  @override
  void initState() {
    super.initState();
    _getLocation().then((value) => _getAddressFromLatLng());
  }

  Future<void> _getLocation() async {

    // Check and request location permission using permission_handler
    var status = await Permission.location.status;
    if (status.isRestricted || status.isDenied) {
      await Permission.location.request();
      status = await Permission.location.status;
      if (status.isDenied) {
        return;
      }
    }

    // Get current location
    try {
      LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
        widget.controller.text = "${_currentLocation!.latitude}, ${_currentLocation!.longitude}";
        // _getAddressFromLatLng();
      });
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<geocoder.Placemark> placemarks = await geocoder.placemarkFromCoordinates(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!
      );
      logger.i('Getting location ${placemarks[0]}');
      geocoder.Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}, ${place.postalCode}";
      });
    } catch (e) {
      logger.e(e);
      showError(e.toString());
    }
  }

  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error getting location: $error'),
            duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _currentLocation != null
                ? "Location: $_currentAddress"
                : "Location not available",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
            ),
            onChanged: widget.onChanged,
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     _currentLocation != null
        //         ? "Lat: ${_currentLocation!.latitude}, Long: ${_currentLocation!.longitude}"
        //         : "Lat: N/A, Long: N/A",
        //     style: const TextStyle(fontSize: 16),
        //   ),
        // )
      ],
    );
  }
}