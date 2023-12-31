import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hajj_app/widgets/radar/find_officers.dart';
import 'package:hajj_app/helpers/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SecondWidget extends StatefulWidget {
  const SecondWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SecondWidgetState createState() => _SecondWidgetState();
}

class _SecondWidgetState extends State<SecondWidget> {
  MapboxMapController? mapController;
  Position? currentPosition;
  String locationName = 'Meca, Saudi Arabia';

  final animationsMap = {
    'containerOnPageLoadAnimation5': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 600.ms),
        ScaleEffect(
          curve: Curves.easeOut,
          delay: 600.ms,
          duration: 400.ms,
          begin: const Offset(2.0, 2.0),
          end: const Offset(1.0, 1.0),
        ),
        FadeEffect(
          curve: Curves.easeOut,
          delay: 600.ms,
          duration: 400.ms,
          begin: 0.0,
          end: 1.0,
        ),
        BlurEffect(
          curve: Curves.easeOut,
          delay: 600.ms,
          duration: 400.ms,
          begin: const Offset(10.0, 10.0),
          end: const Offset(0.0, 0.0),
        ),
        MoveEffect(
          curve: Curves.easeOut,
          delay: 600.ms,
          duration: 400.ms,
          begin: const Offset(0.0, 70.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  Future<void> _updateUserLocation(double latitude, double longitude) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users/${currentUser.uid}');
        await userRef.update({
          'latitude': latitude,
          'longitude': longitude,
        });
        print('User location updated successfully.');
      } else {
        print('User is not authenticated.');
      }
    } catch (e) {
      print('Error updating user location: $e');
    }
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update current user's location in Firebase Realtime Database
      await _updateUserLocation(position.latitude, position.longitude);

      // Get the location name based on the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the location name
      if (placemarks.isNotEmpty) {
        String retrievedLocationName =
            placemarks.first.name ?? 'Unknown Location';
        setState(() {
          locationName = retrievedLocationName;
        });
      } else {
        print('No location name found for the coordinates.');
      }

      // Update the map camera to center around the user's location.
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16.0,
        ),
      );

      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      // Handle any errors that may occur when getting the location.
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
              height: 180.0,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: SizedBox(
                                height: 130.0,
                                width: 130.0,
                                child: MapboxMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: const CameraPosition(
                                    target: LatLng(21.422627, 39.826115),
                                    zoom: 14.0,
                                  ),
                                  accessToken: dotenv.env['MAPBOX_SECRET_KEY']!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 8.0,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          mini: true,
                          child: const Icon(
                            Iconsax.gps,
                            color: ColorSys.darkBlue,
                          ),
                          onPressed: () => _getUserLocation(),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your location',
                            style: textStyle(
                                fontSize: 14, color: ColorSys.darkBlue),
                          ),
                          Text(
                            locationName,
                            style: textStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorSys.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          ElevatedButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 48, sigmaY: 48),
                                    child: Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: const SizedBox(
                                        height: double.infinity,
                                        child: FindOficcersWidget(),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation5']!),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Iconsax.radar_2),
                            label: const Text('Find Officers'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorSys.darkBlue,
                              textStyle: const TextStyle(fontSize: 14),
                              fixedSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // IF USER == PILGRIM
            const SizedBox(height: 30.0),
            // Container(
            //   height: 180.0,
            //   margin: const EdgeInsets.symmetric(horizontal: 20.0),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(25.0),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.2),
            //         spreadRadius: 3,
            //         blurRadius: 3,
            //         offset: const Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   padding: const EdgeInsets.all(25.0),
            //   child: Row(
            //     children: [
            //       Stack(
            //         children: [
            //           Align(
            //             alignment: Alignment.centerLeft,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(25.0),
            //                   child: SizedBox(
            //                     height: 130.0,
            //                     width: 120.0,
            //                     child: Image.network(
            //                       'https://avatars.githubusercontent.com/u/52822242?v=4',
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       Flexible(
            //         child: Container(
            //           margin: const EdgeInsets.only(left: 16.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Muhamad Taopik',
            //                 style: textStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.bold,
            //                   color: ColorSys.darkBlue,
            //                 ),
            //               ),
            //               const SizedBox(height: 5.0),
            //               Row(
            //                 children: [
            //                   const Icon(
            //                     Icons.directions_walk,
            //                     size: 14.0,
            //                     color: ColorSys.darkBlue,
            //                   ),
            //                   const SizedBox(width: 4.0),
            //                   Text(
            //                     '1 Km',
            //                     style: textStyle(
            //                       fontSize: 14,
            //                       color: ColorSys.darkBlue,
            //                     ),
            //                   ),
            //                   const SizedBox(width: 10.0),
            //                   const Icon(
            //                     Iconsax.clock,
            //                     size: 14.0,
            //                     color: ColorSys.darkBlue,
            //                   ),
            //                   const SizedBox(width: 4.0),
            //                   Text(
            //                     '10 Min',
            //                     style: textStyle(
            //                       fontSize: 14,
            //                       color: ColorSys.darkBlue,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               const SizedBox(height: 30.0),
            //               Row(
            //                 children: [
            //                   ElevatedButton.icon(
            //                     onPressed: () {},
            //                     icon: const Center(
            //                       child: Icon(Iconsax.direct_up),
            //                     ),
            //                     label: const Text('Go'),
            //                     style: ElevatedButton.styleFrom(
            //                       backgroundColor: ColorSys.darkBlue,
            //                       textStyle: const TextStyle(
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                       fixedSize: const Size(90, 50),
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(25.0),
            //                       ),
            //                     ),
            //                   ),
            //                   const SizedBox(width: 10.0), // Adjust the spacing
            //                   ElevatedButton.icon(
            //                     onPressed: () {},
            //                     icon: const Icon(Iconsax.danger),
            //                     label: const Text('Help'),
            //                     style: ElevatedButton.styleFrom(
            //                       backgroundColor: Colors.red,
            //                       textStyle: const TextStyle(
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                       fixedSize: const Size(100, 50),
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(25.0),
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
