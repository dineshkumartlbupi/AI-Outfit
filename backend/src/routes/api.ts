import { Router, Request, Response } from 'express';
import {
  CATEGORIES,
  GARMENT_TEMPLATES,
  SAMPLE_MODELS,
  HAIRSTYLES,
  BEARD_STYLES,
  BACKGROUND_OPTIONS,
} from '../data/templates';
import { vtonService } from '../services/vton.service';
import { cloudinaryService } from '../services/cloudinary.service';
import { FocusArea, TryOnMode, WardrobeItem } from '../types';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { v4 as uuidv4 } from 'uuid';

const router = Router();

// Upload directory
const uploadDir = path.join(__dirname, '../../uploads');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, uploadDir);
  },
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname) || '.jpg';
    cb(null, `upload_${Date.now()}_${uuidv4()}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 15 * 1024 * 1024 }, // 15MB
});

const wardrobeStore: WardrobeItem[] = [];

/**
 * 1. Categories
 */
router.get('/categories', (_req: Request, res: Response) => {
  res.json({
    success: true,
    data: CATEGORIES,
  });
});

/**
 * 2. Templates Gallery
 */
router.get('/templates', (req: Request, res: Response) => {
  const { category, search, focusArea, trending } = req.query;

  let filtered = [...GARMENT_TEMPLATES];

  if (category && category !== 'all') {
    filtered = filtered.filter((t) => t.category === category);
  }

  if (focusArea) {
    filtered = filtered.filter((t) => t.focusArea === focusArea);
  }

  if (trending === 'true') {
    filtered = filtered.filter((t) => t.isTrending);
  }

  if (search && typeof search === 'string') {
    const q = search.toLowerCase();
    filtered = filtered.filter(
      (t) =>
        t.name.toLowerCase().includes(q) ||
        t.description.toLowerCase().includes(q) ||
        t.tags.some((tag) => tag.toLowerCase().includes(q))
    );
  }

  res.json({
    success: true,
    count: filtered.length,
    data: filtered,
  });
});

/**
 * 3. Specific Template
 */
router.get('/templates/:id', (req: Request, res: Response) => {
  const template = GARMENT_TEMPLATES.find((t) => t.id === (req.params.id as string));
  if (!template) {
    return res.status(404).json({ success: false, message: 'Template not found' });
  }
  res.json({ success: true, data: template });
});

/**
 * 4. Sample Models
 */
router.get('/sample-models', (_req: Request, res: Response) => {
  res.json({
    success: true,
    data: SAMPLE_MODELS,
  });
});

/**
 * 5. Reference App 2 Features: Hairstyles, Beards & Backgrounds
 */
router.get('/hairstyles', (_req: Request, res: Response) => {
  res.json({ success: true, data: HAIRSTYLES });
});

router.get('/beards', (_req: Request, res: Response) => {
  res.json({ success: true, data: BEARD_STYLES });
});

router.get('/backgrounds', (_req: Request, res: Response) => {
  res.json({ success: true, data: BACKGROUND_OPTIONS });
});

/**
 * 6. Direct Photo Upload (User photo or custom garment)
 */
router.post('/upload', upload.single('photo'), async (req: Request, res: Response) => {
  if (!req.file) {
    return res.status(400).json({ success: false, message: 'No image uploaded' });
  }

  const host = req.get('host');
  const protocol = req.protocol;
  let imageUrl = `${protocol}://${host}/uploads/${req.file.filename}`;

  // Upload to Cloudinary CDN for persistent storage and fast worldwide delivery
  try {
    const cdnUrl = await cloudinaryService.uploadLocalFile(req.file.path, 'user_uploads');
    if (cdnUrl) {
      imageUrl = cdnUrl;
    }
  } catch (err: any) {
    console.warn('[Cloudinary Upload Warning] Fallback to local URL:', err?.message || err);
  }

  res.json({
    success: true,
    imageUrl,
    filename: req.file.filename,
    size: req.file.size,
  });
});

/**
 * 7. Submit Try-On / Styling Job
 */
router.post('/tryon', async (req: Request, res: Response) => {
  try {
    const {
      userImageUrl,
      mode,
      garmentId,
      garmentImageUrl,
      customGarmentUrl,
      focusArea,
      hairstyleId,
      beardId,
      backgroundId,
      enhanceHD,
    } = req.body;

    if (!userImageUrl) {
      return res.status(400).json({
        success: false,
        message: 'userImageUrl is required. Please upload or select a photo.',
      });
    }

    const selectedFocusArea: FocusArea = focusArea || 'full_body';
    const tryOnMode: TryOnMode = mode || (customGarmentUrl ? 'custom_garment' : 'outfit');

    const job = await vtonService.submitTryOn({
      userImageUrl,
      mode: tryOnMode,
      garmentId,
      garmentImageUrl,
      customGarmentUrl,
      focusArea: selectedFocusArea,
      hairstyleId,
      beardId,
      backgroundId,
      enhanceHD,
    });

    res.json({
      success: true,
      message: 'Styling job created successfully',
      data: job,
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: error.message || 'Internal server error while starting try-on',
    });
  }
});

/**
 * 8. Query Try-On Status
 */
router.get('/tryon/status/:jobId', (req: Request, res: Response) => {
  const jobId = req.params.jobId as string;
  const job = vtonService.getJob(jobId);
  if (!job) {
    return res.status(404).json({ success: false, message: 'Try-on job not found' });
  }

  res.json({
    success: true,
    data: job,
  });
});

/**
 * 9. AI Enhance (Boost to HD)
 */
router.post('/enhance', async (req: Request, res: Response) => {
  try {
    const { jobId } = req.body;
    if (!jobId) {
      return res.status(400).json({ success: false, message: 'jobId is required' });
    }
    const job = await vtonService.enhanceJob(jobId);
    res.json({ success: true, message: 'Photo boosted to HD', data: job });
  } catch (err: any) {
    res.status(500).json({ success: false, message: err.message });
  }
});

/**
 * 10. Background Switcher
 */
router.post('/change-background', async (req: Request, res: Response) => {
  try {
    const { jobId, backgroundId } = req.body;
    if (!jobId || !backgroundId) {
      return res.status(400).json({ success: false, message: 'jobId and backgroundId required' });
    }
    const job = await vtonService.changeBackground(jobId, backgroundId);
    res.json({ success: true, message: 'Background switched', data: job });
  } catch (err: any) {
    res.status(500).json({ success: false, message: err.message });
  }
});

/**
 * 11. Wardrobe Management (Saved Looks)
 */
router.get('/wardrobe', (_req: Request, res: Response) => {
  res.json({
    success: true,
    count: wardrobeStore.length,
    data: wardrobeStore,
  });
});

router.post('/wardrobe/save', (req: Request, res: Response) => {
  const { jobId, originalImageUrl, resultImageUrl, garmentName, category, mode } = req.body;

  if (!resultImageUrl || !originalImageUrl) {
    return res.status(400).json({ success: false, message: 'Image URLs are required' });
  }

  const item: WardrobeItem = {
    id: uuidv4(),
    jobId: jobId || uuidv4(),
    title: garmentName || 'My Styling Look',
    category: category || 'Custom',
    originalImageUrl,
    resultImageUrl,
    garmentName: garmentName || 'Styling',
    mode,
    createdAt: new Date().toISOString(),
    isFavorite: false,
  };

  wardrobeStore.unshift(item);

  res.json({
    success: true,
    message: 'Look saved to wardrobe!',
    data: item,
  });
});

router.delete('/wardrobe/:id', (req: Request, res: Response) => {
  const itemId = req.params.id as string;
  const index = wardrobeStore.findIndex((w) => w.id === itemId);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Item not found in wardrobe' });
  }

  wardrobeStore.splice(index, 1);
  res.json({ success: true, message: 'Item deleted from wardrobe' });
});

export default router;
