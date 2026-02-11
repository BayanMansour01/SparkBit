/// App strings constants
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'Yuna';
  static const String appTagline = 'Learn Anytime, Anywhere';

  // Currency
  static const String currencyCode = '\$  ';
  static const String currencySymbol = 'USD';  
  
  /// Format price with currency
  /// Accepts [price] as String, int, or double
  static String formatPrice(dynamic price) {
    if (price == null) return '$currencyCode 0.00    ';
    
    double value = 0.0;
    if (price is String) {
      value = double.tryParse(price) ?? 0.0;
    } else if (price is num) {
      value = price.toDouble();    
    }
    
    // Check if integer (no decimals)
    if (value % 1 == 0) {
      return '$currencyCode ${value.toInt(    )}';
    }
    
    return '$currencyCode ${value.toStringAsFixed(2)}';
  }

  // Auth
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String signOut = 'Sign Out';
  static const String signInRequired = 'Sign In Required';
  static const String signdToCart = 'Please sign in to add courses to your cart and make purchases.';

  // Cart
  static const String cart = 'Shopping Cart';
  static const String addToCart = 'Add to Cart';
  static const String viewCart = 'View Cart';
  static const String emptyCart = 'Cart is Empty';
  static const String emptyCarte = 'Start adding courses you love to your cart.';
  static const String courseAddedToCart = 'Course added to cart';
  static const String clearCart = 'Clear Cart';
  static const String clearCartConfirm = 'Are you sure you want to clear the cart?';
  static const String proceedToCheckout = 'Proceed to Checkout';

  // Checkout
  static const String checkout = 'Checkout';
  static const String orderSummary = 'Order Summary';
  static const String paymentMethod = 'Payment Method';
  static const String completeOrder = 'Complete Order';
  static const String orderSuccess = 'Order Created Successfully!';
  static const String orderProcessing = 'Your order will be processed soon';

  // Courses
  static const String courses = 'Courses';
  static const String myCourses = 'My Courses';
  static const String continueLearning = 'Continue Learning';
  static const String startLearning = 'Start Learning';
  static const String enrollNow = 'Enroll Now';
  static const String free = 'Free';
  static const String completed = 'Completed';

  // Common
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String view = 'View';
  static const String backToHome = 'Back to Home';
  static const String browseCourses = 'Browse Courses';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
}
