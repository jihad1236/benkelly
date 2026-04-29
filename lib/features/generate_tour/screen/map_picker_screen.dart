import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/utils/constants/colors.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;
  final String title;

  const MapPickerScreen({super.key, this.initialPosition, required this.title});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  static const LatLng _defaultPosition = LatLng(23.8103, 90.4125);

  LatLng? _pickedLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _setMarker(widget.initialPosition!);
    }
  }

  void _setMarker(LatLng position) {
    setState(() {
      _pickedLocation = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('picked'),
          position: position,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet:
                '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
          ),
        ),
      );
    });
  }

  void _confirm() {
    if (_pickedLocation == null) {
      Get.snackbar('No Location', 'Please tap on the map to select a location');
      return;
    }
    Get.back(result: _pickedLocation);
  }

  @override
  Widget build(BuildContext context) {
    final initialTarget = widget.initialPosition ?? _defaultPosition;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_pickedLocation != null)
            TextButton(
              onPressed: _confirm,
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: 14,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController.complete(controller),
            onTap: _setMarker,
          ),
          if (_pickedLocation == null)
            Positioned(
              bottom: 80.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Tap anywhere on the map to select a location',
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          if (_pickedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selected: ${_pickedLocation!.latitude.toStringAsFixed(5)}, ${_pickedLocation!.longitude.toStringAsFixed(5)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Confirm Location',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
