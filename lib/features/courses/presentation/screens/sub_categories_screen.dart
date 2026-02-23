import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmers/grid_shimmer.dart';
import '../../data/models/category_model.dart';
import '../../data/models/sub_category_model.dart';
import '../providers/courses_provider.dart';
import '../../../../core/widgets/responsive/responsive_center.dart';
import '../../../../core/widgets/responsive/responsive_layout.dart';

class SubCategoriesScreen extends ConsumerStatefulWidget {
  final CategoryModel category;

  const SubCategoriesScreen({super.key, required this.category});

  @override
  ConsumerState<SubCategoriesScreen> createState() =>
      _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends ConsumerState<SubCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider state safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedCategoryIdProvider.notifier).state = widget.category.id;
      ref.read(searchQueryProvider.notifier).state = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final subCategoriesAsync = ref.watch(subCategoriesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Background Elements
          const _BackgroundBlobs(),

          SafeArea(
            bottom: false,
            child: ResponsiveCenter(
              child: Column(
                children: [
                  _buildAppBar(context, ref),
                  Expanded(
                    child: subCategoriesAsync.when(
                      data: (paginatedData) {
                        final subCategories = paginatedData.data;

                        if (subCategories.isEmpty) {
                          return Center(
                            child: Text(
                              'No subcategories found',
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontLg,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          );
                        }

                        // Responsive Grid Count
                        int crossAxisCount = 2;
                        if (ResponsiveLayout.isDesktop(context)) {
                          crossAxisCount = 5;
                        } else if (ResponsiveLayout.isTablet(context)) {
                          crossAxisCount = 3;
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.paddingLg,
                            AppSizes.paddingLg,
                            AppSizes.paddingLg,
                            AppSizes.space100, // Add ample bottom padding
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: AppSizes.space16,
                                mainAxisSpacing: AppSizes.space16,
                              ),
                          itemCount: subCategories.length,
                          itemBuilder: (context, index) {
                            final subCategory = subCategories[index];
                            return _SubCategoryCard(
                              subCategory: subCategory,
                              index: index,
                              onTap: () {
                                ref
                                    .read(
                                      selectedSubCategoryIdProvider.notifier,
                                    )
                                    .state = subCategory
                                    .id;
                                context.push(AppRoutes.courses);
                              },
                            );
                          },
                        );
                      },
                      loading: () => const GridShimmer(),
                      error: (err, stack) => ErrorView(
                        error: err,
                        onRetry: () => ref.refresh(subCategoriesProvider),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLg,
            vertical: AppSizes.space10,
          ),
          child: Row(
            children: [
              // Back Button
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  iconSize: 22,
                  onPressed: () => context.pop(),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: AppSizes.space16),

              // Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category.name,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.font2xl,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'Explore Subcategories',
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSm,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingLg,
            AppSizes.space12,
            AppSizes.paddingLg,
            AppSizes.space4,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.space20,
              vertical: AppSizes.space4,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 26,
                ),
                const SizedBox(width: AppSizes.space16),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Search subcategories...',
                      hintStyle: GoogleFonts.outfit(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: GoogleFonts.outfit(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: AppSizes.fontMd,
                    ),
                    cursorColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubCategoryCard extends StatelessWidget {
  final SubCategoryModel subCategory;
  final int index;
  final VoidCallback onTap;

  const _SubCategoryCard({
    required this.subCategory,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusXl),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusXl),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: subCategory.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Icon(
                        Icons.grid_view_rounded,
                        size: 40,
                        color: color,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.grid_view_rounded,
                        size: 40,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.space12,
                  vertical: AppSizes.space8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        subCategory.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontMd,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space4),
                    Text(
                      subCategory.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontXs,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
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
  }
}

class _BackgroundBlobs extends StatelessWidget {
  const _BackgroundBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: -80,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.08),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
