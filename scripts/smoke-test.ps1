# Checks that the app answers on http://localhost:8090
param([int]$HostPort = 8090)
. "$PSScriptRoot\common.ps1"

Step "Smoke test on http://localhost:$HostPort/"
$code = ""
for ($i = 0; $i -lt 20; $i++) {
    $code = curl.exe -s -o NUL -w '%{http_code}' "http://localhost:$HostPort/"
    if ($code -eq "200") { break }
    Start-Sleep -Seconds 3
}
if ($code -ne "200") { Fail "App did not return HTTP 200 (got '$code'). Check: docker logs frontend-proxy and docker ps" }
Write-Host "PASS: http://localhost:$HostPort/ returned HTTP 200" -ForegroundColor Green
