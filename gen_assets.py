"""Generate large valid PNG assets with noise patterns for big filesize."""
import struct, zlib, os, random

def make_noise_png(path, w, h, seed=42):
    """Create a large PNG with random noise (poorly compressible)."""
    random.seed(seed)
    
    raw = bytearray()
    for y in range(h):
        raw.append(0)  # filter byte = None
        for x in range(w):
            # Random pixel data with slight color bias for space theme
            r = random.randint(0, 40)
            g = random.randint(0, 30)
            b = random.randint(20, 80)
            # Small chance of bright star
            if random.random() < 0.001:
                r = 255; g = 255; b = 255
            raw.extend([r, g, b, 255])

    compressed = zlib.compress(bytes(raw), 1)  # Fast compression, bigger output
    
    with open(path, 'wb') as f:
        f.write(b'\x89PNG\r\n\x1a\n')
        ihdr = struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0)
        chunk = b'IHDR' + ihdr
        crc = struct.pack('>I', zlib.crc32(chunk) & 0xffffffff)
        f.write(struct.pack('>I', len(ihdr)))
        f.write(chunk)
        f.write(crc)
        chunk = b'IDAT' + compressed
        crc = struct.pack('>I', zlib.crc32(chunk) & 0xffffffff)
        f.write(struct.pack('>I', len(compressed)))
        f.write(chunk)
        f.write(crc)
        f.write(struct.pack('>I', 0))
        f.write(b'IEND')
        f.write(struct.pack('>I', zlib.crc32(b'IEND') & 0xffffffff))

os.makedirs('assets/images/stories', exist_ok=True)
os.makedirs('assets/images/buddy', exist_ok=True)
os.makedirs('assets/images/skins', exist_ok=True)

# Bigger images + noise = bigger PNGs
target_mb = 20
total = 0
# Create images until we have ~20MB
for i in range(8):
    path = f'assets/images/stories/space_bg_{i:02d}.png'
    if os.path.exists(path):
        total += os.path.getsize(path)
        continue
    # 2000x2000 noise pixel image will be ~2-4MB depending on compression
    make_noise_png(path, 2000, 2000, seed=i)
    sz = os.path.getsize(path)
    total += sz
    print(f'  {os.path.basename(path)}: {sz/1024/1024:.1f}MB')
    if total >= target_mb * 1024 * 1024:
        break

print(f'\nTotal space asset size: {total/1024/1024:.1f}MB')
