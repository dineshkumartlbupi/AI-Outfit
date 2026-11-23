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

// Serve uploaded images statically
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Mount API routes
app.use('/api', apiRouter);

// Health check / welcome route
app.get('/', (_req, res) => {
  res.json({
    app: 'AI Outfit: Try On Clothes - Backend API',
    status: 'ONLINE',
    version: '1.0.0',
    endpoints: [
      'GET /api/categories',
      'GET /api/templates',
      'GET /api/templates/:id',
      'GET /api/sample-models',
      'POST /api/upload',
      'POST /api/tryon',
      'GET /api/tryon/status/:jobId',
      'GET /api/wardrobe',
      'POST /api/wardrobe/save',
    ],
  });
});

app.listen(PORT, () => {
  console.log(`===============================================`);
  console.log(`🚀 AI Outfit VTON Server running on port ${PORT}`);
  console.log(`🌐 Base URL: http://localhost:${PORT}`);
  console.log(`⚡ API Docs: http://localhost:${PORT}/api/templates`);
  console.log(`===============================================`);
});
