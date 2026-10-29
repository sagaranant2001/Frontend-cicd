# Makes sure Docker, Floci and the Floci registry are up and answering.
. "$PSScriptRoot\common.ps1"

Step "Checking Docker"
docker info *> $null
if ($LASTEXITCODE -ne 0) { Fail "Docker is not running. Start Docker Desktop, wait until it is ready, then run again." }
Write-Host "Docker is running."

Step "Starting Floci containers if they are stopped"
foreach ($c in @("floci", "floci-aws-ecr-registry")) {
    $state = docker inspect -f "{{.State.Running}}" $c 2>$null
    if ($LASTEXITCODE -ne 0) { Fail "Container '$c' does not exist. Create Floci first." }
    if ($state -ne "true") {
        Write-Host "Starting $c"
        docker start $c | Out-Null
        Check "docker start $c"
    } else {
        Write-Host "$c is already running."
    }
}
# Optional dashboard on http://localhost:4500 (ignore errors)
docker start floci-aws-ui *> $null

Step "Waiting for Floci on $EP"
$ok = $false
for ($i = 0; $i -lt 40; $i++) {
    aws --endpoint-url $EP sts get-caller-identity *> $null
    if ($LASTEXITCODE -eq 0) { $ok = $true; break }
    Start-Sleep -Seconds 3
}
if (-not $ok) { Fail "Floci did not answer on $EP. Check: docker logs floci --tail 40" }
Write-Host "Floci is up."

Step "Waiting for the registry on $REGISTRY"
$ok = $false
for ($i = 0; $i -lt 20; $i++) {
    curl.exe -s -f -o NUL "http://$REGISTRY/v2/"
    if ($LASTEXITCODE -eq 0) { $ok = $true; break }
    Start-Sleep -Seconds 2
}
if (-not $ok) { Fail "Registry did not answer on $REGISTRY" }
Write-Host "Registry is up."
