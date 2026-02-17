$files = Get-ChildItem -Path . -Filter "*.html" | Where-Object { $_.Name -ne "index.html" }

$goldBlockStart = "<!-- Fonts & Icons -->"
$goldBlockEnd = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" # Baris terakhir blok target
# Blok lengkap yang akan disisipkan
$goldBlock = @"
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
    
    # Mencari blok font lama dengan Regex yang lebih toleran
    # Kita asumsikan blok font dimulai dengan komentar Fonts & Icons dan diakhiri dengan baris yang mengandung font-awesome
    # (?s) dot matches newline
    # Pola: <!--Font & Icons--> ... (sesuatu) ... font-awesome ...
    $pattern = "(?s)<!-- Fonts & Icons -->.*?<link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css""[^>]*>(:?\s*<noscript>.*?</noscript>)?"
    
    if ($content -match $pattern) {
        $content = $content -replace $pattern, $goldBlock
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Updated: $($file.Name)"
    } else {
        # Jika pattern font-awesome tidak ditemukan (mungkin dihapus manual?), coba cari style.css saja
        $patternAlt = "(?s)<!-- Fonts & Icons -->.*?<link rel=""stylesheet"" href=""style.css"">"
        if ($content -match $patternAlt) {
            # Hati-hati, jika kita pakai ini, font-awesome mungkin belum ada, jadi kita tambahkan
            # Tapi kita harus cek baris setelahnya apakah ada font-awesome manual
            # Untuk amannya, kita ganti blok style.css dengan blok lengkap (termasuk font-awesome)
            # Dan jika ada font-awesome duplikat setelahnya, itu urusan belakangan (minor issue dibanding broken fonts)
            $content = $content -replace $patternAlt, $goldBlock
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "Updated (Alt Pattern): $($file.Name)"
        } else {
             Write-Host "Manual Check Required: $($file.Name)"
        }
    }
}
