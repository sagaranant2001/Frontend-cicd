# Quick overview of what is running.
. "$PSScriptRoot\common.ps1"

Step "ECS service"
Awsl ecs describe-services --cluster $CLUSTER --services $SERVICE --query "services[0].{Status:status,Running:runningCount,Desired:desiredCount,TaskDef:taskDefinition}" --output table

Step "Running ECS frontend containers"
docker ps --filter "name=floci-aws-ecs-" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"

Step "Proxy"
docker ps --filter "name=frontend-proxy" --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

Step "Pipeline"
Awsl codepipeline get-pipeline-state --name $PIPELINE --query "stageStates[].{Stage:stageName,Status:latestExecution.status}" --output table
