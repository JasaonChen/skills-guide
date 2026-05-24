$ErrorActionPreference = "Stop"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$bom = [byte[]]@(0xEF,0xBB,0xBF)

# Read files
$json = [System.IO.File]::ReadAllText("C:\Users\Agten\workspace\skills_data.json")
$json = $json.TrimStart([char]0xFEFF)
$skills = ConvertFrom-Json $json

$catMapContent = [System.IO.File]::ReadAllText("C:\Users\Agten\workspace\skills-guide\catmap.json")
$catMap = $catMapContent | ConvertFrom-Json
$totalSkills = $skills.Count

# Group skills by category
$grouped = @{}
foreach ($s in $skills) {
  if (-not $grouped.ContainsKey($s.category)) { $grouped[$s.category] = @() }
  $grouped[$s.category] += $s
}
$sortedCats = $grouped.Keys | Sort-Object { $grouped[$_].Count } -Descending
$totalCats = $sortedCats.Count
$dateStr = (Get-Date -Format "yyyy-MM-dd")

Write-Host ("Skills: $totalSkills, Cats: $totalCats")

# Chinese chars - must use string() cast, [char]+[char] does integer addition in PS
$cGuide = [string][char]0x6307 + [string][char]0x5357
$cPDF  = [string][char]0x53EF + [string][char]0x6253 + [string][char]0x5370 + [string][char]0x7248
$cSkills = [string][char]0x6280 + [string][char]0x80FD
$cCats = [string][char]0x5206 + [string][char]0x7C7B
$cTOC = [string][char]0x76EE + [string][char]0x5F55

# Build HTML
$html = "<!DOCTYPE html>"
$html += '<html lang="zh-CN"><head><meta charset="UTF-8"><title>Hermes Agent Skills '
$html += $cGuide
$html += '</title><style>'
$html += '@page{margin:2cm}*{margin:0;padding:0;box-sizing:border-box}'
$html += 'body{font-family:"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;'
$html += 'color:#1a1a2e;line-height:1.7;font-size:11pt;max-width:210mm;margin:0 auto;padding:2cm}'
$html += 'h1{font-size:24pt;color:#6c5ce7;margin-bottom:4pt}.subtitle{color:#666;font-size:12pt;margin-bottom:20pt}'
$html += 'hr{border:none;border-top:2px solid #6c5ce7;margin:16pt 0}'
$html += '.toc{margin:20pt 0}'
$html += '.toc h2{font-size:14pt;color:#6c5ce7;margin-bottom:8pt}'
$html += '.toc a{color:#2d3436;text-decoration:none;display:block;padding:3pt 0;font-size:10.5pt}'
$html += '.toc .toc-cat{font-weight:600;margin-top:4pt}'
$html += '.toc .toc-skill{padding-left:20pt}'
$html += '.category{page-break-before:always;margin-top:20pt}'
$html += '.category:first-of-type{page-break-before:avoid}'
$html += '.cat-header{background:#6c5ce7;color:#fff;padding:8pt 14pt;border-radius:6pt;'
$html += 'font-size:14pt;margin-bottom:10pt;display:flex;justify-content:space-between}'
$html += '.cat-header .cat-count{background:rgba(255,255,255,0.2);padding:1pt 10pt;border-radius:10pt;font-size:10pt}'
$html += '.skill{margin:6pt 0;padding:6pt 0 6pt 12pt;border-left:3px solid #dfe6e9}'
$html += '.skill-name{font-weight:600;font-size:11pt;color:#2d3436}'
$html += '.skill-desc{color:#555;font-size:10pt;margin-top:2pt}'
$html += '.skill-trigger{color:#6c5ce7;font-size:9pt;font-family:Consolas,"Courier New",monospace}'
$html += '.skill-tags{margin-top:2pt}'
$html += '.skill-tags span{display:inline-block;background:#f0f0f0;color:#666;font-size:8pt;padding:1pt 6pt;border-radius:3pt;margin-right:3pt}'
$html += '.footer{text-align:center;color:#aaa;font-size:9pt;margin-top:40pt;padding-top:10pt;border-top:1px solid #eee}'
$html += '@media print{body{padding:0}.skill{page-break-inside:avoid}}'
$html += '</style></head><body>'

# Title
$html += '<h1>Hermes Agent Skills ' + $cGuide + '</h1>'
$html += '<div class="subtitle">PDF ' + $cPDF + ' | '
$html += [string]$totalSkills + ' ' + $cSkills + ' | ' + [string]$totalCats + ' ' + $cCats
$html += ' | ' + $dateStr + '</div><hr>'

# TOC
$html += '<div class="toc"><h2>' + $cTOC + '</h2>'
foreach ($cat in $sortedCats) {
  $catName = $catMap.$cat
  if (-not $catName) { $catName = $cat }
  $count = $grouped[$cat].Count
  $html += '<div class="toc-cat"><a href="#cat-' + $cat + '">'
  $html += $catName + ' (' + $count + ')</a></div>'
  foreach ($s in $grouped[$cat]) {
    $title = $s.name
    if ($s.title) { $title = $s.title }
    $html += '<div class="toc-skill"><a href="#skill-' + $s.name + '">'
    $html += $title + '</a></div>'
  }
}
$html += '</div><hr>'

# Categories
$first = $true
foreach ($cat in $sortedCats) {
  $catName = $catMap.$cat
  if (-not $catName) { $catName = $cat }
  $count = $grouped[$cat].Count
  if ($first) { $first = $false }
  $html += '<div class="category">'
  $html += '<div class="cat-header" id="cat-' + $cat + '"><span>' + $catName
  $html += '</span><span class="cat-count">' + $count + ' ' + $cSkills + '</span></div>'
  foreach ($s in $grouped[$cat]) {
    $title = $s.name
    if ($s.title) { $title = $s.title }
    $desc = ""
    if ($s.desc) { $desc = $s.desc }
    $trigger = ""
    if ($s.trigger) { $trigger = $s.trigger }
    $html += '<div class="skill" id="skill-' + $s.name + '">'
    $html += '<div class="skill-name">' + $title + '</div>'
    if ($trigger) {
      $html += '<div class="skill-trigger">Trigger: ' + $trigger + '</div>'
    }
    if ($desc) {
      $html += '<div class="skill-desc">' + $desc + '</div>'
    }
    $html += '</div>'
  }
  $html += '</div>'
}

# Footer
$html += '<div class="footer">Hermes Agent Skills ' + $cGuide
$html += ' | ' + $totalSkills + ' ' + $cSkills + ' | ' + $totalCats + ' ' + $cCats + '</div>'
$html += '</body></html>'

# Write with UTF-8 BOM
$htmlBytes = $utf8NoBom.GetBytes($html)
$finalBytes = $bom + $htmlBytes
[System.IO.File]::WriteAllBytes("C:\Users\Agten\workspace\skills-guide\skills-guide-pdf.html", $finalBytes)
$size = (Get-Item "C:\Users\Agten\workspace\skills-guide\skills-guide-pdf.html").Length
Write-Host ("OK: skills-guide-pdf.html = " + $size + " bytes (" + [math]::Round($size/1KB) + " KB)")
