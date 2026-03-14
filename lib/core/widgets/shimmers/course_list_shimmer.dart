import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import 'app_shimmer.dart';

class CourseListShimmer extends StatelessWidget {
  final int itemCount;

  const CourseListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        0,
        AppSizes.paddingLg,
        AppSizes.space100,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.space16),
      itemBuilder: (context, index) {
        return _buildShimmerItem(context, isDark);
      },
    );
  }

  Widget _buildShimmerItem(BuildContext context, bool isDark) {
    final palette = AppShimmer.palette(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.space16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: palette.border),
      ),
      child: AppShimmer(
        child: Row(
          children: [
            // Image Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: palette.placeholder,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            const SizedBox(width: AppSizes.space16),

            // Content Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: palette.placeholder,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space8),
                  Container(
                    width: 150,
                    height: 16,
                    decoration: BoxDecoration(
                      color: palette.placeholder,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space12),

                  // Instructor
                  Container(
                    width: 100,
                    height: 12,
                    decoration: BoxDecoration(
                      color: palette.placeholder,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space12),

                  // Bottom Row (Rating, duration, price)
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 12,
                        decoration: BoxDecoration(
                          color: palette.placeholder,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.space12),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: palette.placeholder,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 50,
                        height: 20,
                        decoration: BoxDecoration(
                          color: palette.placeholder,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
