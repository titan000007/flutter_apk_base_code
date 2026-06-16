import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_images.dart';
import '../active_orders/model/activeOrderModel.dart';
import '../auth/register/view/enable_location_screen.dart';
import '../chat/view/chat_screen.dart';
import '../dashboard/controller/dashboard_controller.dart';

class CustomerTrackingController extends GetxController {
  /// ==========================================================
  /// REQUIRED DATA
  /// ==========================================================

  // final String orderId;
  // final String userId;
  // final String deliveryType;

  final ActiveOrders activeOrderData;

  CustomerTrackingController({required this.activeOrderData});

  /// ==========================================================
  /// SOCKET
  /// ==========================================================

  IO.Socket? socket;

  DashboardController dashboardC = Get.find();

  /// ==========================================================
  /// MAP CONTROLLER
  /// ==========================================================

  GoogleMapController? googleMapController;

  /// ==========================================================
  /// LOCATION STREAM
  /// ==========================================================

  StreamSubscription<Position>? positionStream;

  /// ==========================================================
  /// CONNECTION STATUS
  /// ==========================================================

  RxBool isConnected = false.obs;

  /// ==========================================================
  /// LOCATIONS
  /// ==========================================================

  Rxn<LatLng> driverPosition = Rxn();

  Rxn<LatLng> customerPosition = Rxn();

  /// ==========================================================
  /// MAP DATA
  /// ==========================================================

  RxSet<Marker> markers = <Marker>{}.obs;

  RxSet<Polyline> polylines = <Polyline>{}.obs;

  /// ==========================================================
  /// CUSTOM MARKERS
  /// ==========================================================

  BitmapDescriptor? droneIcon;
  BitmapDescriptor? jetskiIcon;
  BitmapDescriptor? customerIcon;

  /// ==========================================================
  /// INIT
  /// ==========================================================

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  Future<void> init() async {
    try {
      bool hasAccess = await dashboardC.getGPSandLocationStaus();
      if (hasAccess) {
        await loadMarkers();

        // Get initial position immediately to avoid stuck loading screen
        Position? position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
        ).catchError((e) => null);

        if (position != null) {
          customerPosition.value = LatLng(
            position.latitude,
            position.longitude,
          );
        }

        connectSocket();
        startLocationTracking();
      } else {
        Get.to(() => const EnableGPSLocationScreen());
      }
    } catch (e) {
      print("Error in CustomerTrackingController init: $e");
    }
  }

  /// ==========================================================
  /// LOAD PNG MARKERS
  /// ==========================================================

  Future<void> loadMarkers() async {
    try {
      droneIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(64, 64)),
        AppImages.icMapDrone,
      );

      jetskiIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(64, 64)),
        AppImages.icMapJetskiNew,
      );

      customerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(64, 64)),
        AppImages.icMapBoat,
      );
    } catch (e) {
      print("Error loading markers: $e");
    }
  }

  /// ==========================================================
  /// CONNECT SOCKET
  /// ==========================================================

  void connectSocket() {
    socket = IO.io(
      "ws://productionapi.FlutterBaseApp.com",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': activeOrderData.userId})
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(2000)
          .build(),
    );

    socket?.connect();

    /// CONNECTED
    socket?.onConnect((_) {
      print("CUSTOMER CONNECTED");

      isConnected.value = true;

      joinRoom();
    });

    /// DISCONNECTED
    socket?.onDisconnect((_) {
      print("CUSTOMER DISCONNECTED");

      isConnected.value = false;
    });

    /// LISTEN DRIVER LOCATION
    socket?.on("track_order_location", (data) {
      print("TRACK LOCATION => $data");

      final type = data['userType'].toString();

      final lat = double.tryParse(data['location']['lat'].toString()) ?? 0.0;

      final lng = double.tryParse(data['location']['long'].toString()) ?? 0.0;

      /// DRIVER LOCATION
      if (type == "driver") {
        driverPosition.value = LatLng(lat, lng);

        updateMap();
      }
    });
  }

  /// ==========================================================
  /// JOIN ROOM
  /// ==========================================================

  void joinRoom() {
    socket?.emit("join_order_room", {"orderId": activeOrderData.id});
  }

  /// ==========================================================
  /// START CUSTOMER LIVE LOCATION
  /// ==========================================================

  void startLocationTracking() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );

    positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((position) {
          customerPosition.value = LatLng(
            position.latitude,
            position.longitude,
          );

          emitLocation(position.latitude, position.longitude);

          updateMap();
        });
  }

  /// ==========================================================
  /// SEND CUSTOMER LOCATION
  /// ==========================================================

  void emitLocation(double lat, double lng) {
    socket?.emit("update_location", {
      "orderId": activeOrderData.id,
      "userId": activeOrderData.userId,
      "userType": "user",
      "lat": lat,
      "long": lng,
    });
  }

  /// ==========================================================
  /// UPDATE MAP
  /// ==========================================================

  void updateMap() {
    updateMarkers();

    updatePolyline();

    animateCamera();
  }

  /// ==========================================================
  /// UPDATE MARKERS
  /// ==========================================================

  void updateMarkers() {
    final Set<Marker> updatedMarkers = {};

    /// DRIVER
    if (driverPosition.value != null) {
      updatedMarkers.add(
        Marker(
          markerId: const MarkerId("driver"),

          position: driverPosition.value!,

          icon: activeOrderData.deliveryType == "drone"
              ? droneIcon ?? BitmapDescriptor.defaultMarker
              : jetskiIcon ?? BitmapDescriptor.defaultMarker,

          rotation: customerPosition.value != null
              ? calculateBearing(driverPosition.value!, customerPosition.value!)
              : 0,

          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    /// CUSTOMER
    if (customerPosition.value != null) {
      updatedMarkers.add(
        Marker(
          markerId: const MarkerId("customer"),

          position: customerPosition.value!,

          icon: customerIcon ?? BitmapDescriptor.defaultMarker,
        ),
      );
    }

    markers.value = updatedMarkers;
  }

  /// ==========================================================
  /// UPDATE POLYLINE
  /// ==========================================================

  void updatePolyline() {
    if (driverPosition.value == null || customerPosition.value == null) {
      polylines.clear();

      return;
    }

    polylines.value = {
      Polyline(
        polylineId: const PolylineId("route"),

        points: [driverPosition.value!, customerPosition.value!],

        width: 5,
      ),
    };
  }

  /// ==========================================================
  /// CAMERA ANIMATION
  /// ==========================================================

  Future<void> animateCamera() async {
    if (googleMapController == null || customerPosition.value == null) {
      return;
    }

    final target = driverPosition.value ?? customerPosition.value!;

    await googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 15)),
    );
  }

  /// ==========================================================
  /// BEARING
  /// ==========================================================

  double calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;

    final lng1 = start.longitude * pi / 180;

    final lat2 = end.latitude * pi / 180;

    final lng2 = end.longitude * pi / 180;

    final dLng = lng2 - lng1;

    final y = sin(dLng) * cos(lat2);

    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  /// ==========================================================
  /// DISPOSE
  /// ==========================================================

  @override
  void onClose() {
    positionStream?.cancel();

    socket?.disconnect();

    socket?.dispose();

    googleMapController?.dispose();

    super.onClose();
  }

  // PHONE CALL
  Future<void> callDriver() async {
    final phone = activeOrderData.driver?.mobile;
    if (phone == null || phone.isEmpty) return;

    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> messageDriver() async {
    Get.to(
      () => const ChatScreen(),
      arguments: {
        'otherUserId': activeOrderData.driver?.id,
        'otherUserName': activeOrderData.driver?.fullName?.capitalizeFirst,
        'otherUserImage': activeOrderData.driver?.profileimage,
        'otherUserRole': 'driver',
        'orderId': activeOrderData.id,
      },
    );

    // Get.toNamed('/ChatScreen', arguments: {
    //   'otherUserId': order.deliveryPersonId,   // actual variable
    //   'otherUserName': order.deliveryPersonName,
    //   'otherUserImage': order.deliveryPersonImage ?? '',
    //   'otherUserRole': 'driver',
    //   'orderId': order.id,                     // actual order ID
    // }
  }
}
