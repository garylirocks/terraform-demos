locals {
  # image_tag = "dynatrace-only-202505170001"
  # image_tag = "dynatrace-only-garylitrial-202505180955"
  # image_tag = "datadog-and-dynatrace-garylitrial-202505190757"
  image_tag = "with-dd-tracer-202505201354"

  # secret name must be lowercase and hyphen '-'
  app_secrets = {
    "dd-service"               = "aca-001"
    "dd-version"               = "3.0.0"
    "dd-env"                   = "test"
    "dd-source"                = "nodejs"
    "dd-azure-subscription-id" = var.subscription_id
    "dd-azure-resource-group"  = "rg-aca-test-001"
    "dd-serverless-log-path"   = "/LogFiles/*.log"
    "dd-api-key"               = var.datadog_api_key
    "dd-logs-enabled"          = "true"
    "dd-logs-injection"        = "false"
    "dd-trace-sample-rate"     = "0.5"
  }

  # env names could have uppercase and underscore '_'
  common_env_vars = {
    "DD_SERVICE" = "dd-service"
    "DD_VERSION" = "dd-version"
    "DD_ENV"     = "dd-env"
  }

  app_env_vars = merge(local.common_env_vars, {
    # need to be here
    "DD_LOGS_INJECTION" = "dd-logs-injection"
    # could be on app container, not sure if works on the sidecar
    "DD_LOGS_ENABLED"      = "dd-logs-enabled"
    "DD_TRACE_SAMPLE_RATE" = "dd-trace-sample-rate"
  })

  sidecar_env_vars = merge(local.common_env_vars, {
    "DD_API_KEY"               = "dd-api-key"
    "DD_AZURE_SUBSCRIPTION_ID" = "dd-azure-subscription-id"
    "DD_AZURE_RESOURCE_GROUP"  = "dd-azure-resource-group"
    "DD_SERVERLESS_LOG_PATH"   = "dd-serverless-log-path"
    "DD_SOURCE"                = "dd-source" // must be set on the sidecar, will be "containerapp" if not set
  })
}
