import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import 'app_shimmer.dart';

class GridShimmer extends StatelessWidget {
  final int itemCount;

  const GridShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final palette = AppShimmer.palette(context);

    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppSizes.space16,
        mainAxisSpacing: AppSizes.space16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            border: Border.all(color: palette.border),
          ),
          child: AppShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.placeholder,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusXl),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.space12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: palette.placeholder,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.space8),
                        Container(
                          width: 60,
                          height: 10,
                          decoration: BoxDecoration(
                            color: palette.placeholder,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
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
      },
    );
  }
}
