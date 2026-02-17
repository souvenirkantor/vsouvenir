$files = Get-ChildItem -Path "f:\Anti Gravity Project\Maroon Souvenir violet" -Filter "*.html"

$fontBlock = @"
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
"@

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content.Contains('preconnect" href="https://fonts.googleapis.com"')) {
        Write-Host "Skipping $($file.Name) - already updated"
        continue
    }

    # Regex to find the target block
    # (?s) enables single-line mode where . matches newline, but we use \s* which matches whitespace including newlines
    $pattern = "(?s)<!-- Fonts & Icons -->\s*<link rel=""stylesheet"" href=""style.css"">"
    
    if ($content -match $pattern) {
        $content = $content -replace $pattern, $fontBlock
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    } else {
        Write-Host "Pattern not found in $($file.Name)"
    }
}
