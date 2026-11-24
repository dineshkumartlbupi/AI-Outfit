import { v2 as cloudinary, UploadApiResponse } from 'cloudinary';
import fs from 'fs';

// Configure Cloudinary
const cloudName = process.env.CLOUDINARY_CLOUD_NAME || 'fnssc6ie';
const apiKey = process.env.CLOUDINARY_API_KEY || '671762316836573';
const apiSecret = process.env.CLOUDINARY_API_SECRET || '6sY7Mesry4UjpaU4dZzY6ZKJoqI';

if (cloudName && apiKey && apiSecret) {
  cloudinary.config({
    cloud_name: cloudName,
    api_key: apiKey,
    api_secret: apiSecret,
    secure: true,
  });
  console.log(`[Cloudinary] Initialized with cloud: ${cloudName}`);
}

export class CloudinaryService {
  /**
   * Check if Cloudinary is configured and ready
   */
  public isConfigured(): boolean {
    return Boolean(cloudName && apiKey && apiSecret);
  }

  /**
   * Upload a local file from disk to Cloudinary
   * @param filePath Absolute path of local file
   * @param subfolder Subfolder name under 'ai_outfit' (e.g. 'uploads', 'results')
   * @param publicId Optional public_id to identify image
   * @returns HTTPS secure URL on Cloudinary CDN, or null if failed
   */
  public async uploadLocalFile(
    filePath: string,
    subfolder: string = 'uploads',
    publicId?: string
  ): Promise<string | null> {
    if (!this.isConfigured() || !fs.existsSync(filePath)) {
      return null;
    }

    try {
      const options: any = {
        folder: `ai_outfit/${subfolder}`,
        resource_type: 'image',
        overwrite: true,
      };

      if (publicId) {
        options.public_id = publicId;
      }

      const result: UploadApiResponse = await cloudinary.uploader.upload(filePath, options);
      console.log(`[Cloudinary] Successfully uploaded: ${result.secure_url}`);
      return result.secure_url;
    } catch (err: any) {
      console.error(`[Cloudinary] Upload failed for ${filePath}:`, err?.message || err);
      return null;
    }
  }

  /**
   * Upload an in-memory Buffer to Cloudinary
   */
  public async uploadBuffer(
    buffer: Buffer,
    subfolder: string = 'results',
    publicId?: string
  ): Promise<string | null> {
    if (!this.isConfigured()) {
      return null;
    }

    return new Promise((resolve) => {
      const options: any = {
        folder: `ai_outfit/${subfolder}`,
        resource_type: 'image',
        overwrite: true,
      };

      if (publicId) {
        options.public_id = publicId;
      }

      const stream = cloudinary.uploader.upload_stream(options, (error, result) => {
        if (error || !result) {
          console.error('[Cloudinary] Buffer upload failed:', error?.message || error);
          resolve(null);
        } else {
          console.log(`[Cloudinary] Buffer uploaded: ${result.secure_url}`);
          resolve(result.secure_url);
        }
      });

      stream.end(buffer);
    });
  }
}

export const cloudinaryService = new CloudinaryService();
