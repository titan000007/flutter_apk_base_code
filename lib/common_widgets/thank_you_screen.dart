// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gif/gif.dart';
//
// import '../utils/app_color.dart';
//
// class ThankYouScreen extends StatelessWidget {
//   final DataPurchase dataPurchase;
//   const ThankYouScreen({super.key,  required this.dataPurchase});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Gif(
//               height: 150,
//               width: 150,
//               autostart: Autostart.loop,
//               placeholder: (context) => const Center(child: CircularProgressIndicator()),
//               image: const AssetImage('assets/check.gif'),
//             ),
//             SizedBox(height: 25),
//             Text(
//               "Thank you for purchasing",
//               style: TextStyle(
//                 fontSize: 27,
//                 fontWeight: FontWeight.w700,
//                 color: AppColor.appBlackColor,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 "We’ve received your order will ship in 5-7 Days. your order no. is ${dataPurchase.orderId.toString()}",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: AppColor.color757575,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             CommonButton(
//               width: 197,
//               height: 50,
//               text: "Back To Home",
//               loading: false,
//               onPressed: () {
//                 Get.offAll(BuyerDashboardScreen());
//               },
//               showBorder: true,
//               color: Colors.transparent,
//               radius: 50,
//               borderColor: AppColor.errorColor,
//               textColor: AppColor.errorColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
