// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:benkelly864/core/common/widgets/custom_appbar.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/tour/model/tour_stop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  final List<TourStop> tourStops;

  const HomeScreen({super.key, this.tourStops = const <TourStop>[]});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasLocationPermission = false;
  LatLng? _currentLocation;
  LatLng? _searchedLocation;
  GoogleMapController? _mapController;
  CameraPosition? _lastCameraPosition;

  final TextEditingController _placeSearchController = TextEditingController();

  Set<Polyline> _roadPolylines = const <Polyline>{};

  String? get _mapApiKey {
    String? key;
    try {
      key = dotenv.env['NEXT_PUBLIC_GOOGLE_MAPS_API_KEY'];
    } catch (_) {
      return null;
    }
    if (key == null || key.isEmpty) return null;
    return key;
  }

  List<LatLng> get _tourPoints => widget.tourStops
      .where((stop) => stop.latitude != null && stop.longitude != null)
      .map((stop) => LatLng(stop.latitude!, stop.longitude!))
      .toList();

  @override
  void initState() {
    super.initState();
    _syncLocationPermissionStatus();
    _loadTourRoadPolyline();
  }

  @override
  void dispose() {
    _placeSearchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _syncLocationPermissionStatus() async {
    final status = await Permission.locationWhenInUse.status;
    if (!mounted) return;
    setState(() {
      _hasLocationPermission = status.isGranted;
    });
  }

  Future<void> _loadTourRoadPolyline() async {
    final points = _tourPoints;
    if (points.length < 2) {
      if (!mounted) return;
      setState(() {
        _roadPolylines = const <Polyline>{};
      });
      return;
    }

    final mapKey = _mapApiKey;
    if (mapKey == null) {
      if (!mounted) return;
      setState(() {
        _roadPolylines = {
          Polyline(
            polylineId: const PolylineId('tour-fallback-route'),
            points: points,
            color: Colors.redAccent,
            width: 4,
          ),
        };
      });
      return;
    }

    final mergedRoutePoints = <LatLng>[];

    for (var i = 0; i < points.length - 1; i++) {
      final segment = await _fetchRoadSegment(
        origin: points[i],
        destination: points[i + 1],
        mapApiKey: mapKey,
      );

      if (segment.isEmpty) {
        if (mergedRoutePoints.isEmpty) {
          mergedRoutePoints.add(points[i]);
        } else if (!_isSameCoordinate(mergedRoutePoints.last, points[i])) {
          mergedRoutePoints.add(points[i]);
        }
        mergedRoutePoints.add(points[i + 1]);
        continue;
      }

      if (mergedRoutePoints.isNotEmpty &&
          _isSameCoordinate(mergedRoutePoints.last, segment.first)) {
        mergedRoutePoints.addAll(segment.skip(1));
      } else {
        mergedRoutePoints.addAll(segment);
      }
    }

    final finalRoute = mergedRoutePoints.isEmpty ? points : mergedRoutePoints;

    if (!mounted) return;
    setState(() {
      _roadPolylines = {
        Polyline(
          polylineId: const PolylineId('tour-road-route'),
          points: finalRoute,
          color: Colors.redAccent,
          width: 5,
          geodesic: true,
        ),
      };
    });
  }

  Future<List<LatLng>> _fetchRoadSegment({
    required LatLng origin,
    required LatLng destination,
    required String mapApiKey,
  }) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'mode': 'walking',
      'key': mapApiKey,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) return const <LatLng>[];

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return const <LatLng>[];

      final routes = decoded['routes'];
      if (routes is! List || routes.isEmpty) return const <LatLng>[];

      final firstRoute = routes.first;
      if (firstRoute is! Map) return const <LatLng>[];

      final overviewPolyline = firstRoute['overview_polyline'];
      if (overviewPolyline is! Map) return const <LatLng>[];

      final encoded = overviewPolyline['points'];
      if (encoded is! String || encoded.isEmpty) return const <LatLng>[];

      return _decodePolyline(encoded);
    } catch (_) {
      return const <LatLng>[];
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    var index = 0;
    var lat = 0;
    var lng = 0;

    while (index < encoded.length) {
      var shift = 0;
      var result = 0;
      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  bool _isSameCoordinate(LatLng a, LatLng b) {
    return (a.latitude - b.latitude).abs() < 1e-6 &&
        (a.longitude - b.longitude).abs() < 1e-6;
  }

  // Default location - Dhaka, Bangladesh
  static const LatLng defaultLocation = LatLng(23.8103, 90.4125);

  void _focusOnSearchedPlace(Prediction prediction) {
    final lat = double.tryParse(prediction.lat ?? '');
    final lng = double.tryParse(prediction.lng ?? '');
    if (lat == null || lng == null) return;

    final location = LatLng(lat, lng);
    final camera = CameraPosition(target: location, zoom: 16);

    if (!mounted) return;
    setState(() {
      _searchedLocation = location;
      _lastCameraPosition = camera;
    });

    _mapController?.animateCamera(CameraUpdate.newCameraPosition(camera));
  }

  Future<void> _focusOnTourBounds() async {
    final points = _tourPoints;
    AppLoggerHelper.info(
      '_focusOnTourBounds called. Tour points: ${points.length}',
    );

    if (points.isEmpty || _mapController == null) {
      AppLoggerHelper.warning(
        'Cannot focus on tour bounds - points: ${points.length}, controller: ${_mapController != null}',
      );
      return;
    }

    try {
      bool allPointsSame = points.every(
        (p) =>
            p.latitude == points.first.latitude &&
            p.longitude == points.first.longitude,
      );

      if (allPointsSame) {
        AppLoggerHelper.info(
          'All tour points are at same location. Focusing with zoom level 15',
        );
        final camera = CameraPosition(target: points.first, zoom: 15.0);
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(camera),
        );
      } else {
        final bounds = _calculateBounds(points);
        AppLoggerHelper.info(
          'Calculated bounds: SW(${bounds.southwest.latitude}, ${bounds.southwest.longitude}) to NE(${bounds.northeast.latitude}, ${bounds.northeast.longitude})',
        );

        final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
        await _mapController!.animateCamera(cameraUpdate);
      }

      AppLoggerHelper.info('Camera animation completed');
    } catch (e) {
      AppLoggerHelper.error('Error focusing on tour bounds', e);
    }
  }

  Future<void> _focusOnCurrentUserLocation() async {
    final hasPermission = await Permission.locationWhenInUse.isGranted;
    if (!hasPermission) {
      final status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final location = LatLng(position.latitude, position.longitude);

      if (!mounted) return;
      setState(() {
        _currentLocation = location;
      });

      final camera = CameraPosition(target: location, zoom: 16.0);
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(camera),
      );

      AppLoggerHelper.info('Focused on user location: $location');
    } catch (e) {
      AppLoggerHelper.error('Error getting user location', e);
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = point.latitude < minLat ? point.latitude : minLat;
      maxLat = point.latitude > maxLat ? point.latitude : maxLat;
      minLng = point.longitude < minLng ? point.longitude : minLng;
      maxLng = point.longitude > maxLng ? point.longitude : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Set<Circle> _buildCurrentLocationCircle() {
    if (_currentLocation == null) return const <Circle>{};
    return {
      Circle(
        circleId: const CircleId('current-location'),
        center: _currentLocation!,
        radius: 6437,
        fillColor: Colors.blue.withValues(alpha: 0.1),
        strokeColor: Colors.blue.withValues(alpha: 0.5),
        strokeWidth: 2,
      ),
    };
  }

  Set<Marker> _buildMarkers(LatLng fallbackTarget) {
    final markers = <Marker>{};

    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current-location'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: 'Current location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    if (_searchedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('searched-location'),
          position: _searchedLocation!,
          infoWindow: const InfoWindow(title: 'Selected place'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    for (var i = 0; i < widget.tourStops.length; i++) {
      final stop = widget.tourStops[i];
      if (stop.latitude == null || stop.longitude == null) continue;

      markers.add(
        Marker(
          markerId: MarkerId('tour-stop-$i'),
          position: LatLng(stop.latitude!, stop.longitude!),
          infoWindow: InfoWindow(
            title: '${i + 1}. ${stop.name}',
            snippet: stop.category ?? stop.description,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    if (markers.isEmpty) {
      markers.add(
        Marker(
          markerId: const MarkerId('fallback-location'),
          position: fallbackTarget,
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildTourPolyline() {
    if (_roadPolylines.isNotEmpty) {
      return _roadPolylines;
    }

    final points = _tourPoints;
    if (points.length < 2) return const <Polyline>{};

    return {
      Polyline(
        polylineId: const PolylineId('tour-route'),
        points: points,
        color: Colors.redAccent,
        width: 4,
      ),
    };
  }

  Widget _buildPlaceSearchField(String mapKey) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: _placeSearchController,
        googleAPIKey: mapKey,
        debounceTime: 600,
        isLatLngRequired: true,
        inputDecoration: InputDecoration(
          hintText: 'Search place',
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        boxDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        itemClick: (Prediction prediction) {
          final description = prediction.description ?? '';
          _placeSearchController.text = description;
          _placeSearchController.selection = TextSelection.fromPosition(
            TextPosition(offset: description.length),
          );
          _focusOnSearchedPlace(prediction);
        },
        getPlaceDetailWithLatLng: (Prediction prediction) {
          _focusOnSearchedPlace(prediction);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapKey = _mapApiKey;
    final hasMapKey = mapKey != null;

    AppLoggerHelper.info(
      'HomeScreen build - Tour stops: ${widget.tourStops.length}',
    );
    for (var i = 0; i < widget.tourStops.length; i++) {
      final stop = widget.tourStops[i];
      AppLoggerHelper.debug(
        'Stop $i: ${stop.name} (${stop.latitude}, ${stop.longitude})',
      );
    }

    final initialTarget = _currentLocation ?? defaultLocation;
    final zoom = _currentLocation == null ? 12.0 : 15.0;
    final initialCameraPosition =
        _lastCameraPosition ??
        CameraPosition(target: initialTarget, zoom: zoom);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "Home", showBack: false),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: hasMapKey
                      ? Stack(
                          children: [
                            GoogleMap(
                              circles: _buildCurrentLocationCircle(),
                              markers: _buildMarkers(defaultLocation),
                              polylines: _buildTourPolyline(),
                              initialCameraPosition: initialCameraPosition,
                              myLocationEnabled: _hasLocationPermission,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: true,
                              onCameraMove: (position) {
                                _lastCameraPosition = position;
                              },
                              onMapCreated: (controller) {
                                _mapController = controller;
                                if (widget.tourStops.isNotEmpty) {
                                  Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () => _focusOnTourBounds(),
                                  );
                                }
                              },
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: _buildPlaceSearchField(mapKey),
                            ),
                            Positioned(
                              bottom: 100,
                              right: 12,
                              child: FloatingActionButton(
                                mini: true,
                                backgroundColor: Colors.white,
                                elevation: 4,
                                onPressed: _focusOnCurrentUserLocation,
                                tooltip: 'Track My Location',
                                child: const Icon(
                                  Icons.my_location,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const ColoredBox(
                          color: Color(0xFFE6E6E6),
                          child: Center(
                            child: Text(
                              'Google Maps API key missing.\nAdd NEXT_PUBLIC_GOOGLE_MAPS_API_KEY to .env.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
