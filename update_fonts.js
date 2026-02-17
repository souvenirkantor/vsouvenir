const fs = require('fs');
const path = require('path');

const dir = 'f:\\Anti Gravity Project\\Maroon Souvenir violet';
const files = fs.readdirSync(dir).filter(file => file.endsWith('.html'));

const fontLinks = `    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">`;

// Regex to find the target block, handling inconsistent whitespace/newlines
// We look for the comment, followed by any whitespace, followed by the style.css link
const oldPattern = /<!-- Fonts & Icons -->[\s\r\n]*<link rel="stylesheet" href="style.css">/;

let updatedCount = 0;

files.forEach(file => {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');

    // Skip if already has preconnect to google fonts
    if (content.includes('preconnect" href="https://fonts.googleapis.com"')) {
        console.log(`Skipping ${file} - already updated.`);
        return;
    }

    if (oldPattern.test(content)) {
        const newContent = content.replace(oldPattern, fontLinks);
        fs.writeFileSync(filePath, newContent, 'utf8');
        console.log(`Updated ${file}`);
        updatedCount++;
    } else {
        console.log(`Skipping ${file} - pattern not found.`);
    }
});

console.log(`Total files updated: ${updatedCount}`);
