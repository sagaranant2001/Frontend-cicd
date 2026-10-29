# Floci keeps the ECS container on Docker's internal network, so we start a small
# proxy container that publishes it on http://localhost:8090.
param([int]$HostPort = 8090)
. "$PSScriptRoot\common.ps1"

Step "Finding the running frontend container"
$list = Get-FrontendContainers
if ($list.Count -eq 0) { Fail "No running ECS frontend container. Run: make deploy" }
$C = $list[0]
Write-Host "Container: $C"

$IP   = docker inspect $C --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
$NET  = docker inspect $C --format '{{range $k,$v := .NetworkSettings.Networks}}{{$k}}{{end}}'
$PORT = Awsl ecs describe-task-definition --task-definition $FAMILY --query "taskDefinition.containerDefinitions[0].portMappings[0].containerPort" --output text
if (-not $IP -or -not $NET -or -not $PORT) { Fail "Could not read IP, network or port (IP=$IP NET=$NET PORT=$PORT)" }
Write-Host "IP=$IP  Network=$NET  ContainerPort=$PORT"

Step "Starting the proxy on port $HostPort"
docker rm -f frontend-proxy *> $null
docker run -d --name frontend-proxy --network $NET -p "${HostPort}:80" alpine/socat TCP-LISTEN:80,fork,reuseaddr "TCP:${IP}:${PORT}" | Out-Null
Check "docker run frontend-proxy"
Write-Host "Open: http://localhost:$HostPort"
