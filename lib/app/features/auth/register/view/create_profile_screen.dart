import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../common_widgets/common_button_widget.dart';
import '../../../../../common_widgets/common_text_field.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_images.dart';
import '../../../../../utils/app_string.dart';
import '../../../../app_widget/us_number_formter.dart';
import '../../register/view/enable_location_screen.dart';
import '../controllers/register_controller.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final RegisterController controller = Get.put(RegisterController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.getUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
          child: CommonButton(
            text: AppString.continueText,
            height: 56,
            radius: 30,
            loading: controller.isUpdateLoading.value,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                //Get.offAll(BottomNavBar());
                controller.updateUserDetails();
              }
            },
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 60),

                // App Logo
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    AppImages.appSecondLogo,
                    height: 100,
                    width: 100,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  AppString.yourProfile,
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppString.tellUsAboutYourself,
                  style: TextStyle(
                    color: AppColor.hintTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 30),

                // Profile Photo
                Center(
                  child: GestureDetector(
                    onTap: controller.pickAndUploadImage,
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: Stack(
                        children: [
                          Obx(() {
                            final url = controller.profileImageUrl.value;
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.gradientFirstColor.withValues(
                                  alpha: .10,
                                ),

                                image: url.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: url.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Image.asset(
                                        AppImages.solarCameraLinear,
                                      ),
                                    )
                                  : null,
                            );
                          }),

                          // Upload loading indicator
                          Obx(
                            () => controller.isImageUploading.value
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        height: 28,
                                        width: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    AppString.addProfilePhoto,
                    style: TextStyle(
                      color: AppColor.hintTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Full Name
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
                  hintText: AppString.enterYourFullName,
                  textCapital: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppString.pleaseEnterFullName;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Phone Number
                const Text(
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
                  inputFormatters: [PhoneNumberFormatter()],
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  //   LengthLimitingTextInputFormatter(15),
                  // ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
