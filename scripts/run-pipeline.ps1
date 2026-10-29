# Zips the source, uploads it to the source bucket and starts CodePipeline.
# NOTE: Floci's CodeBuild only simulates the build. The real build is in deploy.ps1.
. "$PSScriptRoot\common.ps1"
Set-Location $ROOT

Step "Creating source.zip"
Remove-Item source.zip -ErrorAction SilentlyContinue
$items = @("frontend", "Dockerfile", "nginx.conf", ".dockerignore", "buildspec.yml") | Where-Object { Test-Path $_ }
tar -a -c -f source.zip @items
Check "tar"
Write-Host ("Zipped: " + ($items -join ", "))

Step "Uploading to s3://$SRC_BUCKET/source.zip"
Awsl s3 cp source.zip "s3://$SRC_BUCKET/source.zip"
Check "s3 cp (did terraform create the buckets? run: make infra)"

Step "Starting pipeline $PIPELINE"
Awsl codepipeline start-pipeline-execution --name $PIPELINE
Check "start-pipeline-execution"

Step "Waiting for the pipeline stages"
$out = ""
for ($i = 0; $i -lt 20; $i++) {
    Start-Sleep -Seconds 4
    $out = (Awsl codepipeline get-pipeline-state --name $PIPELINE --query "stageStates[].[stageName,latestExecution.status]" --output text | Out-String)
    if ($out -notmatch "InProgress") { break }
}
Write-Host $out
if ($out -match "Failed") { Write-Host "WARNING: a stage failed. Check: aws codebuild batch-get-builds" -ForegroundColor Yellow }
Write-Host "Reminder: Floci simulates CodeBuild, so the image is built and deployed by 'make deploy'." -ForegroundColor Yellow
