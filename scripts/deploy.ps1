# Does what buildspec.yml does: build image, push to registry, register a new
# task definition, update the ECS service, wait for the new container.
# Optional: -ContainerPort 8501 (use when the app does not listen on port 80).
param([int]$ContainerPort = 0)
. "$PSScriptRoot\common.ps1"
Set-Location $ROOT

$TAG = Get-Date -Format yyyyMMddHHmmss
$IMG = "$REGISTRY/$REPO"

Step "docker build ($TAG)"
docker build -t "${IMG}:$TAG" -t "${IMG}:latest" .
Check "docker build"

Step "docker push"
docker push "${IMG}:$TAG"
Check "docker push $TAG"
docker push "${IMG}:latest"
Check "docker push latest"

Step "Registering a new task definition"
$json = Awsl ecs describe-task-definition --task-definition $FAMILY --query taskDefinition --output json | Out-String
Check "describe-task-definition (did terraform create the service? run: make infra)"
$td = $json | ConvertFrom-Json
$c = $td.containerDefinitions[0]
$c.image = "${IMG}:latest"
if ($ContainerPort -gt 0) {
    $c.portMappings[0].containerPort = $ContainerPort
    $c.portMappings[0].hostPort      = $ContainerPort
}
$newdef = [ordered]@{
    family                  = $td.family
    networkMode             = $td.networkMode
    requiresCompatibilities = $td.requiresCompatibilities
    cpu                     = $td.cpu
    memory                  = $td.memory
    executionRoleArn        = $td.executionRoleArn
    containerDefinitions    = $td.containerDefinitions
}
$newdef | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $ROOT "newtaskdef.json") -Encoding ascii
Awsl ecs register-task-definition --cli-input-json "file://newtaskdef.json" --query "taskDefinition.{Revision:revision,Image:containerDefinitions[0].image}" --output table
Check "register-task-definition"

Step "Updating the ECS service"
$before = Get-FrontendContainers
Awsl ecs update-service --cluster $CLUSTER --service $SERVICE --task-definition $FAMILY --force-new-deployment --query "service.{Status:status,TaskDef:taskDefinition}" --output table
Check "update-service"

Step "Waiting for the new container"
$newc = $null
for ($i = 0; $i -lt 40; $i++) {
    Start-Sleep -Seconds 3
    $now   = Get-FrontendContainers
    $fresh = @($now | Where-Object { $before -notcontains $_ })
    if ($fresh.Count -gt 0) { $newc = $fresh[0]; break }
}
if (-not $newc) { Fail "No new container appeared. Check: docker logs floci --tail 40" }
Write-Host "New container: $newc"
