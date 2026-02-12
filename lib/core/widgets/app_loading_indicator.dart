import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const AppLoadingIndicator({super.key, this.color, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(color: color ?? AppColors.primary, size: size),
    );
  }
}
