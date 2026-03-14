import 'package:flutter/material.dart';
import 'app_shimmer.dart';

class AppPageSkeleton extends StatelessWidget {
  final int itemCount;
  final double cardHeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const AppPageSkeleton({
    super.key,
    this.itemCount = 5,
    this.cardHeight = 96,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 100),
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppShimmer.palette(context);

    final children = List<Widget>.generate(itemCount, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 12),
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: palette.surface,
            border: Border.all(color: palette.border),
          ),
          child: AppShimmer(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 160,
                    height: 14,
                    decoration: BoxDecoration(
                      color: palette.placeholder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: palette.placeholder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: palette.placeholder,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 56,
                        height: 18,
                        decoration: BoxDecoration(
                          color: palette.placeholder,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedHeight) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: padding,
            children: children,
          );
        }

        return Padding(
          padding: padding,
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        );
      },
    );
  }
}
