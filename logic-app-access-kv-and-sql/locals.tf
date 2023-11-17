locals {
  private_endpoint_resources = {
    "vault" = {
      domain = "privatelink.vaultcore.azure.net"
    },
    "blob" = {
      domain = "privatelink.blob.core.windows.net"
    },
    "file" = {
      domain = "privatelink.file.core.windows.net"
    }
    "queue" = {
      domain = "privatelink.queue.core.windows.net"
    }
    "table" = {
      domain = "privatelink.table.core.windows.net"
    }
    "sqlServer" = {
      domain = "privatelink.database.windows.net"
    }
  }
}
