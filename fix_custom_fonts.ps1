$files = Get-ChildItem -Path . -Filter "*.html" -Exclude "index.html"

# Ini adalah blok HTML yang SUDAH TERBUKTI BERHASIL di index.html
# Kita akan memaksa semua file menggunakan blok ini.
$goldStandardBlock = @"
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
"@

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Pattern fleksibel untuk menangkap berbagai variasi blok font/link css sebelumnya
    # Mulai dari "Fonts & Icons" sampai baris FontAwesome (termasuk jika ada atribut media/onload yang aneh)
    # (?s) enable single-line mode (dot matches newline)
    $pattern = "(?s)<!-- Fonts & Icons -->.*?<link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css""[^>]*>(?:\s*<noscript>.*?</noscript>)?"
    
    if ($content -match $pattern) {
        # Ganti dengan blok standar emas
        $content = $content -replace $pattern, $goldStandardBlock
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Updated: $($file.Name)"
    } else {
        # Coba pattern alternatif jika pattern pertama gagal (misal untuk file yang belum pernah disentuh)
        # Cari area sekitar style.css
        $altPattern = "(?s)<!-- Fonts & Icons -->.*?<link rel=""stylesheet"" href=""style.css"">"
        if ($content -match $altPattern) {
             # Hati-hati di sini, kita perlu memastikan kita tidak menduplikasi font awesome jika sudah ada di bawahnya
             # Tapi demi konsistensi, kita timpa saja area Fonts & Icons
             $content = $content -replace $altPattern, $goldStandardBlock
             Write-Host "Updated (Alt Pattern): $($file.Name)"
             Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        } else {
             Write-Host "SKIPPED: $($file.Name) - Pattern not found, please check manually."
        }
    }
}
