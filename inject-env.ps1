# .env의 AMPLITUDE_API_KEY를 index.html에 주입합니다. (SECRET_KEY는 브라우저 코드에 넣지 않습니다)
$root = $PSScriptRoot
$key = (Get-Content "$root\.env" | Where-Object { $_ -match '^AMPLITUDE_API_KEY=' }) -replace '^AMPLITUDE_API_KEY=', ''
if (-not $key) { throw 'AMPLITUDE_API_KEY가 .env에 없습니다.' }
$path = "$root\index.html"
$html = Get-Content $path -Raw -Encoding UTF8
$html = [regex]::Replace($html, "window\.AMPLITUDE_API_KEY = '[^']*';", "window.AMPLITUDE_API_KEY = '$key';")
$html = $html -replace "window\.AMPLITUDE_API_KEY !== '[^']*'", "window.AMPLITUDE_API_KEY !== 'YOUR_AMPLITUDE_API_KEY'"
[IO.File]::WriteAllText($path, $html, (New-Object Text.UTF8Encoding $false))
Write-Host 'index.html에 API Key를 적용했습니다.'
