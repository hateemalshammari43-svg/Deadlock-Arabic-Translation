# تحديث مستودع GitHub لتعريب Deadlock
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "تحديث مستودع GitHub - تعريب Deadlock" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# إضافة كل الملفات المعدلة والجديدة
Write-Host "1. جاري تجهيز الملفات..." -ForegroundColor Yellow
git add .

# طلب رسالة التثبيت (Commit Message) أو استخدام قيمة افتراضية
$commitMsg = Read-Host "أدخل وصفاً للتعديلات (أو اضغط Enter لاستخدام الوصف الافتراضي)"
if ([string]::IsNullOrWhiteSpace($commitMsg)) {
    $commitMsg = "تحديث ملفات التعريب والمصطلحات"
}

Write-Host "2. جاري حفظ التعديلات محلياً..." -ForegroundColor Yellow
git commit -m $commitMsg

Write-Host "3. جاري رفع الملفات إلى GitHub..." -ForegroundColor Yellow
Write-Host "قد تظهر لك نافذة لتسجيل الدخول إلى GitHub، يرجى إكمال تسجيل الدخول إذا طُلِب منك ذلك." -ForegroundColor Magenta
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nتم تحديث GitHub بنجاح! 🎉" -ForegroundColor Green
} else {
    Write-Host "`nحدث خطأ أثناء الرفع. تأكد من اتصال الإنترنت وصلاحيات الوصول." -ForegroundColor Red
}

Write-Host "`nاضغط على أي مفتاح للإغلاق..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
