import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UploadStep {
  idle,
  capturing,
  cropping,
  uploading,
  removingBackground,
  analyzing,
  saving,
  complete,
  error,
}

class UploadState {
  final UploadStep step;
  final String? imagePath;
  final String? error;
  final double progress;

  const UploadState({
    this.step = UploadStep.idle,
    this.imagePath,
    this.error,
    this.progress = 0,
  });

  UploadState copyWith({
    UploadStep? step,
    String? imagePath,
    String? error,
    double? progress,
  }) {
    return UploadState(
      step: step ?? this.step,
      imagePath: imagePath ?? this.imagePath,
      error: error ?? this.error,
      progress: progress ?? this.progress,
    );
  }
}

final wardrobeUploadProvider =
    StateNotifierProvider<WardrobeUploadNotifier, UploadState>((ref) {
  return WardrobeUploadNotifier();
});

class WardrobeUploadNotifier extends StateNotifier<UploadState> {
  WardrobeUploadNotifier() : super(const UploadState());

  void setImagePath(String path) {
    state = state.copyWith(imagePath: path, step: UploadStep.cropping);
  }

  void reset() {
    state = const UploadState();
  }

  Future<void> startUpload(String imagePath) async {
    state = state.copyWith(step: UploadStep.uploading, progress: 0.1);
    // Upload flow managed by wardrobe_repository
    // Steps: upload original → remove background → analyze → save
  }
}
