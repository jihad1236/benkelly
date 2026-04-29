import 'dart:async';

import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/features/tour/model/tour_stop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TourMapScreen extends StatefulWidget {
  final List<TourStop> tourStops;

  const TourMapScreen({super.key, required this.tourStops});

  @override
  State<TourMapScreen> createState() => _TourMapScreenState();
}

class _TourMapScreenState extends State<TourMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  late final List<LatLng> _points;
  late final Set<Marker> _markers;
  late final Set<Polyline> _polylines;

  @override
  void initState() {
    super.initState();

    _points = widget.tourStops
        .where((s) => s.latitude != null && s.longitude != null)
        .map((s) => LatLng(s.latitude!, s.longitude!))
        .toList();

    _markers = {};
    for (int i = 0; i < widget.tourStops.length; i++) {
      final stop = widget.tourStops[i];
      if (stop.latitude == null || stop.longitude == null) continue;
      _markers.add(
        Marker(
          markerId: MarkerId('stop_$i'),
          position: LatLng(stop.latitude!, stop.longitude!),
          infoWindow: InfoWindow(
            title: stop.name,
            snippet: stop.category ?? '',
          ),
          icon: i == 0
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : i == widget.tourStops.length - 1
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange),
        ),
      );
    }

    _polylines = {
      if (_points.length >= 2)
        Polyline(
          polylineId: const PolylineId('tour_route'),
          points: _points,
          color: const Color(0xFF6B7C4E),
          width: 4,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
    };
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _launchGoogleMaps() async {
    if (_points.isEmpty) return;

    final origin = _points.first;
    final destination = _points.last;

    String url;
    if (_points.length > 2) {
      final waypoints = _points
          .sublist(1, _points.length - 1)
          .map((p) => '${p.latitude},${p.longitude}')
          .join('|');
      url =
          'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=$waypoints&travelmode=walking';
    } else {
      url =
          'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=walking';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialTarget =
        _points.isNotEmpty ? _points.first : const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Map'),
        backgroundColor: AppColors.mutedOlive,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _mapController.complete(controller);
              if (_points.length >= 2) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  controller.animateCamera(
                    CameraUpdate.newLatLngBounds(
                      _boundsFromPoints(_points),
                      60,
                    ),
                  );
                });
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.tourStops.length} stops along this route',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _LegendRow(),
                  SizedBox(height: 12.h),
                  CommonButton(
                    text: 'Start Navigation in Google Maps',
                    backgroundColor: AppColors.mutedOlive,
                    onTap: _launchGoogleMaps,
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

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dot(Colors.green),
        SizedBox(width: 4.w),
        Text('Start', style: TextStyle(fontSize: 12.sp)),
        SizedBox(width: 12.w),
        _dot(Colors.orange),
        SizedBox(width: 4.w),
        Text('Waypoint', style: TextStyle(fontSize: 12.sp)),
        SizedBox(width: 12.w),
        _dot(Colors.red),
        SizedBox(width: 4.w),
        Text('End', style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
