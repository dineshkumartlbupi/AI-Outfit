import sys
import os
import argparse
import urllib.request
import shutil
from gradio_client import Client, handle_file

def download_or_resolve(source_path_or_url, temp_dest):
    # Check if it refers to a local file in backend/uploads
    uploads_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../uploads")
    if "/uploads/" in source_path_or_url:
        filename = os.path.basename(source_path_or_url)
        local_cand = os.path.join(uploads_dir, filename)
        if os.path.exists(local_cand):
            return local_cand

    if os.path.exists(source_path_or_url):
        return source_path_or_url

    if source_path_or_url.startswith("http://") or source_path_or_url.startswith("https://"):
        urllib.request.urlretrieve(source_path_or_url, temp_dest)
        return temp_dest
    else:
        raise ValueError(f"Image source not found: {source_path_or_url}")

def main():
    parser = argparse.ArgumentParser(description="Run IDM-VTON Diffusion via Gradio")
    parser.add_argument("--human", required=True, help="Human image path or URL")
    parser.add_argument("--garment", required=True, help="Garment image path or URL")
    parser.add_argument("--output", required=True, help="Output image file path")
    parser.add_argument("--desc", default="stylish fashion clothing", help="Garment description")
    parser.add_argument("--steps", type=int, default=25, help="Diffusion steps")
    args = parser.parse_args()

    temp_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../uploads/temp")
    os.makedirs(temp_dir, exist_ok=True)

    human_local = os.path.join(temp_dir, f"h_{os.getpid()}.jpg")
    garm_local = os.path.join(temp_dir, f"g_{os.getpid()}.jpg")

    try:
        h_file = download_or_resolve(args.human, human_local)
        g_file = download_or_resolve(args.garment, garm_local)

        client = Client("yisol/IDM-VTON")
        result = client.predict(
            dict={"background": handle_file(h_file), "layers": [], "composite": None},
            garm_img=handle_file(g_file),
            garment_des=args.desc,
            is_checked=True,
            is_checked_crop=False,
            denoise_steps=args.steps,
            seed=42,
            api_name="/tryon"
        )

        out_img_path = result[0]
        os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
        shutil.copy(out_img_path, args.output)

        print(f"SUCCESS:{args.output}")
        sys.exit(0)
    except Exception as e:
        print(f"ERROR:{str(e)}", file=sys.stderr)
        sys.exit(1)
    finally:
        # Cleanup temp downloaded files if any
        if os.path.exists(human_local):
            try: os.remove(human_local)
            except: pass
        if os.path.exists(garm_local):
            try: os.remove(garm_local)
            except: pass

if __name__ == "__main__":
    main()
