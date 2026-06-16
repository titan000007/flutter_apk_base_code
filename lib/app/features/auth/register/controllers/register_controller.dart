import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:uber_boats_customer/app/features/auth/register/view/enable_location_screen.dart';
import '../../../../../app_service/network/network_service.dart';
import '../../../../../app_service/network/network_urls.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_log.dart';
import '../../../../../utils/app_prompt.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/shared_preferences.dart';
import '../../login/model/login_model.dart';
import '../model/profileUpdate.dart';
import '../model/users_details_model.dart';
import '../view/create_profile_screen.dart';

class RegisterController extends GetxController {
  Rx<AutovalidateMode> registerFormValidation = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Rx<UserDetails?> userDetails = Rx<UserDetails?>(null);
  RxString profileImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  RxBool isRegisterLoading = false.obs;
  RxBool isUpdateLoading = false.obs;
  RxBool isImageUploading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    isRegisterLoading.value = true;
    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.register,
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );
      if (response != null && response['statusCode'] == 200) {
        LoginModel data = LoginModel.fromJson(response);

        sp!.putString(
          SpUtil.userEmail,
          data.data?.userData?.email ?? emailController.text.trim(),
        );
        await sp?.putString(SpUtil.accessToken, data.data?.token ?? "");
        showAppToast(isForError: false, msg: data.msg);
        Get.offAll(() => const CreateProfileScreen());
      } else {
        showAppToast(
          isForError: true,
          msg: response?['msg'] ?? 'Failed to apply',
        );
      }
    } catch (e) {
      isRegisterLoading.value = false;
      showAppToast(isForError: true, msg: 'Error: $e');
    } finally {
      isRegisterLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
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
        'folderName': 'user',
      });

      final response = await NetworkService().postApiCall(
        url: NetworkUrl.uploadFile,
        body: formData,
      );

      if (response != null && response['data'] != null) {
        final data = response['data'];

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

  // ─────────────────────────────────────────────
  // Update / Save Profile
  // ─────────────────────────────────────────────
  late String phone = phoneController.value.text.trim();
  late String cleanPhone = phone.replaceAll(RegExp(r'\D'), '');


  Future<void> updateUserDetails() async {
    isUpdateLoading.value = true;

    final body = <String, dynamic>{
      'fullName': nameController.text.trim(),
      'mobile': cleanPhone,
    };

    if (profileImageUrl.value.isNotEmpty) {
      body['profileimage'] = profileImageUrl.value;
    }

    AppLog.printLog("body :: ${body.toString()}");

    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.updateUserDetails,
        body: body,
      );
      if (response != null && response['statusCode'] == 200) {
        ProfileUpdate data = ProfileUpdate.fromJson(response);
        await sp?.putString(SpUtil.userEmail, data.data?.email ?? "");
        await sp?.putString(SpUtil.userName, data.data?.fullName ?? '');
        await sp?.putString(SpUtil.userID, data.data?.sId ?? "");
        await sp?.putString(SpUtil.userImage, data.data?.profileimage ?? "");
        await sp?.putString(SpUtil.userPhone, data.data?.mobile ?? "");
        await sp?.putBool(SpUtil.isLoggedIn, true);
        await AppUtils.saveFcmToken();
        await AppUtils.updateFcmTokenApi();
        Get.offAll(() => const EnableGPSLocationScreen());
        showAppToast(isForError: false, msg: data.msg);
      }
    } catch (e) {
      isUpdateLoading.value = false;
      showAppToast(isForError: true, msg: 'Error: $e');
    } finally {
      isUpdateLoading.value = false;
    }
  }
}
