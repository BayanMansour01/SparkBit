// Example: How to add "Add to Cart" button in course details screen
// You can add this in course_details_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../cart/presentation/widgets/add_to_cart_button.dart';
// import '../../../cart/presentation/widgets/cart_badge_icon.dart';

// In the AppBar of the screen:
// AppBar(
//   title: Text('Course Details'),
//   actions: [
//     CartBadgeIcon(), // Cart icon with counter
//   ],
// )

// At the end of the screen (before safe area for example):
// Container(
//   padding: EdgeInsets.all(16),
//   decoration: BoxDecoration(
//     color: Theme.of(context).cardColor,
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.1),
//         blurRadius: 10,
//         offset: Offset(0, -4),
//       ),
//     ],
//   ),
//   child: SafeArea(
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // If the course is free
//         if (course.isFree)
//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: FilledButton.icon(
//               onPressed: () {
//                 // Logic to access free course
//               },
//               icon: Icon(Icons.play_circle_outline),
//               label: Text('Start Learning'),
//             ),
//           ),

//         // If the course is paid
//         if (!course.isFree && !course.isPurchased)
//           AddToCartButton(
//             course: course,
//             showFullButton: true,
//           ),

//         // If the course is purchased
//         if (course.isPurchased)
//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: FilledButton.icon(
//               onPressed: () {
//                 // Navigate to lessons screen
//               },
//               icon: Icon(Icons.school),
//               label: Text('Continue Learning'),
//             ),
//           ),
//       ],
//     ),
//   ),
// )

// Or you can add the button anywhere on the screen:
// Row(
//   children: [
//     Expanded(
//       child: OutlinedButton.icon(
//         onPressed: () {
//           // Preview or share
//         },
//         icon: Icon(Icons.share),
//         label: Text('Share'),
//       ),
//     ),
//     SizedBox(width: 12),
//     Expanded(
//       flex: 2,
//       child: AddToCartButton(
//         course: course,
//         showFullButton: true,
//       ),
//     ),
//   ],
// )

// To get cart state:
// final isInCart = ref.watch(isInCartProvider(course.id));
// final cartCount = ref.watch(cartItemCountProvider);

// Example: Display a message if the course is in the cart
// if (isInCart)
//   Container(
//     padding: EdgeInsets.all(12),
//     color: Colors.green.shade50,
//     child: Row(
//       children: [
//         Icon(Icons.check_circle, color: Colors.green),
//         SizedBox(width: 8),
//         Text('This course is in the shopping cart'),
//       ],
//     ),
//   )
