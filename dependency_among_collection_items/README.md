# Dependencies among collection items

Create:

3 vNets, one vNet has a `last` flag, it must be created last

To achieve this:

- you create one block resource block for the last vnet, and another block for all other vnets, and use `depends_on` to enforce execution order
- when you move the `last` flag from one item to another, you could use `moved` block to make sure resources are not recreated
