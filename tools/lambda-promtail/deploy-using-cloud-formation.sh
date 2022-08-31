aws ecr get-login-password --region us-west-2 --profile neoteric528 | docker login --username AWS --password-stdin 757986783975.dkr.ecr.us-west-2.amazonaws.com
docker pull public.ecr.aws/grafana/lambda-promtail:main-1c3f5d0-arm64
docker tag public.ecr.aws/grafana/lambda-promtail:main-1c3f5d0-arm64 757986783975.dkr.ecr.us-west-2.amazonaws.com/rapticore/lambda-promtail:latest
docker push 757986783975.dkr.ecr.us-west-2.amazonaws.com/rapticore/lambda-promtail:latest


aws cloudformation create-stack --stack-name lambda-promtail-stack --template-body file://template.yaml \
--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
--region us-west-2 \
--parameters ParameterKey=LambdaPromtailImage,ParameterValue=757986783975.dkr.ecr.us-west-2.amazonaws.com/rapticore/lambda-promtail:latest ParameterKey=WriteAddress,ParameterValue=https://logs-prod-us-central1.grafana.net/loki/api/v1/push ParameterKey=Username,ParameterValue=17135 ParameterKey=Password,ParameterValue=eyJrIjoiMzBlZTg5MWE3YTJkNWMxYzZlMTEzMzQ5NWU2ZmZmOTM0NzQ2YWVmNCIsIm4iOiJsYW1iZGEtcHJvbXRhaWwiLCJpZCI6NDU5ODQxfQ== ParameterKey=TenantID,ParameterValue=neoteric528 \
--profile neoteric528
