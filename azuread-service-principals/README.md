# Azure AD service principals

This demos creating a service principal using another service principal.

1. Use my user principal to create a level 0 service principal (`sp-level0`), to create another service principal, `sp-level0` needs this directory role `Cloud application administrator`
2. Then we use `sp-level0` to create `sp-level1`, to authenticate use `sp-level0` credentials:

   ```sh
   cp load-sp-level0-secret.sh.example load-sp-level0-secret.sh

   # update the values

   # load them
   source ./load-sp-level0-secret.sh
   ```