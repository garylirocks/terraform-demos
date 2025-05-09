locals {
  # secret name must be lowercase and hyphen '-'
  app_secrets = {
    "dd-service" = "aca-001"
    "dd-version" = "1.0.0"
    "dd-env"     = "test"
  }

  # env names could have uppercase and underscore '_'
  datadog_env_vars = {
    "DD_SERVICE" = "dd-service"
    "DD_VERSION" = "dd-version"
    "DD_ENV"     = "dd-env"
  }
}
