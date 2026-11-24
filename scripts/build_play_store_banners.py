import os
import subprocess
import base64
import sys

# Paths
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STORE_ASSETS_DIR = os.path.join(ROOT_DIR, 'store_assets')
BANNERS_DIR = os.path.join(STORE_ASSETS_DIR, 'banners')
TEMP_HTML_DIR = os.path.join(ROOT_DIR, 'tmp_banner_html')
CHROME_BIN = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

os.makedirs(BANNERS_DIR, exist_ok=True)
os.makedirs(TEMP_HTML_DIR, exist_ok=True)

# Icon
icon_path = os.path.join(STORE_ASSETS_DIR, 'app_icon_512x512.png')
with open(icon_path, 'rb') as f:
    icon_b64 = base64.b64encode(f.read()).decode('utf-8')

screens = [
    {
        'id': '01_change_outfits',
        'title': 'CHANGE OUTFITS<br>IN SECONDS',
        'subtitle': 'Instant virtual try-on, trendy templates and realistic outfit previews.',
        'pills': [('✨', 'Virtual Try-On'), ('👗', '3,000+ Outfits'), ('⚡', 'Easy to Use')],
        'input': os.path.join(STORE_ASSETS_DIR, '01_home_screen.png')
    },
    {
        'id': '02_trending_templates',
        'title': 'DISCOVER<br>TRENDING TEMPLATES',
        'subtitle': 'Browse dresses, blazers, Indian ethnic, party gowns & streetwear.',
        'pills': [('🔍', 'Easy Browse'), ('👗', '3,000+ Styles'), ('✨', 'All Categories')],
        'input': os.path.join(STORE_ASSETS_DIR, '02_templates_catalog.png')
    },
    {
        'id': '03_style_transformation',
        'title': 'SEE BEFORE & AFTER<br>TRANSFORMATION',
        'subtitle': 'Slide to compare original photo and transformed outfit instantly.',
        'pills': [('🔄', '60fps Slider'), ('✨', 'Realistic Draping'), ('⚡', 'HD Quality')],
        'input': os.path.join(STORE_ASSETS_DIR, '06_before_after_slider.png')
    },
    {
        'id': '04_real_look',
        'title': 'START WITH<br>YOUR REAL LOOK',
        'subtitle': 'Upload your own photo or choose from diverse studio models.',
        'pills': [('📸', 'Camera & Gallery'), ('🌟', 'Studio Models'), ('🔒', '100% Private')],
        'input': os.path.join(STORE_ASSETS_DIR, '04_photo_guidelines.png')
    },
    {
        'id': '05_focus_area',
        'title': 'CHOOSE YOUR<br>FOCUS AREA',
        'subtitle': 'Pick full body, upper body, or lower body for perfect fitting.',
        'pills': [('🎯', 'Target Zone'), ('✨', 'Precision Fit'), ('👗', 'Smart Framing')],
        'input': os.path.join(STORE_ASSETS_DIR, '05_focus_area.png')
    },
    {
        'id': '06_save_share',
        'title': 'SAVE & SHARE<br>YOUR HD LOOKS',
        'subtitle': 'Export high-resolution styles directly to your gallery or social media.',
        'pills': [('💾', 'Crystal HD'), ('📲', '1-Tap Share'), ('✨', 'No Watermark')],
        'input': os.path.join(STORE_ASSETS_DIR, '03_garment_detail.png')
    }
]

def make_html(screen):
    with open(screen['input'], 'rb') as f:
        img_b64 = base64.b64encode(f.read()).decode('utf-8')

    pills_html = ""
    for icon, text in screen['pills']:
        pills_html += f'''
        <div class="pill">
          <div class="pill-icon">{icon}</div>
          <span>{text}</span>
        </div>'''

    return f'''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@700;800;900&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap');

  * {{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }}

  body {{
    width: 1080px;
    height: 2400px;
    background: #FFF0F5;
    background: radial-gradient(circle at 50% 15%, #FFFFFF 0%, #FFF0F6 40%, #FFE4EF 100%);
    font-family: 'Plus Jakarta Sans', sans-serif;
    position: relative;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    align-items: center;
  }}

  .wave-bg {{
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    pointer-events: none;
    z-index: 1;
  }}

  .sparkle {{
    position: absolute;
    fill: #FF2E7E;
    opacity: 0.85;
    z-index: 2;
  }}

  .app-badge {{
    margin-top: 100px;
    display: flex;
    align-items: center;
    gap: 16px;
    z-index: 10;
  }}

  .app-badge img {{
    width: 52px;
    height: 52px;
    border-radius: 14px;
    box-shadow: 0 4px 14px rgba(255, 46, 126, 0.3);
  }}

  .app-badge span {{
    font-family: 'Outfit', sans-serif;
    font-size: 32px;
    font-weight: 800;
    letter-spacing: 3px;
    color: #1A0B2E;
  }}

  .title-wrap {{
    margin-top: 40px;
    text-align: center;
    z-index: 10;
    position: relative;
    padding: 0 40px;
  }}

  .main-title {{
    font-family: 'Outfit', sans-serif;
    font-size: 80px;
    font-weight: 900;
    line-height: 1.08;
    text-transform: uppercase;
    letter-spacing: -1px;
    background: linear-gradient(135deg, #FF1A75 0%, #D80065 40%, #3B0764 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }}

  .subtitle {{
    margin-top: 24px;
    font-size: 30px;
    font-weight: 500;
    color: #554866;
    max-width: 820px;
    line-height: 1.35;
  }}

  .pills-row {{
    margin-top: 44px;
    display: flex;
    gap: 16px;
    z-index: 10;
  }}

  .pill {{
    background: #FFFFFF;
    border: 2px solid #FFD0E3;
    padding: 14px 28px;
    border-radius: 40px;
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 24px;
    font-weight: 700;
    color: #2D1445;
    box-shadow: 0 6px 18px rgba(255, 46, 126, 0.1);
  }}

  .pill-icon {{
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: #FF2E7E;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
  }}

  .phone-container {{
    margin-top: 60px;
    width: 880px;
    height: 1680px;
    background: #0D0A14;
    border-radius: 76px;
    padding: 20px;
    box-shadow: 0 40px 90px rgba(45, 12, 70, 0.35), 0 0 0 6px #2A1A3E, 0 0 0 10px #150824;
    position: relative;
    z-index: 10;
    display: flex;
    flex-direction: column;
    align-items: center;
  }}

  .phone-camera {{
    position: absolute;
    top: 36px;
    width: 28px;
    height: 28px;
    background: #000;
    border-radius: 50%;
    z-index: 20;
    border: 2px solid #1C1226;
  }}

  .phone-screen {{
    width: 100%;
    height: 100%;
    border-radius: 60px;
    overflow: hidden;
    position: relative;
    background: #000;
  }}

  .phone-screen img {{
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: top;
  }}
</style>
</head>
<body>

  <svg class="wave-bg" viewBox="0 0 1080 2400" preserveAspectRatio="none">
    <defs>
      <linearGradient id="grad1" x1="0%" y1="100%" x2="100%" y2="50%">
        <stop offset="0%" stop-color="#FF1A75" stop-opacity="0.45" />
        <stop offset="50%" stop-color="#D80065" stop-opacity="0.2" />
        <stop offset="100%" stop-color="#FFFFFF" stop-opacity="0" />
      </linearGradient>
      <linearGradient id="grad2" x1="100%" y1="100%" x2="0%" y2="30%">
        <stop offset="0%" stop-color="#FF4D94" stop-opacity="0.35" />
        <stop offset="100%" stop-color="#FFFFFF" stop-opacity="0" />
      </linearGradient>
      <pattern id="dots" x="0" y="0" width="40" height="40" patternUnits="userSpaceOnUse">
        <circle cx="4" cy="4" r="3" fill="#FF1A75" opacity="0.15" />
      </pattern>
    </defs>
    <path d="M-100 2400 C 200 2100, 400 1700, 0 1400 C -200 1200, -200 2400, -100 2400 Z" fill="url(#grad1)" />
    <path d="M1180 2400 C 800 2150, 700 1600, 1180 1300 Z" fill="url(#grad2)" />
    <path d="M-50 2400 C 400 2400, 500 1900, -50 1700 Z" fill="url(#dots)" />
  </svg>

  <svg class="sparkle" style="top: 240px; left: 90px; width: 44px; height: 44px;" viewBox="0 0 24 24">
    <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
  </svg>
  <svg class="sparkle" style="top: 360px; right: 80px; width: 50px; height: 50px;" viewBox="0 0 24 24">
    <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
  </svg>
  <svg class="sparkle" style="top: 920px; left: 40px; width: 64px; height: 64px; opacity: 0.6;" viewBox="0 0 24 24">
    <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
  </svg>
  <svg class="sparkle" style="top: 1400px; right: 50px; width: 56px; height: 56px; opacity: 0.6;" viewBox="0 0 24 24">
    <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
  </svg>

  <div class="app-badge">
    <img src="data:image/png;base64,{icon_b64}" alt="Icon">
    <span>AI OUTFIT</span>
  </div>

  <div class="title-wrap">
    <h1 class="main-title">{screen['title']}</h1>
    <p class="subtitle">{screen['subtitle']}</p>
  </div>

  <div class="pills-row">
    {pills_html}
  </div>

  <div class="phone-container">
    <div class="phone-camera"></div>
    <div class="phone-screen">
      <img src="data:image/png;base64,{img_b64}" alt="Screen">
    </div>
  </div>

</body>
</html>
'''

print(f"Building {len(screens)} Google Play Store screenshots...")
for idx, screen in enumerate(screens, 1):
    html_path = os.path.join(TEMP_HTML_DIR, f"{screen['id']}.html")
    with open(html_path, 'w') as f:
        f.write(make_html(screen))

    out_banner = os.path.join(BANNERS_DIR, f"{screen['id']}.png")
    out_store = os.path.join(STORE_ASSETS_DIR, f"play_store_{idx:02d}_{screen['id']}.png")

    cmd = [
        CHROME_BIN,
        '--headless',
        '--disable-gpu',
        f'--screenshot={out_banner}',
        '--window-size=1080,2400',
        '--hide-scrollbars',
        f'file://{html_path}'
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    # Also copy to store_assets root for direct Play Store upload
    if os.path.exists(out_banner):
        with open(out_banner, 'rb') as src, open(out_store, 'wb') as dst:
            dst.write(src.read())
        print(f"[{idx}/{len(screens)}] Generated: {out_banner} ({os.path.getsize(out_banner)} bytes)")
    else:
        print(f"[{idx}/{len(screens)}] Failed to generate {out_banner}")

print("All screenshots generated successfully!")
