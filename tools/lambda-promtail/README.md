# lambda-promtail

This is a sample template for lambda-promtail - Below is a brief explanation of what we have generated for you:

```bash
.
├── Makefile                    <-- Make to automate build
├── README.md                   <-- This instructions file
├── hello-world                 <-- Source code for a lambda function
│   └── main.go                 <-- Lambda function code
└── template.yaml
```

## Requirements

* AWS CLI already configured with Administrator permission
* [Docker installed](https://www.docker.com/community-edition)
* [Golang](https://golang.org)
* SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)

## Setup process

### Installing dependencies & building the target

In this example we use the built-in `sam build` to automatically download all the dependencies and package our build target.
Read more about [SAM Build here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-build.html)

The `sam build` command is wrapped inside of the `Makefile`. To execute this simply run

```shell
make
```

### Local development

**Invoking function locally

```bash
make dry-run
```

## Packaging and deployment

AWS Lambda Golang runtime requires a flat folder with the executable generated on build step. SAM will use `CodeUri` property to know where to look up for the application:

```bash
make build
```

### Getting AWS CLI keys

Before you try to deploy, make sure to update your AWS config with CLI keys. SAM defaults to `default` profile name, but you can pass a different name during the guided deployment session.

### Deploying

To deploy your application for the first time, first make sure you've set the following parameters in the template:
- `PromtailAddress` (in the format of `https://<USER_ID>:<API_KEY>@<>URL/api/prom/push` - find more details in Rapticore's Grafana Cloud -> Loki Settings)
- `ReservedConcurrency` (defaults to 2)
- `TenantId` (e.g. `demo`)

These can also be set via overrides by passing the following argument to `sam deploy`:

> Make sure to escape quotes with `\` in `--parameter-overrides` if you see errors.

```bash
sam deploy --guided --profile default \
  --capabilities CAPABILITY_NAMED_IAM \
  --config-file "samconfig-example.toml" \
  --parameter-overrides PromtailAddress=<>,TenantId=<>
```
Also, if your deployment requires a VPC configuration, make sure to edit the `VpcConfig` field in the `template.yaml` manually.

The command above will package and deploy your application to AWS with a series of prompts, most important ones being:

* **Confirm changes before deploy**: Set it to `yes` to verify changes before deployment.
* **Save arguments to samconfig.toml**: To be able to re-run the script, make sure to pass a name of the file to save the config into, e.g. `dev1.toml`. Next time you deploy the same app into `dev1` environment, you can just re-run `sam deploy` without parameters to deploy changes to your application. **Make sure never to commit that file as it includes secrets, and all toml files are gitignored**.

### Redeploying

:bangbang: CAVEAT:

> I have not found a way to automate this process and make sure anyone can re-deploy to the same stack. I can't commit config files because they include Loki secrets (and this is a public fork). The guided deployment starts by checking whether there's an exisitng S3 bucket where it can backup the files, and creates one with the correct policy if there isn't one.
>
> I tried deploying a stack that would create the S3 bucket with the correct policies, and passed it to SAM CLI using correct params, but it keeps failing claiming it can't find the bucket. It may be a bug, and I just gave up on solving it.
>
> Let's get back to it when it's a problem. Until then Daria will keep the configs and do the deployments.

You can re-deploy the stack, e.g. when adding additional log groups into the `template.yaml`.

# Appendix

### Golang installation

Please ensure Go 1.x (where 'x' is the latest version) is installed as per the instructions on the official golang website: https://golang.org/doc/install

A quickstart way would be to use Homebrew, chocolatey or your linux package manager.

#### Homebrew (Mac)

Issue the following command from the terminal:

```shell
brew install golang
```

If it's already installed, run the following command to ensure it's the latest version:

```shell
brew update
brew upgrade golang
```

#### Chocolatey (Windows)

Issue the following command from the powershell:

```shell
choco install golang
```

If it's already installed, run the following command to ensure it's the latest version:

```shell
choco upgrade golang
```

## Limitations
- Error handling: If promtail is unresponsive, `lambda-promtail` will drop logs after `retry_count`, which defaults to 2.
- AWS does not support passing log lines over 256kb to lambdas.
