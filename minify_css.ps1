$css = Get-Content "style.css" -Raw
# Remove comments
$css = $css -replace '/\*[\s\S]*?\*/', ''
# Remove whitespace around separators
$css = $css -replace '\s*{\s*', '{'
$css = $css -replace '\s*}\s*', '}'
$css = $css -replace '\s*;\s*', ';'
$css = $css -replace '\s*:\s*', ':'
# Collapse multiple spaces/newlines
$css = $css -replace '\s+', ' '
# Remove leading/trailing
$css = $css.Trim()

Set-Content "style.min.css" -Value $css -Encoding UTF8 -NoNewline
Write-Host "Minified/Stripped style.css to style.min.css"
