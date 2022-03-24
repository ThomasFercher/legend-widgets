import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LegendGoogleMap extends StatefulWidget {
 
  final CameraPosition initialCameraPosition;
  final MapType? mapType;
  final Set<Marker>? markers;

  const LegendGoogleMap({
    required this.initialCameraPosition,
    this.mapType,
    this.markers,
  });

  @override
  State<LegendGoogleMap> createState() => _LegendGoogleMapState();
  
}

class _LegendGoogleMapState extends State<LegendGoogleMap> {

Set<Marker> legendMarker = {};
void _onMapCreated (GoogleMapController controller) {
  setState(() {
    if (widget.markers == null) {
      legendMarker.add(
      Marker(
        markerId: MarkerId("id-1"),
        position: LatLng(37.42796133580664, -122.085749655962)
      )
    );
    }else{
      legendMarker = widget.markers!;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: widget.mapType==null ? MapType.normal:widget.mapType!,
      initialCameraPosition: widget.initialCameraPosition,
      onMapCreated: _onMapCreated,
      markers: legendMarker,
    );
  }
}
