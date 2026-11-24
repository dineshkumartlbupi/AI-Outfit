const fs = require('fs');
const path = require('path');
const cloudinary = require('../backend/node_modules/cloudinary').v2;

cloudinary.config({
  cloud_name: 'fnssc6ie',
  api_key: '671762316836573',
  api_secret: '6sY7Mesry4UjpaU4dZzY6ZKJoqI'
});

const bannersDir = path.join(__dirname, '..', 'store_assets', 'banners');
const files = [
  '01_change_outfits.png',
  '02_trending_templates.png',
  '03_style_transformation.png',
  '04_real_look.png',
  '05_focus_area.png',
  '06_save_share.png'
];

async function uploadAll() {
  console.log('Uploading 6 Play Store screenshots to Cloudinary...');
  const results = [];

  for (const file of files) {
    const filePath = path.join(bannersDir, file);
    if (!fs.existsSync(filePath)) {
      console.error(`File not found: ${filePath}`);
      continue;
    }

    const publicId = path.parse(file).name;
    console.log(`Uploading ${file}...`);
    try {
      const res = await cloudinary.uploader.upload(filePath, {
        folder: 'ai_outfit/playstore_screenshots',
        public_id: publicId,
        overwrite: true,
        resource_type: 'image'
      });
      console.log(`✓ Uploaded ${file} -> ${res.secure_url}`);
      results.push({
        file,
        public_id: res.public_id,
        secure_url: res.secure_url,
        width: res.width,
        height: res.height,
        bytes: res.bytes
      });
    } catch (err) {
      console.error(`Failed to upload ${file}:`, err);
    }
  }

  const outputPath = path.join(__dirname, '..', 'store_assets', 'cloudinary_banners.json');
  fs.writeFileSync(outputPath, JSON.stringify(results, null, 2));
  console.log(`Saved URLs to ${outputPath}`);
}

uploadAll();
