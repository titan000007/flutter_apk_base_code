import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:uber_boats_customer/app/features/dashboard/controller/dashboard_controller.dart';
import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../model/CreatePaymentLinkModel.dart';
import '../model/order_item_model.dart';
import '../model/create_order_models.dart';
import '../view/order_success_screen.dart';
import '../view/review_order_screen.dart';

class CreateOrderController extends GetxController {

  DashboardController dashboardC = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());


  RxBool isImageUploading = false.obs;
  RxBool isCreateOrderLoading = false.obs;
  RxBool isCreatePaymentLinkLoading = false.obs;
  RxBool isProcessingPayment = false.obs;

  Rx<File?> selectedImage = Rx<File?>(null);
  RxList<OrderItem> orderItems = <OrderItem>[].obs;

  // This contains whole response from API
  Rx<CreateOrderData?> createOrderResponse = Rx<CreateOrderData?>(null);

  RxDouble subtotal = 0.0.obs;
  RxInt count = 11.obs;

  RxString selectedMethod = "jetski".obs;

  final ImagePicker _picker = ImagePicker();

  //Add by Link Screen
  final TextEditingController linkController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Add by Screenshot
  final TextEditingController itemNameScreenShotController =
      TextEditingController();
  final TextEditingController priceScreenShotController =
      TextEditingController();
  final TextEditingController descriptionScreenShotController =
      TextEditingController();

  //Add by Text List
  final TextEditingController itemNameTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();

  //Add Fuel
  final TextEditingController fuelPriceTextController = TextEditingController();

  ///review Order Screen
  RxInt selectedTipIndex = 0.obs;
  final TextEditingController tipPriceTextController = TextEditingController();
  RxDouble selectedTip = 0.0.obs;

  void selectTip(int index) {
    selectedTipIndex.value = index;
    if (index == 0) {
      selectedTip.value = 0;
    } else if (index == 1) {
      selectedTip.value = 10;
    } else if (index == 2) {
      selectedTip.value = 20;
    } else if (index == 3) {
      selectedTip.value = 30;
    } else if (index == 4) {
      double number =
          double.tryParse(tipPriceTextController.text.trim()) ?? 0.0;
      selectedTip.value = number;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    linkController.dispose();
    itemNameController.dispose();
    itemNameScreenShotController.dispose();
    itemNameTextController.dispose();
    priceController.dispose();
    priceScreenShotController.dispose();
    priceTextController.dispose();
    descriptionController.dispose();
    descriptionTextController.dispose();
    descriptionScreenShotController.dispose();
    super.onClose();
  }

  void addLinkItem() {
    final name = itemNameController.text.trim();
    final price = priceController.text.trim();
    final desc = descriptionController.text.trim();
    final link = linkController.text.trim();

    orderItems.add(
      OrderItem(
        itemType: AppString.directLink,
        title: name,
        description: desc.isNotEmpty ? desc : '',
        amount: price,
        // imageUrl: AppImages.directLinkIcon,
        link: link,
      ),
    );
    _recalculateSubtotal();
    _clearLinkFields();
  }

  void addTextItem() {
    final name = itemNameTextController.text.trim();
    final price = priceTextController.text.trim();
    final desc = descriptionTextController.text.trim();

    orderItems.add(
      OrderItem(
        itemType: AppString.textListText,
        title: name,
        description: desc.isNotEmpty ? desc : "",
        amount: price,
        // imageUrl: AppImages.textListIcon,
        // link: '',
      ),
    );
    _recalculateSubtotal();
    _clearTextFields();
  }

  void addScreenshotItem() {
    final name = itemNameScreenShotController.text.trim();
    final price = priceScreenShotController.text.trim();
    final desc = descriptionScreenShotController.text.trim();
    final imagePath = selectedImage.value?.path ?? '';

    orderItems.add(
      OrderItem(
        itemType: AppString.screenshotText,
        title: name,
        description: desc.isNotEmpty ? desc : '',
        amount: price,
        imageUrl: imagePath,
        // link: '',
      ),
    );
    _recalculateSubtotal();
    _clearScreenshotFields();
  }

  void addBoatFuelItem() {
    // double fuelRate = 110.50;
    // double totalAmount = count.value * fuelRate;
    final price = fuelPriceTextController.text.trim();

    orderItems.add(
      OrderItem(
        itemType: AppString.boatFuelText,
        title: 'Boat Fuel',
        description: '${count.value} Gallons',
        amount: price,
        link: '',
      ),
    );

    _recalculateSubtotal();
  }

  void removeOrderItem(int index) {
    orderItems.removeAt(index);
    _recalculateSubtotal();
  }

  void _recalculateSubtotal() {
    subtotal.value = orderItems.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item.amount) ?? 0.0);
    });
  }

  void _clearLinkFields() {
    linkController.clear();
    itemNameController.clear();
    priceController.clear();
    descriptionController.clear();
  }

  void _clearTextFields() {
    itemNameTextController.clear();
    priceTextController.clear();
    descriptionTextController.clear();
  }

  void _clearScreenshotFields() {
    itemNameScreenShotController.clear();
    priceScreenShotController.clear();
    descriptionScreenShotController.clear();
    selectedImage.value = null;
  }

  ///Upload Image
  Future<void> _uploadImage(XFile file) async {
    isImageUploading.value = true;
    selectedImage.value = File(file.path);

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.name),
        'folderName': 'order',
      });

      final response = await NetworkService().postApiCall(
        url: NetworkUrl.uploadFile,
        body: formData,
      );

      if (response != null && response['data'] != null) {
        AppLog.printLog("Upload Response: ${response['data']}");
      }
    } on DioException catch (e, stackTrace) {
      final msg = e.response?.data?['msg'] ?? 'Failed to upload image';
      showAppToast(isForError: true, msg: msg);
      AppLog.printLog("uploadImage error => $stackTrace");
    } catch (e, stackTrace) {
      showAppToast(isForError: true, msg: e.toString());
      AppLog.printLog("uploadImage error => $stackTrace");
    } finally {
      isImageUploading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (file != null) {
        await _uploadImage(file);
      }
    } catch (e) {
      showAppToast(isForError: true, msg: 'Failed to pick image: $e');
    }
  }

  Future<void> addUpdateOrders() async {
    isCreateOrderLoading.value = true;

    final body = <String, dynamic>{
      'deliveryType': selectedMethod.value,
      'lat': dashboardC.userLatitude.value.toString(),
      'long': dashboardC.userLongitude.value.toString(),
      'items': orderItems.map((item) => item.toJson()).toList(),
      if (createOrderResponse.value != null)
        'orderId': createOrderResponse.value?.order?.id,
    };

    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.createOrder,
        body: body,
      );
      if (response != null && response['statusCode'] == 200) {
        CreateOrderModel data = CreateOrderModel.fromJson(response);
        createOrderResponse.value = data.data;
        showAppToast(isForError: false, msg: data.msg);
        Get.off(() => const ReviewOrderScreen());
      }
    } catch (e) {
      showAppToast(isForError: true, msg: 'Error: $e');
      return;
    } finally {
      isCreateOrderLoading.value = false;
    }
  }

  Future<void> createPaymentLink() async {
    isCreatePaymentLinkLoading.value = true;

    final body = <String, dynamic>{
      "tipAmount": selectedTip.value.toString(),
      'orderId': createOrderResponse.value?.order?.id,
    };

    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.createPaymentLink,
        body: body,
      );
      if (response != null && response['statusCode'] == 200) {
        CreatePaymentLinkModel data = CreatePaymentLinkModel.fromJson(response);
        if (data.data?.clientSecret != null) {
          final success = await presentPaymentSheet(
            clientSecret: data.data!.clientSecret!,
          );
          if (success) {
           // showAppToast(isForError: false, msg: data.msg);
             Get.offAll(() => const OrderSuccessScreen());
            // Get.to(
            //       () => ThankYouScreen(
            //     dataPurchase: purchaseModel.data ?? DataPurchase(),
            //   ),
            // );

          }
        } else {
          showAppToast(
            msg: "Payment failed",
            isForError: false,
          );
        }

      }
    } catch (e) {
      showAppToast(isForError: true, msg: 'Error: $e');
      return;
    } finally {
      isCreatePaymentLinkLoading.value = false;
    }
  }


  Future<bool> presentPaymentSheet({required String clientSecret}) async {
    isProcessingPayment.value = true;

    try {
      //Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: AppString.appName,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            testEnv: true,
          ),
        ),
      );

      // Present the payment sheet to user
      await Stripe.instance.presentPaymentSheet();

      // Payment successful!
      debugPrint("Payment completed successfully!");



      return true;
    } on StripeException catch (e) {
      // Handle Stripe-specific errors
      debugPrint("Stripe Error: ${e.error.localizedMessage}");

      if (e.error.code == FailureCode.Canceled) {
        // User canceled the payment
        showAppToast(
          msg: "Payment canceled",
          isForError: false,
        );
      } else if (e.error.code == FailureCode.Failed) {
        // Payment failed
        showAppToast(
          msg: e.error.localizedMessage ?? "Payment failed",
          isForError: true,
        );
      } else {
        // Other Stripe errors
        showAppToast(
          msg: e.error.localizedMessage ?? "Payment error",
          isForError: true,
        );
      }
      return false;
    } catch (e) {
      debugPrint("Payment Error: $e");
      showAppToast(
        msg: "Payment processing failed",
        isForError: true,
      );
      return false;
    } finally {
      isProcessingPayment.value = false;
    }
  }

}
