import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuna/core/constants/app_sizes.dart';
import 'package:yuna/core/widgets/responsive/responsive_center.dart';
import 'package:yuna/features/contact_us/data/models/contact_method_model.dart';
import 'package:yuna/features/contact_us/presentation/providers/contact_us_provider.dart';

class ContactUsScreen extends ConsumerWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactMethodsAsync = ref.watch(contactMethodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ResponsiveCenter(
        child: contactMethodsAsync.when(
          data: (methods) => ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            itemCount: methods.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.space16),
            itemBuilder: (context, index) {
              final method = methods[index];
              return _ContactMethodCard(method: method);
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load contact methods',
                  style: GoogleFonts.outfit(),
                ),
                TextButton(
                  onPressed: () => ref.refresh(contactMethodsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactMethodCard extends StatelessWidget {
  final ContactMethodModel method;

  const _ContactMethodCard({required this.method});

  Future<void> _launch() async {
    // Special handling for phone and email if not full URIs
    String urlString = method.identifier;
    if (method.type == ContactType.phoneNumber &&
        !urlString.startsWith('tel:')) {
      urlString = 'tel:${method.identifier.replaceAll(' ', '')}';
    } else if (method.type == ContactType.email &&
        !urlString.startsWith('mailto:')) {
      urlString = 'mailto:${method.identifier}';
    } else if (method.type == ContactType.whatsapp &&
        !urlString.startsWith('https://wa.me/')) {
      // Simple wa.me link generation if it's just a number
      final cleanNumber = method.identifier.replaceAll(RegExp(r'[^0-9]'), '');
      urlString = 'https://wa.me/$cleanNumber';
    }

    final finalUri = Uri.parse(urlString);
    if (await canLaunchUrl(finalUri)) {
      await launchUrl(finalUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        side: BorderSide(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: _launch,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                decoration: BoxDecoration(
                  color: method.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Icon(method.icon, color: method.color, size: 28),
              ),
              const SizedBox(width: AppSizes.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (method.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        method.description!,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSm,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
