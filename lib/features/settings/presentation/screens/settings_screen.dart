import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';

/// Settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          Text(
            'Appearance',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),

          // Theme Options Card
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
            ),
            child: Column(
              children: [
                _ThemeOptionTile(
                  icon: Icons.brightness_auto_outlined,
                  title: 'System',
                  subtitle: 'Follow device theme',
                  isSelected: currentThemeMode == ThemeMode.system,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setSystemMode();
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                ),
                _ThemeOptionTile(
                  icon: Icons.light_mode_outlined,
                  title: 'Light',
                  subtitle: 'Always use light theme',
                  isSelected: currentThemeMode == ThemeMode.light,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setLightMode();
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                ),
                _ThemeOptionTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark',
                  subtitle: 'Always use dark theme',
                  isSelected: currentThemeMode == ThemeMode.dark,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setDarkMode();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primary
            : (isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
