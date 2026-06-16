import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../main.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/shared_preferences.dart';
import '../../../app_widget/us_number_formter.dart';
import '../../auth/register/model/profileUpdate.dart';
import '../../auth/register/model/users_details_model.dart';
import '../../dashboard/view/dashboard_screen.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  RxString countryDialCode = '+966'.obs;
  RxString countryCode = 'SA'.obs;

  RxBool isUserDetailsLoading = true.obs;
  RxBool isClaimFreeTrial = false.obs;
  RxBool isUpdateLoading = false.obs;
  RxBool isImageUploading = false.obs;

  Rx<UserDetails?> userDetails = Rx<UserDetails?>(null);
  RxString profileImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    super.onInit();
  }

  Future<void> getUserDetails() async {
    isUserDetailsLoading.value = true;
    try {
      final response = await NetworkService().getApiCall(
        url: NetworkUrl.getUserDetails,
      );

      if (response != null) {
        ProfileUpdate data = ProfileUpdate.fromJson(response);
        userDetails.value = data.data;

        nameController.text = data.data?.fullName ?? '';
        phoneController.text = formatPhone(data.data?.mobile ?? "");

        profileImageUrl.value = data.data?.profileimage ?? '';

        await sp?.putString(SpUtil.userName, data.data?.fullName ?? '');
        await sp?.putString(SpUtil.userEmail, data.data?.email ?? '');
        await sp?.putString(SpUtil.userPhone, data.data?.mobile ?? '');
        await sp?.putString(SpUtil.userImage, data.data?.profileimage ?? '');

        AppLog.printLog("mobileNo :: ${phoneController.text.toString()}");
        AppLog.printLog("countryDialCode :: ${countryDialCode.value.trim()}");
        AppLog.printLog("User Details Loaded: ${data.data?.fullName}");
      }
    } on DioException catch (e, stackTrace) {
      isUserDetailsLoading.value = false;
      final msg = e.response?.data?['msg'] ?? 'Failed to load user details';
      showAppToast(isForError: true, msg: msg);
      AppLog.printLog("getUserDetails error => $stackTrace");
    } catch (e, stackTrace) {
      isUserDetailsLoading.value = false;
      showAppToast(isForError: true, msg: e.toString());
      AppLog.printLog("getUserDetails error => $stackTrace");
    } finally {
      isUserDetailsLoading.value = false;
    }
  }

  // Pick & Upload Profile Image

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (file != null) await _uploadImage(file);
    } catch (e) {
      showAppToast(isForError: true, msg: 'Failed to pick image: $e');
    }
  }

  Future<void> _uploadImage(XFile file) async {
    isImageUploading.value = true;
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.name),
        'folderName': 'user/profile_section',
      });

      final response = await NetworkService().postApiCall(
        url: NetworkUrl.uploadFile,
        body: formData,
      );

      if (response != null && response['data'] != null) {
        final data = response['data'];

        // if data is a Map, extract the url field
        if (data is Map) {
          profileImageUrl.value = data['url']?.toString() ?? '';
        } else {
          // if data is already a plain string URL
          profileImageUrl.value = data.toString();
        }

        AppLog.printLog("Image uploaded: ${profileImageUrl.value}");
      }
    } on DioException catch (e, stackTrace) {
      isImageUploading.value = false;
      final msg = e.response?.data?['msg'] ?? 'Failed to upload image';
      showAppToast(isForError: true, msg: msg);
      AppLog.printLog("uploadImage error => $stackTrace");
    } catch (e, stackTrace) {
      isImageUploading.value = false;
      showAppToast(isForError: true, msg: e.toString());
      AppLog.printLog("uploadImage error => $stackTrace");
    } finally {
      isImageUploading.value = false;
    }
  }

  // Update / Save Profile
  late String phone = phoneController.value.text.trim();
  late String cleanPhone = phone.replaceAll(RegExp(r'\D'), '');

  Future<void> updateUserDetails(bool isFromSetting) async {
    isUpdateLoading.value = true;

    final body = <String, dynamic>{
      'fullName': nameController.text.trim(),
      'mobile': cleanPhone,
      'profileimage': profileImageUrl.value,
    };

    AppLog.printLog("body :: ${body.toString()}");

    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.updateUserDetails,
        body: body,
      );

      if (response != null && response['statusCode'] == 200) {
        await sp?.putString(SpUtil.userName, nameController.text.trim());
        await sp?.putString(SpUtil.userImage, profileImageUrl.value);
        showAppToast(isForError: false, msg: response['msg'] ?? "");
        getUserDetails();
        if (isFromSetting) {
          update();
          Get.offAll(() => const DashboardScreen());
        } else {
          Get.offAll(() => const DashboardScreen());
        }
      } else {
        showAppToast(isForError: true, msg: response?['msg'] ?? "");
      }
    } catch (e) {
      isUpdateLoading.value = false;
      showAppToast(isForError: true, msg: AppString.somethingWentWrong.tr);
    } finally {
      isUpdateLoading.value = false;
    }
  }
}
