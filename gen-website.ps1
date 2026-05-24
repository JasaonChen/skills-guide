$ErrorActionPreference = "Stop"

# Read skills data JSON
$json = [System.IO.File]::ReadAllText("C:\Users\Agten\workspace\skills_data.json")
$json = $json.TrimStart([char]0xFEFF)
Write-Host ("JSON loaded: " + $json.Length + " chars")

# Read category map from separate JSON file
$catMapContent = [System.IO.File]::ReadAllText("C:\Users\Agten\workspace\skills-guide\catmap.json")
Write-Host ("Cat map loaded: " + $catMapContent.Length + " chars")

# Read template
$template = [System.IO.File]::ReadAllText("C:\Users\Agten\workspace\skills-guide\index.html.template")
Write-Host ("Template loaded: " + $template.Length + " chars")

# Replace placeholders
$html = $template.Replace("__SKILLSDATA__", $json)
$html = $html.Replace("__CATMAP_DATA__", $catMapContent)

# Write output (UTF8 no BOM)
$bytes = [System.Text.Encoding]::UTF8.GetBytes($html)
[System.IO.File]::WriteAllBytes("C:\Users\Agten\workspace\skills-guide\index.html", $bytes)
$size = (Get-Item "C:\Users\Agten\workspace\skills-guide\index.html").Length
Write-Host ("OK: index.html = " + $size + " bytes (" + [math]::Round($size/1KB) + " KB)")
