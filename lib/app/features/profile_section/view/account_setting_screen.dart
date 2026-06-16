import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import '../../../../../common_widgets/common_button_widget.dart';
import '../../../../../common_widgets/common_text_field.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_images.dart';
import '../../../../utils/app_string.dart';
import '../../../app_widget/us_number_formter.dart';
import '../controllers/profile_controller.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CommonAppBar(title: AppString.editProfile),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(
                          overscroll: false,
                        ),
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            SizedBox(height: 24),

                            Center(
                              child: GestureDetector(
                                onTap: controller.pickAndUploadImage,
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Profile image circle
                                      Obx(() {
                                        final url =
                                            controller.profileImageUrl.value;
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColor.gradientFirstColor
                                                .withValues(alpha: .10),
                                            image: url.isNotEmpty
                                                ? DecorationImage(
                                                    image: NetworkImage(url),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          child: url.isEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                    25,
                                                  ),
                                                  child: Image.asset(
                                                    AppImages.solarCameraLinear,
                                                  ),
                                                )
                                              : null,
                                        );
                                      }),

                                      Obx(
                                        () => controller.isImageUploading.value
                                            ? Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black
                                                      .withValues(alpha: 0.35),
                                                ),
                                                child: Center(
                                                  child: SizedBox(
                                                    height: 28,
                                                    width: 28,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2.5,
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ),

                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: AppColor.pageBackground,
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 16,
                                              color:
                                                  AppColor.gradientFirstColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30),

                            Text(
                              AppString.fullName,
                              style: TextStyle(
                                color: AppColor.appBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              controller: controller.nameController,
                              hintText: "Full name",
                              textCapital: true,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return AppString.pleaseEnterFullName;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Phone Number label
                            Text(
                              AppString.phoneNumberOptional,
                              style: TextStyle(
                                color: AppColor.appBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CommonTextField(
                              controller: controller.phoneController,
                              hintText: AppString.hintNumber,
                              keyboardType: TextInputType.phone,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.digitsOnly,
                              //   LengthLimitingTextInputFormatter(15),
                              // ],
                              inputFormatters: [PhoneNumberFormatter()],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Save Changes button — pinned at bottom
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Obx(
                        () => CommonButton(
                          text: AppString.saveChanges,
                          loading: controller.isUpdateLoading.value,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.updateUserDetails(true);
                            }
                          },
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
    );
  }
}
