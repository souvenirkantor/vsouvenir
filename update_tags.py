import re

html_file = r"c:\vsouvenir-main\vsouvenir-main\blog.html"

with open(html_file, 'r', encoding='utf-8') as f:
    content = f.read()

colors = [
    {"bg": "#E0F2FE", "color": "#0284C7"}, # light blue
    {"bg": "#DCFCE7", "color": "#166534"}, # green
    {"bg": "#F3E8FF", "color": "#7E22CE"}, # purple
    {"bg": "#FEF9C3", "color": "#854D0E"}, # yellow
    {"bg": "#FCE7F3", "color": "#BE185D"}, # pink
    {"bg": "#E0E7FF", "color": "#3730A3"}, # indigo
    {"bg": "#CCFBF1", "color": "#0F766E"}, # teal
    {"bg": "#FFE4E6", "color": "#BE123C"}, # rose
]

def get_tag_info(href):
    if "lebaran" in href: return "HAMPERS LEBARAN", 0
    if "elegan" in href: return "SOUVENIR ELEGAN", 1
    if "supplier" in href: return "SUPPLIER HAMPERS", 2
    if "akhir-tahun" in href: return "HAMPERS AKHIR TAHUN", 3
    if "harga" in href: return "HARGA HAMPERS", 4
    if "paket" in href: return "PAKET HAMPERS", 5
    if "ide" in href: return "IDE SOUVENIR", 6
    if "karyawan" in href: return "SOUVENIR KARYAWAN", 7
    if "jasa" in href: return "JASA HAMPERS", 0
    if "isi" in href: return "ISI HAMPERS", 1
    if "manfaat" in href: return "MANFAAT SOUVENIR", 2
    if "perbedaan" in href: return "EDUKASI", 3
    if "vendor" in href: return "TIPS MEMILIH", 4
    if "biaya" in href: return "BUDGETING", 5
    if "rekomendasi" in href: return "REKOMENDASI", 6
    if "cara-memilih" in href: return "TIPS SOUVENIR", 7
    if "klien" in href: return "SOUVENIR KLIEN", 0
    if "box" in href: return "GIFT BOX", 1
    if "premium" in href: return "PREMIUM GIFT", 2
    if "unik" in href: return "SOUVENIR UNIK", 3
    if "murah" in href: return "SOUVENIR MURAH", 4
    if "promosi" in href: return "SOUVENIR PROMOSI", 5
    if "branding" in href: return "BRANDING", 6
    if "trend" in href: return "TREND SOUVENIR", 7
    return "CORPORATE INSIGHT", 0

pattern = re.compile(r'(<span class="article-tag"[^>]*>.*?</span>\s*<h3 class="article-title"><a href="([^"]+)")', re.DOTALL)

def replacer(match):
    full_match = match.group(1)
    href = match.group(2)
    tag_name, color_idx = get_tag_info(href)
    color = colors[color_idx]
    
    new_span = f'<span class="article-tag" style="background: {color["bg"]}; color: {color["color"]};">{tag_name}</span>'
    
    replaced = re.sub(r'<span class="article-tag"[^>]*>.*?</span>', new_span, full_match, flags=re.DOTALL)
    return replaced

new_content = pattern.sub(replacer, content)

with open(html_file, 'w', encoding='utf-8') as f:
    f.write(new_content)
print("Done")
