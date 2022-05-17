# vNet peerings

Create:

3 vNets (`hub-a`, `hub-b`, `spoke`)

`spoke` is peered to both hubs, only one peering can set `use_remote_gateway` to `true`

If you switch this setting from one peering to another, Terraform could fail

So we need to make sure the peerings with `use_remote_gateway = false` get **created before** the one with `use_remote_gateway = true`

## TODO

Need gateway in vNet to actually enable the `use_remote_gateway` setting !
