locals {
  # image_tag = "dynatrace-only-202505170001"
  # image_tag = "dynatrace-only-garylitrial-202505180955"
  image_tag = "datadog-and-dynatrace-garylitrial-202505190757"

  # secret name must be lowercase and hyphen '-'
  app_secrets = {
    "dd-service"               = "aca-001"
    "dd-version"               = "2.2.0"
    "dd-env"                   = "test"
    "dd-source"                = "nodejs"
    "dd-azure-subscription-id" = var.subscription_id
    "dd-azure-resource-group"  = "rg-aca-test-001"
    "dd-serverless-log-path"   = "/LogFiles/app.log"
    "dd-api-key"               = var.datadog_api_key
    "dd-logs-enabled"          = "true"
    "dd-trace-sample-rate"     = "1.0"
    "dd-logs-injection"        = "true"
  }

  # env names could have uppercase and underscore '_'
  common_env_vars = {
    "DD_SERVICE"           = "dd-service"
    "DD_VERSION"           = "dd-version"
    "DD_ENV"               = "dd-env"
    "DD_SOURCE"            = "dd-source"
    "DD_LOGS_ENABLED"      = "dd-logs-enabled"
    "DD_TRACE_SAMPLE_RATE" = "dd-trace-sample-rate"
    "DD_LOGS_INJECTION"    = "dd-logs-injection"
  }

  all_env_vars = merge(local.common_env_vars, {
    "DD_AZURE_SUBSCRIPTION_ID" = "dd-azure-subscription-id"
    "DD_AZURE_RESOURCE_GROUP"  = "dd-azure-resource-group"
    "DD_API_KEY"               = "dd-api-key"
    "DD_SERVERLESS_LOG_PATH"   = "dd-serverless-log-path"
  })
}
