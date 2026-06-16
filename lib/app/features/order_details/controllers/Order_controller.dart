import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../../dashboard/view/dashboard_screen.dart';
import '../model/OrderDetailsModel.dart';

class OrderController extends GetxController {
  RxInt selectedMethod = 0.obs;
  Rx<OrderData?> selectedDetail = Rx<OrderData?>(null);

  final RxInt currentCarouselIndex = 0.obs;
  RxBool isDetailLoading = false.obs;
  RxBool isLoading = false.obs;


  // ── Fetch detail by id ─────────────────────────────────────

  Future<void> fetchDetail(String id) async {
    isDetailLoading.value = true;
    selectedDetail.value = null;

    try {
      final response = await NetworkService().getApiCall(
        url: NetworkUrl.fetchActiveOrderDetail(id: id),
      );

      if (response != null) {
        final model = OrderDetailsModel.fromJson(
          response as Map<String, dynamic>,
        );
        selectedDetail.value = model.data;
        // AppLog.printLog(
        //   'fetchDetail id: $id  plant: ${model.data?.plant?.displayName}',
        // );
      }
    } on DioException catch (e, st) {
      final msg = e.response?.data?['msg'] ?? 'Failed to load detail';
      showAppToast(isForError: true, msg: msg);
      AppLog.printLog('fetchDetail DioException => $st');
    } catch (e, st) {
      AppLog.printLog('fetchDetail error => $st');
    } finally {
      isDetailLoading.value = false;
    }
  }



  void updateCarouselIndex(int index) {
    currentCarouselIndex.value = index;
  }

  bool isSelected(int index) {
    return currentCarouselIndex.value == index;
  }

  final RxMap<int, int> cartQuantities = <int, int>{}.obs;

  int getQuantity(int productId) {
    return cartQuantities[productId] ?? 0;
  }

  void increment(int productId) {
    cartQuantities[productId] = getQuantity(productId) + 1;
  }

  void decrement(int productId) {
    final qty = getQuantity(productId);
    if (qty <= 1) {
      cartQuantities.remove(productId);
    } else {
      cartQuantities[productId] = qty - 1;
    }
  }
}
