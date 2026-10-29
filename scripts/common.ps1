# Shared settings and helpers. Every other script loads this first.
$env:AWS_ACCESS_KEY_ID     = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION    = "us-east-1"
$env:AWS_PAGER             = ""

$ROOT       = Split-Path -Parent $PSScriptRoot      # project root (frontend-deployment)
$EP         = "http://localhost:4566"               # Floci
$REGISTRY   = "localhost:5100"                      # Floci's registry container
$REPO       = "frontend-repo"
$CLUSTER    = "frontend-cluster"
$SERVICE    = "frontend-service"
$FAMILY     = "frontend-task"
$PIPELINE   = "frontend-pipeline"
$SRC_BUCKET = "frontend-pipeline-source"

function Step($msg)  { Write-Host ""; Write-Host "==> $msg" -ForegroundColor Cyan }
function Fail($msg)  { Write-Host "ERROR: $msg" -ForegroundColor Red; exit 1 }
function Check($what) { if ($LASTEXITCODE -ne 0) { Fail "$what failed (exit code $LASTEXITCODE)" } }
function Awsl { aws --endpoint-url $EP @args }

# Running ECS frontend containers, newest first
function Get-FrontendContainers {
    $names = docker ps --filter "name=floci-aws-ecs-" --format "{{.Names}}"
    @($names | Where-Object { $_ -and ($_ -like "*-frontend") -and ($_ -notlike "*react-frontend") })
}
