"""Simple preprocessing script."""

import pathlib
from PIL import Image

RAW_DIR = pathlib.Path('../data/raw_images')
PROC_DIR = pathlib.Path('../data/processed_images')
PROC_DIR.mkdir(parents=True, exist_ok=True)

for img_path in RAW_DIR.glob('*.jpg'):
    img = Image.open(img_path).convert('L')
    out_path = PROC_DIR / img_path.name
    img.save(out_path)
    print(f"processed {img_path} -> {out_path}")
