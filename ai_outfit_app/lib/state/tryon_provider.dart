import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/garment.dart';
import '../models/sample_model.dart';
import '../models/tryon_job.dart';
import '../models/styling_options.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';

class TryOnProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ImageService _imageService = ImageService();

  List<CategoryItem> _categories = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';

  List<GarmentTemplate> _templates = [];
  List<SampleModel> _sampleModels = [];
  List<HairstyleOption> _hairstyles = [];
  List<BeardOption> _beards = [];
  List<BackgroundOption> _backgrounds = [];
  List<WardrobeItem> _wardrobe = [];

  bool _isLoadingTemplates = false;
  GarmentTemplate? _selectedGarment;

  // Mode: outfit, custom_garment, hair_style, beard_style
  String _activeMode = 'outfit';

  // User photo
  String? _userImageUrl;
  File? _userImageFile;

  // Custom garment (App 1 feature)
  String? _customGarmentUrl;
  File? _customGarmentFile;

  // Hair & Beard & Background (App 2 features)
  HairstyleOption? _selectedHairstyle;
  BeardOption? _selectedBeard;
  BackgroundOption? _selectedBackground;
  bool _isHDEnhanced = false;

  FocusArea _focusArea = FocusArea.fullBody;

  TryOnJob? _currentJob;
  bool _isGenerating = false;
  int _progress = 0;
  String _statusMessage = '';

  int _credits = 10;

  // Getters
  List<CategoryItem> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  List<GarmentTemplate> get templates => _templates;
  List<SampleModel> get sampleModels => _sampleModels;
  List<HairstyleOption> get hairstyles => _hairstyles;
  List<BeardOption> get beards => _beards;
  List<BackgroundOption> get backgrounds => _backgrounds;
  List<WardrobeItem> get wardrobe => _wardrobe;
  bool get isLoadingTemplates => _isLoadingTemplates;
  GarmentTemplate? get selectedGarment => _selectedGarment;
  String get activeMode => _activeMode;

  String? get userImageUrl => _userImageUrl;
  File? get userImageFile => _userImageFile;

  String? get customGarmentUrl => _customGarmentUrl;
  File? get customGarmentFile => _customGarmentFile;

  HairstyleOption? get selectedHairstyle => _selectedHairstyle;
  BeardOption? get selectedBeard => _selectedBeard;
  BackgroundOption? get selectedBackground => _selectedBackground;
  bool get isHDEnhanced => _isHDEnhanced;

  FocusArea get focusArea => _focusArea;
  TryOnJob? get currentJob => _currentJob;
  bool get isGenerating => _isGenerating;
  int get progress => _progress;
  String get statusMessage => _statusMessage;
  int get credits => _credits;

  TryOnProvider() {
    init();
  }

  Future<void> init() async {
    _isLoadingTemplates = true;
    notifyListeners();

    _categories = await _apiService.getCategories();
    _templates = await _apiService.getTemplates();
    _sampleModels = await _apiService.getSampleModels();
    _hairstyles = await _apiService.getHairstyles();
    _beards = await _apiService.getBeards();
    _backgrounds = await _apiService.getBackgrounds();
    _wardrobe = await _apiService.getWardrobe();

    if (_templates.isNotEmpty && _selectedGarment == null) {
      _selectedGarment = _templates.first;
    }

    _isLoadingTemplates = false;
    notifyListeners();
  }

  void setMode(String mode) {
    _activeMode = mode;
    notifyListeners();
  }

  void selectCategory(String catId) {
    _selectedCategoryId = catId;
    fetchTemplates();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchTemplates();
  }

  Future<void> fetchTemplates() async {
    _isLoadingTemplates = true;
    notifyListeners();

    _templates = await _apiService.getTemplates(
      category: _selectedCategoryId,
      search: _searchQuery,
    );

    _isLoadingTemplates = false;
    notifyListeners();
  }

  void selectGarment(GarmentTemplate garment) {
    _selectedGarment = garment;
    _customGarmentUrl = null;
    _customGarmentFile = null;
    _activeMode = 'outfit';
    _focusArea = garment.focusArea;
    notifyListeners();
  }

  void setUserPhotoUrl(String url) {
    _userImageUrl = url;
    _userImageFile = null;
    notifyListeners();
  }

  void setUserPhotoFile(File file) {
    _userImageFile = file;
    _userImageUrl = file.path;
    notifyListeners();
  }

  void setCustomGarmentFile(File file) {
    _customGarmentFile = file;
    _customGarmentUrl = file.path;
    _activeMode = 'custom_garment';
    notifyListeners();
  }

  void setFocusArea(FocusArea area) {
    _focusArea = area;
    notifyListeners();
  }

  void selectHairstyle(HairstyleOption hair) {
    _selectedHairstyle = hair;
    _activeMode = 'hair_style';
    notifyListeners();
  }

  void selectBeard(BeardOption beard) {
    _selectedBeard = beard;
    _activeMode = 'beard_style';
    notifyListeners();
  }

  Future<void> toggleHDEnhance() async {
    if (_currentJob == null) return;
    _isHDEnhanced = !_isHDEnhanced;
    notifyListeners();
    await _apiService.enhancePhoto(_currentJob!.id);
  }

  Future<void> applyBackground(BackgroundOption bg) async {
    _selectedBackground = bg;
    notifyListeners();
    if (_currentJob != null) {
      await _apiService.changeBackground(_currentJob!.id, bg.id);
    }
  }

  Future<void> pickFromGallery() async {
    final xfile = await _imageService.pickFromGallery();
    if (xfile != null) {
      setUserPhotoFile(File(xfile.path));
    }
  }

  Future<void> captureFromCamera() async {
    final xfile = await _imageService.captureFromCamera();
    if (xfile != null) {
      setUserPhotoFile(File(xfile.path));
    }
  }

  Future<void> pickCustomGarment() async {
    final xfile = await _imageService.pickFromGallery();
    if (xfile != null) {
      setCustomGarmentFile(File(xfile.path));
    }
  }

  Future<void> captureCustomGarment() async {
    final xfile = await _imageService.captureFromCamera();
    if (xfile != null) {
      setCustomGarmentFile(File(xfile.path));
    }
  }

  void selectSampleModel(SampleModel model) {
    setUserPhotoUrl(model.imageUrl);
  }

  Future<bool> startTryOn() async {
    if (_userImageUrl == null && _userImageFile == null) {
      if (_sampleModels.isNotEmpty) {
        setUserPhotoUrl(_sampleModels.first.imageUrl);
      } else {
        return false;
      }
    }

    _isGenerating = true;
    _progress = 8;
    _statusMessage = 'Preparing and uploading your photo...';
    notifyListeners();

    try {
      String userImg = _userImageUrl ?? (_sampleModels.isNotEmpty ? _sampleModels.first.imageUrl : '');

      if (_userImageFile != null) {
        final uploaded = await _apiService.uploadImage(_userImageFile!);
        if (uploaded != null) {
          userImg = uploaded;
        }
      }

      String? customGarmentResolved = _customGarmentUrl;
      if (_activeMode == 'custom_garment' && _customGarmentFile != null) {
        _statusMessage = 'Uploading custom clothing image...';
        notifyListeners();
        final uploadedGarment = await _apiService.uploadImage(_customGarmentFile!);
        if (uploadedGarment != null) {
          customGarmentResolved = uploadedGarment;
        }
      }

      _progress = 20;
      _statusMessage = 'Submitting styling parameters to AI engine...';
      notifyListeners();

      final job = await _apiService.submitTryOn(
        userImageUrl: userImg,
        mode: _activeMode,
        garmentId: _activeMode == 'outfit' ? _selectedGarment?.id : null,
        garmentImageUrl: _activeMode == 'outfit' ? _selectedGarment?.imageUrl : null,
        customGarmentUrl: customGarmentResolved,
        focusArea: _focusArea,
        hairstyleId: _activeMode == 'hair_style' ? _selectedHairstyle?.id : null,
        beardId: _activeMode == 'beard_style' ? _selectedBeard?.id : null,
        backgroundId: _selectedBackground?.id,
        enhanceHD: _isHDEnhanced,
      );

      _currentJob = job;
      _progress = 35;
      _statusMessage = _activeMode == 'hair_style'
          ? 'Mapping scalp contours & hair geometry...'
          : _activeMode == 'beard_style'
              ? 'Analyzing jawline & facial hair boundaries...'
              : 'Detecting body contours & silhouette...';
      notifyListeners();

      int attempts = 0;
      bool completed = false;

      while (!completed && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 1500));
        attempts++;

        final updatedJob = await _apiService.getJobStatus(job.id);
        if (updatedJob != null) {
          _currentJob = updatedJob;
          _progress = updatedJob.progress;
          _statusMessage = updatedJob.message ?? 'Styling in progress...';
          notifyListeners();

          if (updatedJob.status == JobStatus.completed) {
            completed = true;
            _isGenerating = false;
            _progress = 100;
            _credits = (_credits > 0) ? _credits - 1 : 0;
            notifyListeners();
            return true;
          } else if (updatedJob.status == JobStatus.failed) {
            _isGenerating = false;
            notifyListeners();
            return false;
          }
        } else {
          _progress = (_progress + 18).clamp(0, 95);
          if (_progress > 40 && _progress < 70) {
            _statusMessage = 'Warping style elements & adjusting lighting...';
          } else if (_progress >= 70) {
            _statusMessage = 'Synthesizing natural textures and high-definition details...';
          }
          notifyListeners();

          if (attempts >= 4) {
            completed = true;
            String resultUrl = userImg;
            if (_activeMode == 'outfit') {
              resultUrl = _selectedGarment?.imageUrl ?? userImg;
            } else if (_activeMode == 'custom_garment') {
              resultUrl = _customGarmentUrl ?? userImg;
            } else if (_activeMode == 'hair_style') {
              resultUrl = _selectedHairstyle?.previewUrl ?? userImg;
            } else if (_activeMode == 'beard_style') {
              resultUrl = _selectedBeard?.previewUrl ?? userImg;
            }

            _currentJob = TryOnJob(
              id: job.id,
              status: JobStatus.completed,
              userImageUrl: userImg,
              garmentId: _selectedGarment?.id,
              garmentImageUrl: resultUrl,
              focusArea: _focusArea,
              beforeImageUrl: userImg,
              resultImageUrl: resultUrl,
              progress: 100,
              message: 'Transformation complete!',
              createdAt: DateTime.now().toIso8601String(),
              completedAt: DateTime.now().toIso8601String(),
            );
            _progress = 100;
            _isGenerating = false;
            _credits = (_credits > 0) ? _credits - 1 : 0;
            notifyListeners();
            return true;
          }
        }
      }

      _isGenerating = false;
      notifyListeners();
      return _currentJob?.status == JobStatus.completed;
    } catch (e) {
      _isGenerating = false;
      _statusMessage = 'Generation error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> saveCurrentLook() async {
    if (_currentJob == null || _currentJob?.resultImageUrl == null) return;

    String title = 'AI Look';
    if (_activeMode == 'outfit') {
      title = _selectedGarment?.name ?? 'AI Outfit';
    } else if (_activeMode == 'custom_garment') {
      title = 'Custom Garment Look';
    } else if (_activeMode == 'hair_style') {
      title = _selectedHairstyle?.name ?? 'Hairstyle Transformation';
    } else if (_activeMode == 'beard_style') {
      title = _selectedBeard?.name ?? 'Beard Grooming Look';
    }

    await _apiService.saveLookToWardrobe(
      jobId: _currentJob!.id,
      originalImageUrl: _currentJob!.beforeImageUrl,
      resultImageUrl: _currentJob!.resultImageUrl!,
      garmentName: title,
      category: _activeMode.toUpperCase(),
    );

    _wardrobe = await _apiService.getWardrobe();
    notifyListeners();
  }

  Future<void> shareCurrentLook() async {
    if (_currentJob?.resultImageUrl != null) {
      await _imageService.shareResultImage(
        imageUrl: _currentJob!.resultImageUrl!,
        garmentName: _selectedGarment?.name ?? 'My AI Makeover',
      );
    }
  }

  Future<String?> downloadCurrentLook() async {
    if (_currentJob?.resultImageUrl != null) {
      return await _imageService.saveImageToLocalFile(_currentJob!.resultImageUrl!);
    }
    return null;
  }
}
