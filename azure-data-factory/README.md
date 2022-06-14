# Azure Data Factory

Create two ADF, one as dev, one as prod.

Then use ARM template for sub-resources deployment, as recommended here: https://docs.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery-improvements

Configs:

1. dev ADF is connected to the ADF repo




Use workspace to manage the two envs:

Create workspaces:

```sh
tf workspace new dev
tf workspace new prod
```

Work in "dev"

```sh
tf workspace select dev
# ...
tf apply -var-file dev.tfvars
```

Work in "prod"

```sh
tf workspace select prod
# ...
tf apply -var-file prod.tfvars
```