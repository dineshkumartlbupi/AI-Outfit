import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import path from 'path';
import apiRouter from './routes/api';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Serve static frontend files (Landing Page, Assets, APK)
app.use(express.static(path.join(__dirname, '../public')));

// Serve uploaded images statically
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Mount API routes
app.use('/api', apiRouter);

// Legal & Download Web Routes
app.get('/privacy', (_req, res) => {
  res.sendFile(path.join(__dirname, '../public/privacy.html'));
});

app.get('/privacy-policy', (_req, res) => {
  res.sendFile(path.join(__dirname, '../public/privacy.html'));
});

app.get('/terms', (_req, res) => {
  res.sendFile(path.join(__dirname, '../public/terms.html'));
});

app.get('/terms-of-service', (_req, res) => {
  res.sendFile(path.join(__dirname, '../public/terms.html'));
});

app.get('/download', (_req, res) => {
  const apkPath = path.join(__dirname, '../public/ai-outfit.apk');
  res.download(apkPath, 'AI-Outfit.apk');
});

app.get('/screenshots', (_req, res) => {
  res.sendFile(path.join(__dirname, '../public/screenshots.html'));
});

app.get('/download-screenshots', (_req, res) => {
  const zipPath = path.join(__dirname, '../public/play-store-screenshots.zip');
  res.download(zipPath, 'AI-Outfit-Play-Store-Screenshots-1080x2400.zip');
});

// Health check endpoint
app.get('/api/health', (_req, res) => {
  res.json({
    app: 'AI Outfit: Try On Clothes - Backend API',
    status: 'ONLINE',
    version: '1.0.0',
    endpoints: [
      'GET /api/categories',
      'GET /api/templates',
      'GET /api/sample-models',
      'POST /api/upload',
      'POST /api/tryon',
      'GET /api/tryon/status/:jobId',
      'GET /api/wardrobe',
    ],
  });
});

app.listen(PORT, () => {
  console.log(`===============================================`);
  console.log(`🚀 AI Outfit Full-Stack Server running on port ${PORT}`);
  console.log(`🌐 Web Landing Page: http://localhost:${PORT}`);
  console.log(`🔒 Privacy Policy:   http://localhost:${PORT}/privacy`);
  console.log(`📲 App Download:     http://localhost:${PORT}/download`);
  console.log(`⚡ API Docs:         http://localhost:${PORT}/api/templates`);
  console.log(`===============================================`);
});
