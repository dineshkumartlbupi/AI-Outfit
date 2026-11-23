# AI Outfit: Try On Clothes

A full-stack, AI-powered Virtual Try-On and Outfit Changer application inspired by and matching all features of **AI Outfit: Try On Clothes** (`com.ai_dev.try_on_ai`).

---

## 🌟 Features Implemented

1. **⚡ Change Outfits In Seconds (Home Dashboard)**
   - Dynamic Hero Banner with instant try-on CTA.
   - Quick category pills (*All Styles*, *Cozy Dresses*, *Work Shirts*, *Party Wear*, *Indian Ethnic*, *Men's Fashion*).
   - "Trending This Week" horizontal carousel with garment quick-launch cards.
   - Free daily try-on credits tracking pill.

2. **👗 Discover 3,000+ Trending Templates (Catalog Gallery)**
   - Dual-column responsive grid with high-resolution fashion models.
   - Real-time search by garment name, tag, fabric, and color.
   - Category filtering pills with smooth horizontal scrolling.
   - Garment tags: `TRENDING`, `NEW`, and focus area badges.
   - Interactive Garment Detail Bottom Sheet displaying fabric, styling description, color palette, and one-tap try-on.

3. **📸 Start With Your Real Look (Photo Ingestion & Guidelines)**
   - Photo guidelines card: solo portrait, well-lit, straight posture, fitted clothing.
   - Multi-source input:
     - **Take Photo** via camera
     - **Choose From Gallery**
     - **Sample Demo Models** (Instant test drive with pre-loaded male & female fashion models without needing to upload personal photos).

4. **🎯 Choose Your Focus Area (Body Framing)**
   - **Upper Body**: Tops, shirts, blouses, t-shirts, blazers, and jackets.
   - **Lower Body**: Trousers, denim jeans, shorts, and skirts.
   - **Full Body**: Dresses, sarees, jumpsuits, evening gowns, and full suits.
   - Real-time interactive focus box overlay highlighting the target AI inpainting boundary on the user's photo.

5. **✨ AI Virtual Try-On Processing Engine**
   - High-tech smooth animated progress indicator with live percentages.
   - Real-time stage messaging (*Analyzing pose contours*, *Warping garment fabric*, *Synthesizing realistic lighting and shadows*).
   - Pluggable AI engine support:
     - **Replicate IDM-VTON** (`yisol/idm-vton`)
     - **FASHN.ai Virtual Fitting Room API**
     - **Intelligent High-Fidelity Simulation Mode** (Zero setup, runs offline/locally out-of-the-box for instant development & testing).

6. **🔄 See Your Style Transformation (Interactive Before & After Slider)**
   - Custom hardware-accelerated 60/120fps draggable split divider.
   - Scrub smoothly between original photo and AI transformed outfit look.
   - Centered circular grip with directional indicators.
   - **Save HD Look**: Downloads high-definition result to device storage.
   - **Native Social Share**: Instant sharing to WhatsApp, Instagram Stories, Facebook, TikTok, and messaging apps.

7. **💖 My Saved Looks (Personal Wardrobe Lookbook)**
   - Persistent gallery of saved virtual transformations.
   - Tap any saved look to reopen full-screen before/after comparison slider.

---

## 🏗️ Architecture & Project Structure

```
AI Outfit/
├── ai_outfit_app/              # Flutter Mobile & Desktop Client
│   ├── lib/
│   │   ├── core/
│   │   │   ├── constants.dart  # API routes & network config
│   │   │   ├── theme.dart      # Dark luxury theme & vibrant gradients
│   │   │   └── mock_data.dart  # Offline fallback seed data
│   │   ├── models/             # Garment, Category, TryOnJob, SampleModel
│   │   ├── services/
│   │   │   ├── api_service.dart   # REST client
│   │   │   └── image_service.dart # Camera, Gallery & SharePlus
│   │   ├── state/
│   │   │   └── tryon_provider.dart # State management (Provider)
│   │   ├── widgets/
│   │   │   ├── split_slider.dart  # 60fps gesture Before/After slider
│   │   │   └── garment_card.dart  # High-definition template card
│   │   └── screens/
│   │       ├── main_navigation.dart    # Bottom nav shell
│   │       ├── home_screen.dart        # Featured carousel & discovery
│   │       ├── templates_screen.dart   # 2-column searchable catalog
│   │       ├── garment_detail_modal.dart # Garment specs bottom sheet
│   │       ├── photo_upload_screen.dart # Multi-source photo picker & models
│   │       ├── focus_area_screen.dart  # Upper/Lower/Full body selector
│   │       ├── processing_screen.dart  # Animated AI progress state
│   │       ├── result_screen.dart      # Split slider preview & save/share
│   │       └── wardrobe_screen.dart    # Saved lookbook gallery
│   └── pubspec.yaml
│
└── backend/                    # Node.js + TypeScript API Service
    ├── src/
    │   ├── data/
    │   │   └── templates.ts    # Curated templates catalog & sample models
    │   ├── routes/
    │   │   └── api.ts          # Express API endpoints
    │   ├── services/
    │   │   └── vton.service.ts # Pluggable AI engine (IDM-VTON, FASHN, Local)
    │   ├── types/
    │   │   └── index.ts        # Data contracts
    │   └── server.ts           # Server bootstrap
    ├── package.json
    └── tsconfig.json
```

---

## 🚀 Getting Started

### 1. Run the Backend API Service

```bash
cd backend
npm install
npm run dev
```

*The API runs at `http://localhost:3000` with live endpoints:*
- `GET /api/categories`: Category stats
- `GET /api/templates`: Curated outfits catalog
- `GET /api/sample-models`: Built-in demo models
- `POST /api/tryon`: Submit virtual try-on job
- `GET /api/tryon/status/:jobId`: Query generation progress
- `GET /api/wardrobe`: Saved looks

#### Configuring Live Frontier AI Providers (Optional)
To use cloud GPUs for diffusion inference, copy `.env.example` to `.env` in `backend/`:
```bash
REPLICATE_API_TOKEN=your_replicate_token_here
# or
FASHN_API_KEY=your_fashn_api_key_here
```
*(If omitted, the backend automatically uses intelligent simulation mode, allowing instant zero-cost testing).*

---

### 2. Run the Flutter Mobile App

```bash
cd ai_outfit_app

# To run on connected physical Android device:
flutter run -d 10BG8D1HN3001YJ

# Or run on macOS Desktop:
flutter run -d macos

# Or run in Google Chrome:
flutter run -d chrome
```

*(For Android devices, enable reverse port forwarding so the device can access the local server:)*
```bash
adb reverse tcp:3000 tcp:3000
```

