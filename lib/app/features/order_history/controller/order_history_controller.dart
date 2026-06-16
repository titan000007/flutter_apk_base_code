import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../../../../utils/app_string.dart';
import '../model/order_history_model.dart';

class OrderHistoryController extends GetxController {
  // ── List state ────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;

  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;

  RxList<Orders> completedOrders = <Orders>[].obs;
  final ScrollController scrollController = ScrollController();

  // ── Detail state ──────────────────────────────────────────────────────────
  Rx<Orders?> selectedOrder = Rx<Orders?>(null);
  RxBool isDetailLoading = false.obs;

  // ── Report Issue state ────────────────────────────────────────────────────
  RxBool isReportSubmitting = false.obs;
  final TextEditingController reportIssueController = TextEditingController();

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchCompletedOrders();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    reportIssueController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isMoreLoading.value && _hasMore) {
        _loadMore();
      }
    }
  }

  // Pull-to-refresh
  Future<void> refreshData() async {
    completedOrders.clear();
    await fetchCompletedOrders();
  }

  // ── Fetch first page ───────────────────────────────────────

  Future<void> fetchCompletedOrders() async {
    isLoading.value = true;
    _page = 1;
    _hasMore = true;

    try {
      final response = await NetworkService().getApiCall(
        url: NetworkUrl.fetchCompletedOrders(page: _page, limit: _limit),
      );

      if (response != null) {
        final model = OrderHistoryModel.fromJson(
          response as Map<String, dynamic>,
        );
        final fetched = model.data?.orders ?? [];
        completedOrders.value = fetched;

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
        url: NetworkUrl.fetchCompletedOrders(page: _page, limit: _limit),
      );

      if (response != null) {
        final model = OrderHistoryModel.fromJson(
          response as Map<String, dynamic>,
        );
        final fetched = model.data?.orders ?? [];
        completedOrders.addAll(fetched);

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

  Future<void> submitReportIssue({required String orderId}) async {
    final desc = reportIssueController.text.trim();
    if (desc.isEmpty) {
      showAppToast(isForError: true, msg: 'Please describe your issue');
      return;
    }

    isReportSubmitting.value = true;

    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.reportOrderIssue,
        body: {'orderId': orderId, 'issue': desc},
      );

      if (response != null) {
        final model = OrderHistoryModel.fromJson(
          response as Map<String, dynamic>,
        );
        showAppToast(isForError: false, msg: model.msg);
        reportIssueController.clear();
        Get.back(); // close report issue screen
        //AppLog.printLog('submitReportIssue orderId: $orderId  desc: $desc');
      }
    } on DioException catch (e, st) {
      final msg = e.response?.data?['msg'] ?? 'Failed to submit report';
      showAppToast(isForError: true, msg: msg);
      AppLog.printLog('submitReportIssue DioException => $st');
    } catch (e, st) {
      AppLog.printLog('submitReportIssue error => $st');
    } finally {
      isReportSubmitting.value = false;
    }
  }

  // HELPERS
  String get historySubtitle {
    final count = completedOrders.length;
    if (count == 0) return 'No deliveries yet';
    return AppString.allYourDeliveries;
  }
}
