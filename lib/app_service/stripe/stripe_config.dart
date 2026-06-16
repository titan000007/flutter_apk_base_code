import 'package:flutter_stripe/flutter_stripe.dart';

class StripeConfig {
  // Replace with your actual Stripe publishable key
  // Get this from: https://dashboard.stripe.com/apikeys
  static const String publishableKey = 'pk_test_51TTM8AFPZgraKKm6UMPPpbTAXBWwt9qj9Sh9aRXQFkzewYSXDv5wA03W8Vm90d6LwkvVnL5XeLumHfbR0PdntiBm00NugQRnrK';

  // Initialize Stripe with your publishable key
  static Future<void> initialize() async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }
}

