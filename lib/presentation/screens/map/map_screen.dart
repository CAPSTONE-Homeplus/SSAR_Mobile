// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_animations/flutter_map_animations.dart';
// import 'package:latlong2/latlong.dart';

// class MapScreen extends StatefulWidget {
//   MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
//   static const _useTransformerId = 'useTransformerId';

//   final markers = ValueNotifier<List<AnimatedMarker>>([]);
//   LatLng center = const LatLng(10.799345, 106.841560);

//   final TextEditingController _latitudeController = TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();

//   bool _useTransformer = true;
//   int _lastMovedToMarkerIndex = -1;

//   late final _animatedMapController = AnimatedMapController(vsync: this);

//   @override
//   void dispose() {
//     markers.dispose();
//     _animatedMapController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     _animatedMapController.dispose();
//     super.dispose();
//   }

//   void _moveToLocation() {
//     final double? lat = double.tryParse(_latitudeController.text);
//     final double? lng = double.tryParse(_longitudeController.text);

//     if (lat != null && lng != null) {
//       setState(() {
//         center = LatLng(lat, lng);
//       });
//       _animatedMapController.animateTo(dest: center);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng nhập tọa độ hợp lệ!")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           ValueListenableBuilder<List<AnimatedMarker>>(
//             valueListenable: markers,
//             builder: (context, markers, _) {
//               return FlutterMap(
//                 mapController: _animatedMapController.mapController,
//                 options: MapOptions(
//                   initialCenter: center,
//                   initialZoom: 15,
//                   onTap: (_, point) => _addMarker(point),
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                         'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     userAgentPackageName: 'com.example.app',
//                     tileUpdateTransformer: _animatedMoveTileUpdateTransformer,
//                     // tileProvider: CancellableNetworkTileProvider(),
//                   ),
//                   AnimatedMarkerLayer(markers: markers),
//                 ],
//               );
//             },
//           ),
//           Positioned(
//             top: 40,
//             left: 20,
//             right: 20,
//             child: Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _latitudeController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           hintText: "Nhập vĩ độ (latitude)",
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: _longitudeController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           hintText: "Nhập kinh độ (longitude)",
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.search),
//                       onPressed: _moveToLocation,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: SeparatedColumn(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         separator: const SizedBox(height: 8),
//         children: [
//           FloatingActionButton(
//             onPressed: () => _animatedMapController.animatedRotateFrom(
//               90,
//               customId: _useTransformer ? _useTransformerId : null,
//             ),
//             tooltip: 'Rotate 90°',
//             child: const Icon(Icons.rotate_right),
//           ),
//           FloatingActionButton(
//             onPressed: () => _animatedMapController.animatedRotateFrom(
//               -90,
//               customId: _useTransformer ? _useTransformerId : null,
//             ),
//             tooltip: 'Rotate -90°',
//             child: const Icon(Icons.rotate_left),
//           ),
//           FloatingActionButton(
//             onPressed: () {
//               markers.value = [];
//               _animatedMapController.animateTo(
//                 dest: center,
//                 rotation: 0,
//                 customId: _useTransformer ? _useTransformerId : null,
//               );
//             },
//             tooltip: 'Clear modifications',
//             child: const Icon(Icons.clear_all),
//           ),
//           FloatingActionButton(
//             onPressed: () => _animatedMapController.animatedZoomIn(
//               customId: _useTransformer ? _useTransformerId : null,
//             ),
//             tooltip: 'Zoom in',
//             child: const Icon(Icons.zoom_in),
//           ),
//           FloatingActionButton(
//             onPressed: () => _animatedMapController.animatedZoomOut(
//               customId: _useTransformer ? _useTransformerId : null,
//             ),
//             tooltip: 'Zoom out',
//             child: const Icon(Icons.zoom_out),
//           ),
//           FloatingActionButton(
//             tooltip: 'Center on markers',
//             onPressed: () {
//               if (markers.value.length < 2) return;

//               final points = markers.value.map((m) => m.point).toList();
//               _animatedMapController.animatedFitCamera(
//                 cameraFit: CameraFit.coordinates(
//                   coordinates: points,
//                   padding: const EdgeInsets.all(12),
//                 ),
//                 rotation: 0,
//                 customId: _useTransformer ? _useTransformerId : null,
//               );
//             },
//             child: const Icon(Icons.center_focus_strong),
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               FloatingActionButton(
//                 tooltip: 'Move to next marker with offset',
//                 onPressed: () {
//                   if (markers.value.isEmpty) return;

//                   final points = markers.value.map((m) => m.point);
//                   setState(
//                     () => _lastMovedToMarkerIndex =
//                         (_lastMovedToMarkerIndex + 1) % points.length,
//                   );

//                   _animatedMapController.animateTo(
//                     dest: points.elementAt(_lastMovedToMarkerIndex),
//                     customId: _useTransformer ? _useTransformerId : null,
//                     offset: const Offset(100, 100),
//                   );
//                 },
//                 child: const Icon(Icons.multiple_stop),
//               ),
//               const SizedBox.square(dimension: 8),
//               FloatingActionButton(
//                 tooltip: 'Move to next marker',
//                 onPressed: () {
//                   if (markers.value.isEmpty) return;

//                   final points = markers.value.map((m) => m.point);
//                   setState(
//                     () => _lastMovedToMarkerIndex =
//                         (_lastMovedToMarkerIndex + 1) % points.length,
//                   );

//                   _animatedMapController.animateTo(
//                     dest: points.elementAt(_lastMovedToMarkerIndex),
//                     customId: _useTransformer ? _useTransformerId : null,
//                   );
//                 },
//                 child: const Icon(Icons.polyline_rounded),
//               ),
//             ],
//           ),
//           FloatingActionButton.extended(
//             label: Row(
//               children: [
//                 const Text('Transformer'),
//                 Switch(
//                   activeColor: Colors.blue.shade200,
//                   activeTrackColor: Colors.black38,
//                   value: _useTransformer,
//                   onChanged: (newValue) {
//                     setState(() => _useTransformer = newValue);
//                   },
//                 ),
//               ],
//             ),
//             onPressed: () {
//               setState(() => _useTransformer = !_useTransformer);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _addMarker(LatLng point) {
//     markers.value = List.from(markers.value)
//       ..add(
//         MyMarker(
//           point: point,
//           onTap: () => _animatedMapController.animateTo(
//             dest: point,
//             customId: _useTransformer ? _useTransformerId : null,
//           ),
//         ),
//       );
//   }
// }

// class MyMarker extends AnimatedMarker {
//   MyMarker({
//     required super.point,
//     VoidCallback? onTap,
//   }) : super(
//           width: markerSize,
//           height: markerSize,
//           builder: (context, animation) {
//             final size = markerSize * animation.value;

//             return GestureDetector(
//               onTap: onTap,
//               child: Opacity(
//                 opacity: animation.value,
//                 child: Icon(
//                   Icons.room,
//                   size: size,
//                 ),
//               ),
//             );
//           },
//         );

//   static const markerSize = 50.0;
// }

// class SeparatedColumn extends StatelessWidget {
//   const SeparatedColumn({
//     super.key,
//     required this.separator,
//     this.children = const [],
//     this.mainAxisSize = MainAxisSize.max,
//     this.crossAxisAlignment = CrossAxisAlignment.start,
//   });

//   final Widget separator;
//   final List<Widget> children;
//   final MainAxisSize mainAxisSize;
//   final CrossAxisAlignment crossAxisAlignment;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: mainAxisSize,
//       crossAxisAlignment: crossAxisAlignment,
//       children: [
//         ..._buildChildren(),
//       ],
//     );
//   }

//   Iterable<Widget> _buildChildren() sync* {
//     for (var i = 0; i < children.length; i++) {
//       yield children[i];
//       if (i < children.length - 1) yield separator;
//     }
//   }
// }

// /// Inspired by the contribution of [rorystephenson](https://github.com/fleaflet/flutter_map/pull/1475/files#diff-b663bf9f32e20dbe004bd1b58a53408aa4d0c28bcc29940156beb3f34e364556)
// final _animatedMoveTileUpdateTransformer = TileUpdateTransformer.fromHandlers(
//   handleData: (updateEvent, sink) {
//     final id = AnimationId.fromMapEvent(updateEvent.mapEvent);

//     if (id == null) return sink.add(updateEvent);
//     if (id.customId != _MapScreenState._useTransformerId) {
//       if (id.moveId == AnimatedMoveId.started) {
//         debugPrint('TileUpdateTransformer disabled, using default behaviour.');
//       }
//       return sink.add(updateEvent);
//     }

//     switch (id.moveId) {
//       case AnimatedMoveId.started:
//         debugPrint('Loading tiles at animation destination.');
//         sink.add(
//           updateEvent.loadOnly(
//             loadCenterOverride: id.destLocation,
//             loadZoomOverride: id.destZoom,
//           ),
//         );
//         break;
//       case AnimatedMoveId.inProgress:
//         // Do not prune or load during movement.
//         break;
//       case AnimatedMoveId.finished:
//         debugPrint('Pruning tiles after animated movement.');
//         sink.add(updateEvent.pruneOnly());
//         break;
//     }
//   },
// );
