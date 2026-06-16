import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../../../app_widget/common_app_bar.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            /// APP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CommonAppBar(title: AppString.termsAndCondition),
            ),

            /// BODY
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        width: 1,
                        color: AppColor.gradientFirstColor.withValues(
                          alpha: .15,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(AppString.uberBoatsTermsAndConditions),
                        const SizedBox(height: 18),

                        _normalText(
                          AppString
                              .welcomeBoatsEmpireByUsingApplicationServicesAgreeText,
                        ),

                        const SizedBox(height: 24),

                        _heading(AppString.servicesText),

                        _normalText(
                          AppString.uberBoatsProvidesOffShoreFoodItemUsingText,
                        ),

                        const SizedBox(height: 18),

                        _heading(AppString.gpsRequirement),

                        _normalText(
                          AppString
                              .activeGpsAndLocationPermissionsAndMandatoryDriversText,
                        ),

                        const SizedBox(height: 18),

                        _heading(AppString.orderRulesText),

                        _bullet(AppString.minimumOrderAmountIsText),
                        _bullet(AppString.fuelDeliveryLimitedGallonsText),
                        _bullet(AppString.fuelDeliveriesAreOnlyText),

                        const SizedBox(height: 18),

                        _heading(AppString.deliveryAreaText),

                        _normalText(
                          AppString.ordersMustOriginateFiftyMilesShorelinesText,
                        ),

                        const SizedBox(height: 18),

                        _heading(AppString.feesText),

                        _normalText(
                          AppString.platformFeesDeliveryChargesTipsApplyText,
                        ),

                        const SizedBox(height: 18),

                        _heading(AppString.liability),

                        _normalText(
                          AppString
                              .uberBoatsNotResponsibleWhetherConditionsText,
                        ),

                        const SizedBox(height: 18),

                        _heading(AppString.governingLaw),

                        _normalText(
                          AppString.theseTermsAreGovernedLawsMarryLandText,
                        ),

                        const SizedBox(height: 18),

                        _heading(AppString.contactEightText),

                        _normalText(AppString.customerServiceGmailId),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColor.appBlackColor,
      ),
    );
  }

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColor.appBlackColor,
        ),
      ),
    );
  }

  Widget _normalText(String text, {Color color = AppColor.appBlackColor}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColor.gradientFirstColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(child: _normalText(text)),
        ],
      ),
    );
  }
}
