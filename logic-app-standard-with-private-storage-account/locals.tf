locals {
  location            = "Australia East"
  resource_group_name = "rg-gary-logicapp-888"

  private_endpoint_resources = {
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
  }
}
