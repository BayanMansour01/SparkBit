import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/resources/values_manager.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/models/add_review_request.dart';
import '../../domain/usecases/add_review_usecase.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';

class ReviewDialog extends StatefulWidget {
  final String lessonId;
  const ReviewDialog({super.key, required this.lessonId});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final useCase = getIt<AddReviewUseCase>();
      await useCase.call(
        AddReviewRequest(
          lessonId: widget.lessonId,
          rating: _rating.toString(),
          comment: _commentController.text,
        ),
      );

      if (mounted) {
        Navigator.pop(context, _rating); // Return the rating value
        AppSnackBar.showSuccess(context, 'Review submitted successfully');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Rate this Lesson',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSize.s16),
            // Rating Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Iconsax.star1 : Iconsax.star,
                    color: Colors.amber,
                    size: AppSize.s32,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: AppSize.s24,
                );
              }),
            ),
            const SizedBox(height: AppSize.s16),
            // Comment
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                contentPadding: const EdgeInsets.all(AppPadding.p12),
              ),
            ),
            const SizedBox(height: AppSize.s24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p12,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: AppSize.s20,
                            height: AppSize.s20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
