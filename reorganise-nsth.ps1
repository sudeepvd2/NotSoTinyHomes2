# NSTH Website Reorganiser
# Run from PowerShell inside C:\NSTHWebsite:
#   Unblock-File .\reorganise-nsth.ps1
#   .\reorganise-nsth.ps1

Set-Location $PSScriptRoot

if (-not (Test-Path "index.html")) {
    Write-Error "Run this script from inside C:\NSTHWebsite (index.html not found here)"
    exit 1
}

$folders = @(
    "pages",
    "images\hero",
    "images\sitebox",
    "images\freedom-10ft",
    "images\freedom-20ft",
    "images\freedom-30ft",
    "images\freedom-40ft"
)
foreach ($f in $folders) {
    New-Item -ItemType Directory -Path $f -Force | Out-Null
}

$moves = @(
    @{ src="freedom-10ft.html";             dst="pages\freedom-10ft.html" },
    @{ src="freedom-20ft.html";             dst="pages\freedom-20ft.html" },
    @{ src="freedom-30ft.html";             dst="pages\freedom-30ft.html" },
    @{ src="freedom-40ft.html";             dst="pages\freedom-40ft.html" },
    @{ src="certified.html";                dst="pages\certified.html" },
    @{ src="configure-options.html";        dst="pages\configure-options.html" },
    @{ src="40ft Brochure_Std.html";        dst="pages\40ft-brochure-std.html" },
    @{ src="main.jpg";                      dst="images\hero\hero-main.jpg" },
    @{ src="display_unit.jpg";              dst="images\hero\hero-display-unit.jpg" },
    @{ src="class1a_3d.jpg";                dst="images\hero\hero-class1a-3d.jpg" },
    @{ src="sitebox.jpg";                   dst="images\sitebox\sitebox-01.jpg" },
    @{ src="sitebox02.jpg";                 dst="images\sitebox\sitebox-02.jpg" },
    @{ src="freedom_10ft_01.jpg";           dst="images\freedom-10ft\exterior-01.jpg" },
    @{ src="freedom_10ft_02.jpg";           dst="images\freedom-10ft\exterior-02.jpg" },
    @{ src="10ft_floor_plan_01.png";        dst="images\freedom-10ft\floor-plan-01.png" },
    @{ src="10ft_layout_01.jpg";            dst="images\freedom-10ft\layout-01.jpg" },
    @{ src="freedom_20ft_01.jpg";           dst="images\freedom-20ft\exterior-01.jpg" },
    @{ src="freedom_20ft_02.png";           dst="images\freedom-20ft\exterior-02.png" },
    @{ src="freedom_20ft_03.jpg";           dst="images\freedom-20ft\exterior-03.jpg" },
    @{ src="freedom_20ft_04.jpg";           dst="images\freedom-20ft\exterior-04.jpg" },
    @{ src="20ft_floor_plan_01.jpg";        dst="images\freedom-20ft\floor-plan-01.jpg" },
    @{ src="20ft_layout_01.jpg";            dst="images\freedom-20ft\layout-01.jpg" },
    @{ src="20ft_interior_01.jpg";          dst="images\freedom-20ft\interior-01.jpg" },
    @{ src="20ft_interior_02.jpg";          dst="images\freedom-20ft\interior-02.jpg" },
    @{ src="20ft_interior_03.jpg";          dst="images\freedom-20ft\interior-03.jpg" },
    @{ src="20ft_interior_04.jpg";          dst="images\freedom-20ft\interior-04.jpg" },
    @{ src="20ft_interior_05.jpg";          dst="images\freedom-20ft\interior-05.jpg" },
    @{ src="20ft_interior_06.jpg";          dst="images\freedom-20ft\interior-06.jpg" },
    @{ src="20ft_interior_07.avif";         dst="images\freedom-20ft\interior-07.avif" },
    @{ src="20ft_interior_08.avif";         dst="images\freedom-20ft\interior-08.avif" },
    @{ src="20ft_interior_09.jpeg";         dst="images\freedom-20ft\interior-09.jpg" },
    @{ src="20ft_interior_10.jpeg";         dst="images\freedom-20ft\interior-10.jpg" },
    @{ src="20ft_interior_11.jpeg";         dst="images\freedom-20ft\interior-11.jpg" },
    @{ src="freedom_30ft_01.jpg";           dst="images\freedom-30ft\exterior-01.jpg" },
    @{ src="freedom_30ft_02.png";           dst="images\freedom-30ft\exterior-02.png" },
    @{ src="freedom_30ft_03.jpg";           dst="images\freedom-30ft\exterior-03.jpg" },
    @{ src="30ft_floor_plan_01.png";        dst="images\freedom-30ft\floor-plan-01.png" },
    @{ src="30ft_layout_01.jpg";            dst="images\freedom-30ft\layout-01.jpg" },
    @{ src="30ft_layout_02.jpg";            dst="images\freedom-30ft\layout-02.jpg" },
    @{ src="30ft_interior_01.jpeg";         dst="images\freedom-30ft\interior-01.jpg" },
    @{ src="30ft_interior_02.jpeg";         dst="images\freedom-30ft\interior-02.jpg" },
    @{ src="certified_30ft_01.jpg";         dst="images\freedom-30ft\certified-01.jpg" },
    @{ src="freedom_40ft_01.png";           dst="images\freedom-40ft\exterior-01.png" },
    @{ src="freedom_40ft_02.jpg";           dst="images\freedom-40ft\exterior-02.jpg" },
    @{ src="freedom_40ft_03.jpg";           dst="images\freedom-40ft\exterior-03.jpg" },
    @{ src="freedom_40ft_03.png";           dst="images\freedom-40ft\exterior-03b.png" },
    @{ src="40ft_floor_plan_custom_01.jpg"; dst="images\freedom-40ft\floor-plan-custom-01.jpg" },
    @{ src="40ft_interior_01.jpeg";         dst="images\freedom-40ft\interior-01.jpg" },
    @{ src="40ft_interior_02.jpeg";         dst="images\freedom-40ft\interior-02.jpg" },
    @{ src="40ft_interior_03.jpeg";         dst="images\freedom-40ft\interior-03.jpg" },
    @{ src="40ft_interior_04.jpeg";         dst="images\freedom-40ft\interior-04.jpg" },
    @{ src="40ft_interior_05.jpeg";         dst="images\freedom-40ft\interior-05.jpg" },
    @{ src="40ft_layout_01.jpg";            dst="images\freedom-40ft\layout-01.jpg" },
    @{ src="40ft_layout_02.jpg";            dst="images\freedom-40ft\layout-02.jpg" },
    @{ src="40ft_layout_03.jpg";            dst="images\freedom-40ft\layout-03.jpg" },
    @{ src="40ft_layout_custom_01.jpg";     dst="images\freedom-40ft\layout-custom-01.jpg" },
    @{ src="40ft_layout_custom_02.jpg.png"; dst="images\freedom-40ft\layout-custom-02.png" }
)

$pathMap = @{}
foreach ($m in $moves) {
    $oldName = $m.src
    $newPath = $m.dst -replace "\\", "/"
    $pathMap[$oldName] = $newPath
    if ($oldName -match "\.jpeg$") {
        $altOld = $oldName -replace "\.jpeg$", ".jpg"
        $pathMap[$altOld] = $newPath
    }
}

$log = @()
$log += "NSTH Website Reorganise Log"
$log += "=" * 60

foreach ($m in $moves) {
    if (Test-Path $m.src) {
        Move-Item -Path $m.src -Destination $m.dst -Force
        $log += "MOVED   $($m.src)  ->  $($m.dst)"
    } else {
        $log += "SKIP    $($m.src)  (not found)"
    }
}

$log += ""
$log += "HTML PATH UPDATES"
$log += "-" * 60

$htmlFiles = Get-ChildItem -Path "." -Filter "*.html" -Recurse

foreach ($html in $htmlFiles) {
    $content = Get-Content $html.FullName -Raw -Encoding UTF8
    $original = $content
    $changes = @()

    foreach ($old in $pathMap.Keys) {
        $new = $pathMap[$old]
        $resolvedNew = $new
        if ($html.DirectoryName -like "*\pages") {
            if ($new -like "images/*") {
                $resolvedNew = "../" + $new
            }
            if ($new -like "pages/*") {
                $resolvedNew = Split-Path $new -Leaf
            }
        }
        if ($content -match [regex]::Escape($old)) {
            $content = $content -replace [regex]::Escape($old), $resolvedNew
            $changes += "  $old  ->  $resolvedNew"
        }
    }

    if ($content -ne $original) {
        Set-Content $html.FullName -Value $content -Encoding UTF8 -NoNewline
        $log += ""
        $log += "UPDATED $($html.FullName)"
        $log += $changes
    }
}

$log | Out-File -FilePath "rename-log.txt" -Encoding UTF8
Write-Host ""
Write-Host "Done! Check rename-log.txt for a full list of changes." -ForegroundColor Green
$moved = ($moves | Where-Object { Test-Path $_.dst }).Count
Write-Host "Files moved: $moved of $($moves.Count)" -ForegroundColor Cyan
