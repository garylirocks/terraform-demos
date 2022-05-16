# Private DNS Zones linked to peered vnets

Create:

1. Resource group A
    1. vNet A
    1. Private DNS Zone A, linked to vNet A
        1. record 'test.private.example.com' -> '1.1.1.1'
    1. VM A, in vNet A

1. Resource group B
    1. vNet B
    1. Private DNS Zone B, linked to vNet B
        2. record 'test.private.example.com' -> '2.2.2.2'
    1. VM B, in vNet B

3. vNet peering between A and B
    - Allow forwarded traffic from A to B
    - Block forwarded traffic from A to B

I was told the vNet peering and the traffic forwarding settings would affect the private DNS resolving.

After testing:

`nslookup test.private.example.com` in VM A resolves to `1.1.1.1`,
VM B should resolves to `2.2.2.2`

Seems there's no conflict between the two Private DNS Zones
