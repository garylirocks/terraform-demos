resource "azurerm_container_app" "demo" {
  name                         = "ca-test-001"
  container_app_environment_id = azurerm_container_app_environment.demo.id
  resource_group_name          = azurerm_resource_group.demo.name
  revision_mode                = "Single"
  # workload_profile_name        = "Consumption"
  max_inactive_revisions = 20

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name   = "simple-hello-world-container"
      image  = "docker.io/garylirocks/node-express-hello:${local.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      dynamic "env" {
        for_each = local.app_env_vars

        content {
          name        = env.key
          secret_name = env.value
        }
      }

      volume_mounts {
        name = "logs-ephemeral"
        path = "/LogFiles"
      }
    }

    container {
      name   = "datadog"
      image  = "docker.io/datadog/serverless-init:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      dynamic "env" {
        for_each = local.sidecar_env_vars

        content {
          name        = env.key
          secret_name = env.value
        }
      }

      volume_mounts {
        name = "logs-ephemeral"
        path = "/LogFiles"
      }
    }

    # volume {
    #   name         = "logs"
    #   storage_name = "cae-test-001-storage-logs"
    #   storage_type = "AzureFile"
    # }

    volume {
      name         = "logs-ephemeral"
      storage_type = "EmptyDir" // "Ephemeral" in the Portal
    }
  }

  dynamic "secret" {
    for_each = local.app_secrets

    content {
      name  = secret.key
      value = secret.value
    }
  }
}
