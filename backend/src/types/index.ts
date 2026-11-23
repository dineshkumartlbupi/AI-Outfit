export type FocusArea = 'upper_body' | 'lower_body' | 'full_body';

export type TryOnMode = 'outfit' | 'custom_garment' | 'hair_style' | 'beard_style';

export interface GarmentTemplate {
  id: string;
  name: string;
  category: string;
  focusArea: FocusArea;
  imageUrl: string;
  thumbnailUrl: string;
  description: string;
  tags: string[];
  isTrending?: boolean;
  isNew?: boolean;
  isPremium?: boolean;
  color?: string;
  fabric?: string;
}

export interface HairstyleOption {
  id: string;
  name: string;
  gender: 'female' | 'male' | 'all';
  type: 'cut' | 'color';
  value: string;
  previewUrl: string;
}

export interface BeardOption {
  id: string;
  name: string;
  type: string;
  previewUrl: string;
}

export interface BackgroundOption {
  id: string;
  name: string;
  category: string;
  previewUrl: string;
}

export interface SampleModel {
  id: string;
  name: string;
  gender: 'female' | 'male';
  imageUrl: string;
  thumbnailUrl: string;
  poseDescription: string;
}

export type JobStatus = 'QUEUED' | 'PROCESSING' | 'COMPLETED' | 'FAILED';

export interface TryOnJob {
  id: string;
  userId?: string;
  mode: TryOnMode;
  status: JobStatus;
  userImageUrl: string;
  garmentId?: string;
  garmentImageUrl?: string;
  customGarmentUrl?: string;
  focusArea: FocusArea;
  hairstyleId?: string;
  beardId?: string;
  backgroundId?: string;
  isHDEnhanced?: boolean;
  resultImageUrl?: string;
  beforeImageUrl: string;
  progress: number;
  message?: string;
  createdAt: string;
  completedAt?: string;
}

export interface WardrobeItem {
  id: string;
  jobId: string;
  title: string;
  category: string;
  originalImageUrl: string;
  resultImageUrl: string;
  garmentName: string;
  mode?: TryOnMode;
  createdAt: string;
  isFavorite: boolean;
}
