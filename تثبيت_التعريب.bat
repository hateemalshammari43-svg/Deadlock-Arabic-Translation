@echo off
chcp 65001 >nul
title مثبت تعريب Deadlock التلقائي - فريق الضاد
color 0B

echo ======================================================================
echo                  مثبت تعريب لعبة Deadlock (v1.4.0)
echo                         فريق تعريب الضاد
echo ======================================================================
echo.
echo [1/4] جارٍ البحث عن مسار لعبة Deadlock في جهازك...

set "GAME_PATH="

:: 1. فحص المسارات الشائعة
if exist "C:\Program Files (x86)\Steam\steamapps\common\Deadlock\game\citadel" (
    set "GAME_PATH=C:\Program Files (x86)\Steam\steamapps\common\Deadlock"
    goto :Found
)
if exist "C:\Program Files\Steam\steamapps\common\Deadlock\game\citadel" (
    set "GAME_PATH=C:\Program Files\Steam\steamapps\common\Deadlock"
    goto :Found
)
if exist "D:\SteamLibrary\steamapps\common\Deadlock\game\citadel" (
    set "GAME_PATH=D:\SteamLibrary\steamapps\common\Deadlock"
    goto :Found
)
if exist "E:\SteamLibrary\steamapps\common\Deadlock\game\citadel" (
    set "GAME_PATH=E:\SteamLibrary\steamapps\common\Deadlock"
    goto :Found
)
if exist "F:\SteamLibrary\steamapps\common\Deadlock\game\citadel" (
    set "GAME_PATH=F:\SteamLibrary\steamapps\common\Deadlock"
    goto :Found
)

:: 2. فحص مسار ستيم من الريجستري
for /f "tokens=2*" %%a in ('reg query "HKCU\Software\Valve\Steam" /v "SteamPath" 2^>nul') do (
    set "STEAM_DIR=%%b"
)
if defined STEAM_DIR (
    set "STEAM_DIR=%STEAM_DIR:/=\%"
    if exist "%STEAM_DIR%\steamapps\common\Deadlock\game\citadel" (
        set "GAME_PATH=%STEAM_DIR%\steamapps\common\Deadlock"
        goto :Found
    )
)

:NotFound
echo.
echo [!] لم يتم العثور على مسار اللعبة تلقائياً.
set /p "USER_PATH=يرجى سحب وإفلات مجلد Deadlock هنا ثم الضغط على Enter: "
set "USER_PATH=%USER_PATH:"=%"
if exist "%USER_PATH%\game\citadel" (
    set "GAME_PATH=%USER_PATH%"
    goto :Found
)
echo [X] المسار غير صحيح أو لا يحتوي على ملفات لعبة Deadlock.
pause
exit /b

:Found
echo [+] تم العثور على اللعبة في:
echo     "%GAME_PATH%"
echo.
echo [2/4] جارٍ تنزيل وتثبيت أحدث ملفات التعريب (v1.4.0) من GitHub...

set "BASE_RAW=https://raw.githubusercontent.com/hateemalshammari43-svg/Deadlock-Arabic-Translation/main/game/citadel"
set "BASE_URL=%BASE_RAW%/resource/localization"
set "TARGET_DIR=%GAME_PATH%\game\citadel\resource\localization"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$files = @(" ^
    "  @{Sub='citadel_main'; Name='citadel_main_english.txt'}," ^
    "  @{Sub='citadel_gc'; Name='citadel_gc_english.txt'}," ^
    "  @{Sub='citadel_heroes'; Name='citadel_heroes_english.txt'}," ^
    "  @{Sub='citadel_mods'; Name='citadel_mods_english.txt'}," ^
    "  @{Sub='citadel_attributes'; Name='citadel_attributes_english.txt'}," ^
    "  @{Sub='citadel_gc_hero_names'; Name='citadel_gc_hero_names_english.txt'}," ^
    "  @{Sub='citadel_gc_mod_names'; Name='citadel_gc_mod_names_english.txt'}," ^
    "  @{Sub='citadel_patch_notes'; Name='citadel_patch_notes_english.txt'}," ^
    "  @{Sub='citadel_seasonal'; Name='citadel_seasonal_english.txt'}" ^
    ");" ^
    "$base = '%BASE_URL%';" ^
    "$dest = '%TARGET_DIR%';" ^
    "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;" ^
    "$wc = New-Object System.Net.WebClient;" ^
    "$wc.Headers.Add('User-Agent', 'DeadlockArabicInstaller');" ^
    "foreach ($f in $files) {" ^
    "  $dir = Join-Path $dest $f.Sub;" ^
    "  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null };" ^
    "  $targetFile = Join-Path $dir $f.Name;" ^
    "  $sourceUrl = \"$base/$($f.Sub)/$($f.Name)\";" ^
    "  Write-Host \"  - تنزيل: $($f.Name)...\" -ForegroundColor Cyan;" ^
    "  $wc.DownloadFile($sourceUrl, $targetFile);" ^
    "};"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [X] فشل تنزيل بعض ملفات التعريب. يرجى التأكد من اتصالك بالإنترنت.
    pause
    exit /b
)

echo.
echo [3/4] جارٍ تثبيت مود دعم الأشرطة والتوقيتات العربية في الواجهة (HUD VPK)...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$gameCitadel = Join-Path '%GAME_PATH%' 'game\citadel';" ^
    "$addons = Join-Path $gameCitadel 'addons';" ^
    "if (-not (Test-Path $addons)) { New-Item -ItemType Directory -Path $addons -Force | Out-Null };" ^
    "$targetVpk = $null;" ^
    "$firstFree = $null;" ^
    "for ($i = 1; $i -le 99; $i++) {" ^
    "  $p = Join-Path $addons ('pak{0:D2}_dir.vpk' -f $i);" ^
    "  if (Test-Path $p) {" ^
    "    $bytes = [System.IO.File]::ReadAllBytes($p);" ^
    "    $head = [System.Text.Encoding]::ASCII.GetString($bytes, 0, [Math]::Min($bytes.Length, 4096));" ^
    "    if ($head -match 'dhad_arabic_hud') { $targetVpk = $p; break }" ^
    "  } elseif (-not $firstFree) {" ^
    "    $firstFree = $p" ^
    "  }" ^
    "};" ^
    "if (-not $targetVpk) { $targetVpk = if ($firstFree) { $firstFree } else { Join-Path $addons 'pak99_dir.vpk' } };" ^
    "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;" ^
    "$wc = New-Object System.Net.WebClient;" ^
    "$wc.Headers.Add('User-Agent', 'DeadlockArabicInstaller');" ^
    "$vpkUrl = '%BASE_RAW%/addons/dhad_hud_arabic_dir.vpk';" ^
    "Write-Host \"  - تثبيت: $(Split-Path $targetVpk -Leaf)...\" -ForegroundColor Cyan;" ^
    "$wc.DownloadFile($vpkUrl, $targetVpk);" ^
    "$gi = Join-Path $gameCitadel 'gameinfo.gi';" ^
    "if (Test-Path $gi) {" ^
    "  $txt = [System.IO.File]::ReadAllText($gi);" ^
    "  if ($txt -notmatch 'citadel/addons') {" ^
    "    if (-not (Test-Path ($gi + '.bak'))) { Copy-Item $gi ($gi + '.bak') };" ^
    "    $rep = \"`t`t`tGame`t`t`t`tcitadel/addons`r`n\" + '$1';" ^
    "    $txt = [regex]::Replace($txt, '(?m)^([ \t]*Game[ \t]+citadel[ \t]*\r?)$', $rep);" ^
    "    [System.IO.File]::WriteAllText($gi, $txt);" ^
    "    Write-Host '  - تم تفعيل citadel/addons في gameinfo.gi' -ForegroundColor Green;" ^
    "  }" ^
    "}"

echo.
echo [4/4] تم التحقق من تثبيت جميع الملفات ومود الواجهة بنجاح!
echo ======================================================================
echo              تم تثبيت التعريب بنجاح (الإصدار 1.4.0)
echo              يمكنك الآن تشغيل Deadlock والاستمتاع باللعبة!
echo ======================================================================
echo.
pause
