import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:yuna/core/constants/app_colors.dart';
import 'package:yuna/core/constants/app_sizes.dart';
import 'package:yuna/core/widgets/app_button.dart';
import 'package:yuna/core/utils/snackbar_utils.dart';
import 'package:yuna/features/profile/presentation/providers/profile_provider.dart';
import 'package:yuna/features/profile/presentation/providers/edit_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider).value;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final editState = ref.watch(editProfileProvider);

    // Listen for error messages
    ref.listen(editProfileProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        AppSnackBar.showError(context, next.error!);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: profileAsync.when(
        data: (profile) => Stack(
          children: [
            // Background Gradient
            _buildBackground(context),

            // Main Content
            SafeArea(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: Column(
                        children: [
                          const SizedBox(height: AppSizes.space20),

                          // Title
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.font4xl,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),

                          Text(
                            'Customize your personal information',
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontBase,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),

                          const SizedBox(height: AppSizes.space48),

                          // Profile Picture Card (with Scale Animation derived from value)
                          Transform.scale(
                            scale: Tween<double>(
                              begin: 0.8,
                              end: 1.0,
                            ).transform(Curves.easeOutBack.transform(value)),
                            child: _buildProfilePictureCard(
                              context,
                              ref,
                              profile,
                              editState,
                              value,
                            ),
                          ),

                          const SizedBox(height: AppSizes.space48),

                          // Form Fields Card
                          _buildFormCard(context),

                          const SizedBox(height: AppSizes.space32),

                          // Save Button
                          _buildSaveButton(context, ref, editState),

                          const SizedBox(height: AppSizes.space32),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        // Top Gradient Blob
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
        // Bottom Left Blob
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryLight.withOpacity(0.2),
                  AppColors.primaryLight.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePictureCard(
    BuildContext context,
    WidgetRef ref,
    dynamic profile,
    EditProfileState editState,
    double animationValue,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.space32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Profile Picture',
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontXl,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSizes.space24),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Animated Rings (Concentric circles)
              ...List.generate(2, (index) {
                final size = 160.0 + (index * 30.0);
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(
                        (0.15 - (index * 0.05) * animationValue).clamp(
                          0.0,
                          1.0,
                        ),
                      ),
                      width: 1.5,
                    ),
                  ),
                );
              }),

              // Main Avatar Container
              Hero(
                tag: 'profile_picture',
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.primaryLight.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: ClipOval(
                        child: editState.selectedImage != null
                            ? Image.file(
                                editState.selectedImage!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                profile.avatar != null &&
                                        profile.avatar!.isNotEmpty
                                    ? profile.avatar!
                                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(profile.name)}&background=random&size=300',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.primary.withOpacity(0.1),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 60,
                                      color: AppColors.primary.withOpacity(0.5),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                          : null,
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              // Camera Button
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(editProfileProvider.notifier).pickImage(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.space16),
          Text(
            'Tap the camera icon to change',
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSm,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.space24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.space12),
              Text(
                'Personal Information',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontXl,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.space24),

          // Name Field
          _buildTextField(
            context,
            label: 'Display Name',
            controller: _nameController,
            icon: Icons.person_outline_rounded,
            hint: 'Enter your name',
          ),

          const SizedBox(height: AppSizes.space20),

          // Email Field (Read-only)
          _buildTextField(
            context,
            label: 'Email Address',
            controller: _emailController,
            icon: Icons.email_outlined,
            enabled: false,
            hint: _emailController.text,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSizes.space4),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSm,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.space8),
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.5)
                : Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            border: Border.all(
              color: enabled
                  ? Theme.of(context).colorScheme.outline.withOpacity(0.2)
                  : Colors.transparent,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.name,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w500,
              color: enabled
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: AppSizes.space8),
                child: Icon(
                  icon,
                  color: enabled
                      ? AppColors.primary.withOpacity(0.7)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.outfit(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.space20,
                vertical: AppSizes.space18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    WidgetRef ref,
    EditProfileState editState,
  ) {
    return AppButton(
      text: 'Save Changes',
      isLoading: editState.isLoading,
      icon: Icons.save_rounded,
      onPressed: () async {
        final uniqueRef = ref.read(editProfileProvider.notifier);
        final success = await uniqueRef.saveProfile(_nameController.text);
        if (success && context.mounted) {
          AppSnackBar.showSuccess(context, 'Profile updated successfully! 🎉');
          context.pop();
        }
      },
    );
  }
}
