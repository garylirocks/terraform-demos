# Create a diagnostic setting on a resource

## Overview

This is to test what permission you need on the Log Analytics Workspace (LAW) to create a diagnostic setting successfully

- It creates a storage account and adds diagnostic setting to it
- It's using a Terraform Cloud workspace backend, which is configured with a service principal, we need to test what permissions this SP needs on the LAW

- A pre-existing LAW is created by [log-diagnostic-workspace](../log-analytics-workspace/)
- The pre-existing LAW is in another subscription, so we can test permissions more easily

## Results

Seems the only permission required on the LAW is `Microsoft.OperationalInsights/workspaces/sharedKeys/action`

You could
- Create a custom role for this permission
- Or use either "Log Analytics Contributor" or "Monitoring Contributor", seems the main difference is
  - "Log Analytics Contributor": can install VM extensions
  - "Monitoring Contributor": can manage action groups, DCR, metric alerts, scheduled query alerts, alert action rules, Private link scopes, etc