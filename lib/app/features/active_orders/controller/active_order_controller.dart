import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../../chat/view/chat_screen.dart';
import '../model/activeOrderModel.dart';

class ActiveOrderController extends GetxController {
  final TextEditingController deliverOtpControllers = TextEditingController();

  RxBool isImageUploading = false.obs;
  RxBool isCreateOrderLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString uploadedImageUrl = "".obs;
  final ImagePicker _picker = ImagePicker();

  RxBool isLoading = false.obs;
  // RxBool isStatusUpdateLoading = false.obs;
  RxString loadingOrderId = "".obs;

  Rx<ActiveOrders?> selectedOrder = Rx<ActiveOrders?>(null);
  // RxBool isDetailLoading = false.obs;

  GoogleMapController? mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  // Internal
  Timer? _locationTimer;

  RxList<ActiveOrders> activeOrders = <ActiveOrders>[].obs;
  RxNum totalOrders = RxNum(0);
  RxBool isMoreLoading = false.obs;
  final ScrollController scrollController = ScrollController();

  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;

  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    fetchActiveOrders();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    mapController?.dispose();
    scrollController.dispose();
    super.onClose();
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
        final data = response['data'];
        if (data is Map) {
          uploadedImageUrl.value = data['url']?.toString() ?? '';
        } else {
          uploadedImageUrl.value = data.toString();
        }
        AppLog.printLog("Upload Response: ${uploadedImageUrl.value}");
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

  void openProfileImagePicker() {
   // todo
    // DocumentMediaPickerBottomSheet.show(
    //   onGallery: _pickFromGallery,
    //   onCamera: _pickFromCamera,
    // );
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (image != null) {
        _uploadImage(image);
      }
    } catch (e) {
      showAppToast(isForError: true, msg: "Failed to pick image: $e");
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (image != null) {
        _uploadImage(image);
      }
    } catch (e) {
      showAppToast(isForError: true, msg: "Failed to capture image: $e");
    }
  }

  // Pull-to-refresh
  Future<void> refreshData() async {
    activeOrders.clear();
    await fetchActiveOrders();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isMoreLoading.value && _hasMore) {
        _loadMore();
      }
    }
  }

  // ── Fetch first page ───────────────────────────────────────

  Future<void> fetchActiveOrders() async {
    isLoading.value = true;
    _page = 1;
    _hasMore = true;

    try {
      final response = await NetworkService().getApiCall(
        url: NetworkUrl.fetchActiveOrders(page: _page, limit: _limit),
      );

      if (response != null) {
        final model = ActiveOrderModel.fromJson(
          response as Map<String, dynamic>,
        );
        final fetched = model.data?.orders ?? [];
        activeOrders.value = fetched;
        totalOrders.value = model.data?.pagination?.total ?? 0;


        final pagination = model.data?.pagination;
        _hasMore = pagination != null
            ? _page < (pagination.totalPages ?? 1)
            : fetched.length >= _limit;

        AppLog.printLog('fetchHistory count: ${fetched.length}');
      }
    } on DioException catch (e, st) {
      final msg = e.response?.data?['msg'] ?? 'Failed to load history';
      showAppToast(isForError: true, msg: msg);
      AppLog.printLog('fetchHistory DioException => $st');
    } catch (e, st) {
      AppLog.printLog('fetchHistory error => $st');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Load more (next page) ──────────────────────────────────

  Future<void> _loadMore() async {
    if (isMoreLoading.value || !_hasMore) return;
    isMoreLoading.value = true;
    _page++;

    try {
      final response = await NetworkService().getApiCall(
        url: NetworkUrl.fetchActiveOrders(page: _page, limit: _limit),
      );

      if (response != null) {
        final model = ActiveOrderModel.fromJson(
          response as Map<String, dynamic>,
        );
        final fetched = model.data?.orders ?? [];
        activeOrders.addAll(fetched);

        final pagination = model.data?.pagination;
        _hasMore = pagination != null
            ? _page < (pagination.totalPages ?? 1)
            : fetched.length >= _limit;

        AppLog.printLog('loadMore page: $_page  fetched: ${fetched.length}');
      }
    } on DioException catch (e, st) {
      _page--; // rollback on failure
      AppLog.printLog('loadMore DioException => $st');
    } catch (e, st) {
      _page--;
      AppLog.printLog('loadMore error => $st');
    } finally {
      isMoreLoading.value = false;
    }
  }




}
