import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_provider.dart';

class EditProfileState {
  final File? selectedImage;
  final bool isLoading;
  final String? error;

  EditProfileState({this.selectedImage, this.isLoading = false, this.error});

  EditProfileState copyWith({
    File? selectedImage,
    bool? isLoading,
    String? error,
  }) {
    return EditProfileState(
      selectedImage: selectedImage ?? this.selectedImage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EditProfileNotifier extends AutoDisposeNotifier<EditProfileState> {
  @override
  EditProfileState build() {
    return EditProfileState();
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        state = state.copyWith(selectedImage: File(image.path));
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  Future<bool> saveProfile(String currentName) async {
    final image = state.selectedImage;
    final name = currentName.trim();

    if (name.isEmpty && image == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref
          .read(userProfileProvider.notifier)
          .updateProfile(name.isNotEmpty ? name : null, image?.path);
      state = state.copyWith(isLoading: false);
      return true; // Success
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false; // Failed
    }
  }
}

final editProfileProvider =
    NotifierProvider.autoDispose<EditProfileNotifier, EditProfileState>(
      EditProfileNotifier.new,
    );
